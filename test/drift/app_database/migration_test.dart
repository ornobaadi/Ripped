import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/core/db/app_database.dart';

import 'generated/schema.dart';

/// Every schema version must migrate to every later one, and real user
/// data must survive (CLAUDE.md rule 3). Snapshots come from
/// `dart run drift_dev make-migrations`.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  group('schema migrations', () {
    const versions = GeneratedHelper.versions;
    for (final (i, from) in versions.indexed) {
      for (final to in versions.skip(i + 1)) {
        test('v$from -> v$to', () async {
          final schema = await verifier.schemaAt(from);
          final db = AppDatabase(schema.newConnection());
          await verifier.migrateAndValidate(db, to);
          await db.close();
        });
      }
    }
  });

  test('v1 -> v2 keeps the profile and workout history', () async {
    final schema = await verifier.schemaAt(1);
    const now = '2026-09-01T10:00:00.000';
    schema.rawDatabase
      ..execute('''
        INSERT INTO profiles (id, created_at, updated_at, goal, experience,
          equipment, days_per_week, preferred_days, session_minutes, avoid,
          units, onboarding_done_at)
        VALUES ('p1', '$now', '$now', 'muscle', 'beginner', '["gym"]', 3,
          '[]', 45, '[]', 'kg', '$now')
      ''')
      ..execute('''
        INSERT INTO workouts (id, created_at, updated_at, name, started_at,
          finished_at, status)
        VALUES ('w1', '$now', '$now', 'Full Body A', '$now', '$now',
          'completed')
      ''');

    final db = AppDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 2);

    final profiles = await db.select(db.profiles).get();
    expect(profiles.single.goal, 'muscle');
    expect(profiles.single.onboardingDoneAt, isNotNull);
    final workouts = await db.select(db.workouts).get();
    expect(workouts.single.status, WorkoutStatus.completed);
    expect(await db.select(db.xpEvents).get(), isEmpty);
    expect(await db.select(db.personalRecords).get(), isEmpty);
    await db.close();
  });
}
