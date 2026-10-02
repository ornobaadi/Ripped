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
  ],
)
class AppDatabase extends _$AppDatabase {
  new([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'ripped'));

  /// Bump with every schema change, add a step in [migration], and run
  /// `dart run drift_dev make-migrations` to snapshot + test it.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createIndexes();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

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
  }
}
