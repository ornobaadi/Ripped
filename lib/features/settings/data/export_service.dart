import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:ripped/core/catalog/catalog_repository.dart';
import 'package:ripped/core/db/app_database.dart';
import 'package:share_plus/share_plus.dart';

/// "Download my data" (architecture.md 7): everything on this phone as JSON,
/// plus a spreadsheet-friendly CSV of every logged set. Built on-device.
class ExportService {
  new(this._db, this._catalog);

  final AppDatabase _db;
  final CatalogRepository _catalog;

  static const _internal = {'user_id'};

  /// All synced tables, live rows only, timestamps in UTC ISO-8601.
  Future<Map<String, Object?>> buildJson() async {
    final tables = <String, Object?>{};
    for (final t in AppDatabase.syncedTables) {
      final rows = await _db
          .customSelect('SELECT * FROM $t WHERE deleted_at IS NULL')
          .get();
      tables[t] = [
        for (final r in rows)
          {
            for (final MapEntry(:key, :value) in r.data.entries)
              if (!_internal.contains(key))
                key: key.endsWith('_at') && value is String
                    ? DateTime.parse(value).toUtc().toIso8601String()
                    : value,
          },
      ];
    }
    return {
      'app': 'Ripped',
      'format': 1,
      'exported_at': DateTime.now().toUtc().toIso8601String(),
      'weights_unit': 'kg',
      'tables': tables,
    };
  }

  /// One line per logged set: date, workout, exercise, set, kg, reps.
  Future<String> buildSetsCsv() async {
    final rows = await _db.customSelect('''
      SELECT w.started_at, w.name AS workout, e.exercise_id, s.set_index,
        s.weight_kg, s.reps
      FROM workout_sets s
      JOIN workout_exercises e ON e.id = s.workout_exercise_id
      JOIN workouts w ON w.id = e.workout_id
      WHERE w.status = 'completed' AND s.completed_at IS NOT NULL
        AND s.deleted_at IS NULL
      ORDER BY w.started_at, e.sort_order, s.set_index
    ''').get();
    final out = StringBuffer('date,workout,exercise,set,weight_kg,reps\n');
    for (final r in rows) {
      final id = r.read<String>('exercise_id');
      out.writeln(
        [
          DateTime.parse(r.read<String>('started_at')).toIso8601String(),
          r.read<String>('workout'),
          _catalog.maybe(id)?.name ?? id,
          r.read<int>('set_index') + 1,
          r.read<double?>('weight_kg') ?? '',
          r.read<int>('reps'),
        ].map(_csv).join(','),
      );
    }
    return out.toString();
  }

  static String _csv(Object value) {
    final s = value.toString();
    return s.contains(RegExp('[",\n]')) ? '"${s.replaceAll('"', '""')}"' : s;
  }

  /// Writes both files and opens the share sheet.
  Future<void> share() async {
    final dir = await getTemporaryDirectory();
    final stamp = DateTime.now().toIso8601String().substring(0, 10);
    final json = File('${dir.path}/ripped-export-$stamp.json');
    final csv = File('${dir.path}/ripped-sets-$stamp.csv');
    await json.writeAsString(
      const JsonEncoder.withIndent('  ').convert(await buildJson()),
    );
    await csv.writeAsString(await buildSetsCsv());
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(json.path), XFile(csv.path)],
        subject: 'Ripped data export',
      ),
    );
  }
}
