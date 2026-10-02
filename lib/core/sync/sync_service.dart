import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:ripped/core/db/app_database.dart';

/// The server side of sync, behind an interface so tests can fake it.
abstract interface class SyncRemote {
  /// Inserts or updates [rows] (server keeps the newest `updated_at`).
  Future<void> upsert(String table, List<Map<String, Object?>> rows);

  /// Rows changed after [since] (server `synced_at`), oldest first.
  Future<List<Map<String, Object?>>> pull(
    String table, {
    required String? since,
    required int limit,
  });
}

enum SyncOutcome {
  ok,

  /// This phone's data belongs to a different account; nothing was sent.
  otherAccount,
}

@immutable
class SyncReport {
  const new({required this.outcome, this.pushed = 0, this.pulled = 0});

  final SyncOutcome outcome;
  final int pushed;
  final int pulled;
}

/// Outbox push + cursor pull (architecture.md 5, option B).
///
/// * Push: rows queued in `sync_outbox` by SQLite triggers are uploaded
///   table by table. An entry is cleared only if the row didn't change
///   again while uploading.
/// * Pull: rows with a newer server `synced_at` than the stored cursor are
///   applied when their `updated_at` is newer than the local copy (last
///   write wins). Applying sets `sync.applying` so the triggers don't queue
///   them for upload again.
/// * First sync on a phone uploads everything created before sign-in.
class SyncService {
  new(this._db, this._remote);

  final AppDatabase _db;
  final SyncRemote _remote;

  static const batchSize = 200;
  static const _ownerKey = 'sync.owner';
  static String _cursorKey(String table) => 'sync.cursor.$table';

  static const _boolColumns = {'active', 'skipped', 'is_warmup'};

  /// Device-only fields the server never sees (it derives user_id itself).
  static const _localOnly = {'user_id'};

  /// Server-only fields the device never stores.
  static const _remoteOnly = {'synced_at', 'user_id'};

  Future<SyncReport> sync({required String userId}) async {
    final owner = await _setting(_ownerKey);
    if (owner != null && owner != userId) {
      return const SyncReport(outcome: SyncOutcome.otherAccount);
    }
    if (owner == null) {
      // First sync on this phone: upload everything made before sign-in.
      await _enqueueAll();
      await _setSetting(_ownerKey, userId);
    }
    final pushed = await _push();
    final pulled = await _pull();
    return SyncReport(outcome: SyncOutcome.ok, pushed: pushed, pulled: pulled);
  }

  /// Forgets which account owns the local data (after account deletion).
  Future<void> reset() async {
    await (_db.delete(_db.settings)
          ..where((s) => s.key.equals(_ownerKey) | s.key.like('sync.cursor.%')))
        .go();
    await _db.delete(_db.syncOutbox).go();
  }

  // ---------------------------------------------------------------- push

  Future<void> _enqueueAll() async {
    for (final t in AppDatabase.syncedTables) {
      await _db.customStatement(
        'INSERT OR IGNORE INTO sync_outbox (tbl, row_id, seq) '
        "SELECT '$t', id, 0 FROM $t",
      );
    }
  }

  Future<int> _push() async {
    var total = 0;
    for (final table in AppDatabase.syncedTables) {
      while (true) {
        final entries =
            await (_db.select(_db.syncOutbox)
                  ..where((o) => o.tbl.equals(table))
                  ..limit(batchSize))
                .get();
        if (entries.isEmpty) break;

        final rows = await _db
            .customSelect(
              'SELECT * FROM $table WHERE id IN '
              '(${List.filled(entries.length, '?').join(', ')})',
              variables: [for (final e in entries) Variable(e.rowId)],
            )
            .get();
        if (rows.isNotEmpty) {
          await _remote.upsert(table, [for (final r in rows) _toRemote(r)]);
        }
        total += rows.length;

        // Clear only entries whose row hasn't changed since we read it.
        await _db.transaction(() async {
          for (final e in entries) {
            await (_db.delete(_db.syncOutbox)..where(
                  (o) =>
                      o.tbl.equals(e.tbl) &
                      o.rowId.equals(e.rowId) &
                      o.seq.equals(e.seq),
                ))
                .go();
          }
        });
        if (entries.length < batchSize) break;
      }
    }
    return total;
  }

  Map<String, Object?> _toRemote(QueryRow row) {
    final out = <String, Object?>{};
    row.data.forEach((key, value) {
      if (_localOnly.contains(key)) return;
      out[key] = switch (value) {
        null => null,
        _ when _boolColumns.contains(key) => value == 1 || value == true,
        final String s when key.endsWith('_at') => _utc(s),
        _ => value,
      };
    });
    return out;
  }

  /// Drift stores DateTimes as ISO-8601 text; the server wants UTC.
  static String _utc(String stored) =>
      DateTime.parse(stored).toUtc().toIso8601String();

  // ---------------------------------------------------------------- pull

  Future<int> _pull() async {
    var total = 0;
    for (final table in AppDatabase.syncedTables) {
      var cursor = await _setting(_cursorKey(table));
      while (true) {
        final rows = await _remote.pull(table, since: cursor, limit: batchSize);
        if (rows.isEmpty) break;
        total += await _apply(table, rows);
        cursor = rows.last['synced_at']! as String;
        await _setSetting(_cursorKey(table), cursor);
        if (rows.length < batchSize) break;
      }
    }
    return total;
  }

  /// Writes the remote rows that are newer than the local copies.
  Future<int> _apply(String table, List<Map<String, Object?>> rows) =>
      _db.transaction(() async {
        await _setSetting(AppDatabase.applyingKey, '1');
        try {
          final ids = [for (final r in rows) r['id']! as String];
          final local = {
            for (final r
                in await _db
                    .customSelect(
                      'SELECT id, updated_at FROM $table WHERE id IN '
                      '(${List.filled(ids.length, '?').join(', ')})',
                      variables: [for (final id in ids) Variable(id)],
                    )
                    .get())
              r.read<String>('id'): DateTime.parse(
                r.read<String>('updated_at'),
              ),
          };

          var applied = 0;
          for (final row in rows) {
            final updated = DateTime.parse(row['updated_at']! as String);
            final mine = local[row['id']];
            if (mine != null && !updated.isAfter(mine)) continue;
            if (table == 'exercise_states' &&
                !await _resolveExerciseState(row, updated)) {
              continue;
            }
            await _upsertLocal(table, row);
            applied++;
          }
          return applied;
        } finally {
          await (_db.delete(
            _db.settings,
          )..where((s) => s.key.equals(AppDatabase.applyingKey))).go();
        }
      });

  /// `exercise_states` is unique per exercise. Two phones can each create
  /// a row for the same exercise; keep whichever was updated last.
  Future<bool> _resolveExerciseState(
    Map<String, Object?> row,
    DateTime updated,
  ) async {
    final clash =
        await (_db.select(_db.exerciseStates)..where(
              (s) =>
                  s.exerciseId.equals(row['exercise_id']! as String) &
                  s.id.equals(row['id']! as String).not(),
            ))
            .getSingleOrNull();
    if (clash == null) return true;
    if (!updated.isAfter(clash.updatedAt)) return false;
    await (_db.delete(
      _db.exerciseStates,
    )..where((s) => s.id.equals(clash.id))).go();
    return true;
  }

  /// Writes via `customUpdate` so Drift's watchers refresh the UI.
  Future<void> _upsertLocal(String table, Map<String, Object?> row) {
    final columns = [
      for (final k in row.keys)
        if (!_remoteOnly.contains(k)) k,
    ];
    final assignments = [
      for (final c in columns)
        if (c != 'id') '$c = excluded.$c',
    ].join(', ');
    return _db.customUpdate(
      'INSERT INTO $table (${columns.join(', ')}) '
      'VALUES (${List.filled(columns.length, '?').join(', ')}) '
      'ON CONFLICT (id) DO UPDATE SET $assignments',
      variables: [for (final c in columns) _toLocalVariable(c, row[c])],
      updates: {_db.allTables.firstWhere((t) => t.actualTableName == table)},
      updateKind: UpdateKind.update,
    );
  }

  static Variable<Object> _toLocalVariable(String key, Object? value) =>
      switch (value) {
        null => const Variable(null),
        final String s when key.endsWith('_at') => Variable<DateTime>(
          DateTime.parse(s).toLocal(),
        ),
        final bool b => Variable<bool>(b),
        final int n => Variable<int>(n),
        final double d => Variable<double>(d),
        final String s => Variable<String>(s),
        final Object o => Variable<String>(o.toString()),
      };

  // ---------------------------------------------------------------- settings

  Future<String?> _setting(String key) async => (await (_db.select(
    _db.settings,
  )..where((s) => s.key.equals(key))).getSingleOrNull())?.value;

  Future<void> _setSetting(String key, String value) => _db
      .into(_db.settings)
      .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));
}
