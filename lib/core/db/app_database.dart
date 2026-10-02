import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:ripped/core/db/tables.dart';

export 'package:ripped/core/db/tables.dart';

part 'app_database.g.dart';

/// The on-device user database: single source of truth (architecture.md 1).
@DriftDatabase(
  tables: [
    Profiles,
    Programs,
    ProgramDays,
    ProgramExercises,
    Workouts,
    WorkoutExercises,
    WorkoutSets,
    ExerciseStates,
    Settings,
    XpEvents,
    PersonalRecords,
    SyncOutbox,
  ],
)
class AppDatabase extends _$AppDatabase {
  new([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'ripped'));

  /// Bump with every schema change, add a step in [migration], and run
  /// `dart run drift_dev make-migrations` to snapshot + test it.
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createIndexes();
      await _createSyncTriggers();
    },
    onUpgrade: (m, from, to) async {
      // v2: gamification (xp ledger + personal records).
      if (from < 2) {
        await m.createTable(xpEvents);
        await m.createTable(personalRecords);
      }
      // v3: sync outbox + change-tracking triggers.
      if (from < 3) {
        await m.createTable(syncOutbox);
        await _createSyncTriggers();
      }
      await _createIndexes();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Tables mirrored to the server, parents before children so uploads
  /// arrive in a sensible order.
  static const syncedTables = [
    'profiles',
    'programs',
    'program_days',
    'program_exercises',
    'workouts',
    'workout_exercises',
    'workout_sets',
    'exercise_states',
    'xp_events',
    'personal_records',
  ];

  /// Set while applying pulled rows so they aren't queued for upload again.
  static const applyingKey = 'sync.applying';

  /// Every insert/update on a synced table lands in `sync_outbox`, unless
  /// the change itself came from the server.
  Future<void> _createSyncTriggers() async {
    for (final t in syncedTables) {
      for (final op in ['INSERT', 'UPDATE']) {
        await customStatement('''
          CREATE TRIGGER IF NOT EXISTS ${t}_outbox_${op.toLowerCase()}
          AFTER $op ON $t
          WHEN NOT EXISTS (
            SELECT 1 FROM settings WHERE key = '$applyingKey' AND value = '1'
          )
          BEGIN
            INSERT INTO sync_outbox (tbl, row_id, seq)
            VALUES ('$t', NEW.id,
              (SELECT COALESCE(MAX(seq), 0) + 1 FROM sync_outbox))
            ON CONFLICT (tbl, row_id) DO UPDATE SET seq = excluded.seq;
          END
        ''');
      }
    }
  }

  /// Removes every row from this phone (after account deletion). The
  /// catalog is separate and untouched.
  Future<void> wipeAll() => transaction(() async {
    for (final t in syncedTables.reversed) {
      await customStatement('DELETE FROM $t');
    }
    await customStatement('DELETE FROM sync_outbox');
    await customStatement('DELETE FROM settings');
    notifyUpdates({for (final t in allTables) TableUpdate.onTable(t)});
  });

  Future<void> _createIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_workouts_status '
      'ON workouts (status, started_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_workout_sets_exercise '
      'ON workout_sets (workout_exercise_id, set_index)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_workout_exercises_workout '
      'ON workout_exercises (workout_id, sort_order)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_xp_events_time '
      'ON xp_events (occurred_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_prs_exercise '
      'ON personal_records (exercise_id, achieved_at)',
    );
  }
}
