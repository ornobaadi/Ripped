import 'package:drift/drift.dart';
import 'package:ripped/core/catalog/catalog_repository.dart';
import 'package:ripped/core/db/app_database.dart';
import 'package:ripped/domain/plan/plan.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/domain/progression/progression_engine.dart';
import 'package:ripped/features/plan/data/program_repository.dart';
import 'package:ripped/features/workout/data/workout_models.dart';

/// Workout logging. Every mutation is a single small write so the active
/// workout survives an app kill at any moment (architecture.md 12).
class WorkoutRepository {
  new(this._db, this._catalog, {this.engine = const ProgressionEngine()});

  final AppDatabase _db;
  final CatalogRepository _catalog;
  final ProgressionEngine engine;

  // ---------------------------------------------------------------- start

  Future<String> startWorkout(ProgramDayView day, {Units units = Units.kg}) =>
      _db.transaction(() async {
        final workout = await _db
            .into(_db.workouts)
            .insertReturning(
              WorkoutsCompanion.insert(
                programDayId: Value(day.id),
                dayIndex: Value(day.index),
                name: day.name,
                startedAt: DateTime.now(),
                status: WorkoutStatus.inProgress,
              ),
            );
        for (final (i, e) in day.exercises.indexed) {
          await _insertExercise(
            workout.id,
            e.exerciseId,
            i,
            e.prescription,
            units,
          );
        }
        return workout.id;
      });

  Future<void> _insertExercise(
    String workoutId,
    String exerciseId,
    int order,
    Prescription p,
    Units units,
  ) async {
    final we = await _db
        .into(_db.workoutExercises)
        .insertReturning(
          WorkoutExercisesCompanion.insert(
            workoutId: workoutId,
            exerciseId: exerciseId,
            sortOrder: order,
            repMin: p.repMin,
            repMax: p.repMax,
            restSeconds: p.restSeconds,
          ),
        );
    await _insertSets(we.id, exerciseId, p, units);
  }

  /// Pre-fills sets from progression memory, or a light starting weight
  /// the first time ("find your weight").
  Future<void> _insertSets(
    String workoutExerciseId,
    String exerciseId,
    Prescription p,
    Units units,
  ) async {
    final state = await _state(exerciseId);
    final exercise = _catalog.byId(exerciseId);
    final weight = exercise.isWeighted
        ? state?.currentWeightKg ??
              LoadIncrements.startingWeightKg(exercise, units)
        : null;
    final reps = (state?.currentRepTarget ?? p.repMin).clamp(
      p.repMin,
      p.repMax,
    );
    for (var s = 0; s < p.sets; s++) {
      await _db
          .into(_db.workoutSets)
          .insert(
            WorkoutSetsCompanion.insert(
              workoutExerciseId: workoutExerciseId,
              setIndex: s,
              weightKg: Value(weight),
              reps: reps,
              targetReps: reps,
            ),
          );
    }
  }

  // ---------------------------------------------------------------- read

  Stream<WorkoutView?> watchWorkout(String id) => _db
      .tableUpdates(
        TableUpdateQuery.onAllTables([
          _db.workouts,
          _db.workoutExercises,
          _db.workoutSets,
        ]),
      )
      .asyncMap((_) => workout(id))
      .startWith(() => workout(id));

  Future<WorkoutView?> workout(String id) async {
    final w = await (_db.select(
      _db.workouts,
    )..where((w) => w.id.equals(id))).getSingleOrNull();
    if (w == null) return null;

    final exercises =
        await (_db.select(_db.workoutExercises)
              ..where((e) => e.workoutId.equals(id) & e.deletedAt.isNull())
              ..orderBy([(e) => OrderingTerm.asc(e.sortOrder)]))
            .get();
    final sets =
        await (_db.select(_db.workoutSets)
              ..where(
                (s) =>
                    s.workoutExerciseId.isIn(exercises.map((e) => e.id)) &
                    s.deletedAt.isNull(),
              )
              ..orderBy([(s) => OrderingTerm.asc(s.setIndex)]))
            .get();
    final known =
        await (_db.select(_db.exerciseStates)..where(
              (s) => s.exerciseId.isIn(exercises.map((e) => e.exerciseId)),
            ))
            .map((s) => s.exerciseId)
            .get();

    return WorkoutView(
      id: w.id,
      name: w.name,
      status: w.status,
      startedAt: w.startedAt,
      finishedAt: w.finishedAt,
      dayIndex: w.dayIndex,
      feeling: w.feeling == null ? null : Feeling.values.byName(w.feeling!),
      exercises: [
        for (final e in exercises)
          WorkoutExerciseView(
            id: e.id,
            exerciseId: e.exerciseId,
            order: e.sortOrder,
            repMin: e.repMin,
            repMax: e.repMax,
            restSeconds: e.restSeconds,
            skipped: e.skipped,
            firstTime: !known.contains(e.exerciseId),
            last: await _lastPerformance(e.exerciseId, before: w.startedAt),
            sets: [
              for (final s in sets.where((s) => s.workoutExerciseId == e.id))
                WorkoutSetView(
                  id: s.id,
                  index: s.setIndex,
                  weightKg: s.weightKg,
                  reps: s.reps,
                  targetReps: s.targetReps,
                  completedAt: s.completedAt,
                ),
            ],
          ),
      ],
    );
  }

  Future<LastPerformance?> _lastPerformance(
    String exerciseId, {
    required DateTime before,
  }) async {
    final row =
        await (_db.select(_db.workoutExercises).join([
                innerJoin(
                  _db.workouts,
                  _db.workouts.id.equalsExp(_db.workoutExercises.workoutId),
                ),
              ])
              ..where(
                _db.workoutExercises.exerciseId.equals(exerciseId) &
                    _db.workoutExercises.skipped.equals(false) &
                    _db.workouts.status.equalsValue(WorkoutStatus.completed) &
                    _db.workouts.startedAt.isSmallerThanValue(before),
              )
              ..orderBy([OrderingTerm.desc(_db.workouts.startedAt)])
              ..limit(1))
            .getSingleOrNull();
    if (row == null) return null;
    final we = row.readTable(_db.workoutExercises);
    final sets =
        await (_db.select(_db.workoutSets)
              ..where(
                (s) =>
                    s.workoutExerciseId.equals(we.id) &
                    s.completedAt.isNotNull() &
                    s.isWarmup.equals(false),
              )
              ..orderBy([(s) => OrderingTerm.asc(s.setIndex)]))
            .get();
    if (sets.isEmpty) return null;
    return LastPerformance(
      date: row.readTable(_db.workouts).startedAt,
      sets: [
        for (final s in sets) SetResult(reps: s.reps, weightKg: s.weightKg),
      ],
    );
  }

  /// The unfinished workout, if the app was closed mid-session.
  Future<String?> activeWorkoutId() async {
    final w =
        await (_db.select(_db.workouts)
              ..where((w) => w.status.equalsValue(WorkoutStatus.inProgress))
              ..orderBy([(w) => OrderingTerm.desc(w.startedAt)])
              ..limit(1))
            .getSingleOrNull();
    return w?.id;
  }

  Stream<String?> watchActiveWorkoutId() =>
      (_db.select(_db.workouts)
            ..where((w) => w.status.equalsValue(WorkoutStatus.inProgress))
            ..orderBy([(w) => OrderingTerm.desc(w.startedAt)])
            ..limit(1))
          .watchSingleOrNull()
          .map((w) => w?.id);

  /// Completed workouts (date + program day) for scheduling.
  Stream<List<({DateTime startedAt, int? dayIndex})>> watchCompleted() =>
      (_db.select(_db.workouts)
            ..where((w) => w.status.equalsValue(WorkoutStatus.completed))
            ..orderBy([(w) => OrderingTerm.desc(w.startedAt)]))
          .watch()
          .map(
            (rows) => [
              for (final w in rows)
                (startedAt: w.startedAt, dayIndex: w.dayIndex),
            ],
          );

  Stream<List<HistoryEntry>> watchHistory() => _db
      .customSelect(
        '''
        SELECT w.id, w.name, w.started_at, w.duration_s,
          COUNT(s.id) AS sets,
          COALESCE(SUM(s.weight_kg * s.reps), 0) AS volume
        FROM workouts w
        LEFT JOIN workout_exercises e
          ON e.workout_id = w.id AND e.skipped = 0
        LEFT JOIN workout_sets s
          ON s.workout_exercise_id = e.id AND s.completed_at IS NOT NULL
        WHERE w.status = 'completed' AND w.deleted_at IS NULL
        GROUP BY w.id
        ORDER BY w.started_at DESC
        ''',
        readsFrom: {_db.workouts, _db.workoutExercises, _db.workoutSets},
      )
      .watch()
      .map(
        (rows) => [
          for (final r in rows)
            HistoryEntry(
              id: r.read<String>('id'),
              name: r.read<String>('name'),
              startedAt: r.read<DateTime>('started_at'),
              duration: Duration(seconds: r.read<int?>('duration_s') ?? 0),
              sets: r.read<int>('sets'),
              volumeKg: r.read<double>('volume'),
            ),
        ],
      );

  // ---------------------------------------------------------------- log

  /// One tap: logs the set as currently shown.
  Future<void> logSet(String setId) => _touchSet(
    setId,
    WorkoutSetsCompanion(completedAt: Value(DateTime.now())),
  );

  Future<void> undoSet(String setId) =>
      _touchSet(setId, const WorkoutSetsCompanion(completedAt: Value(null)));

  /// Edits a set. Weight changes carry to the remaining unlogged sets of
  /// the exercise, so adjusting set 1 fixes the rest too.
  Future<void> editSet(
    String setId, {
    required int reps,
    double? weightKg,
    bool log = false,
  }) => _db.transaction(() async {
    final set = await (_db.select(
      _db.workoutSets,
    )..where((s) => s.id.equals(setId))).getSingle();
    await _touchSet(
      setId,
      WorkoutSetsCompanion(
        reps: Value(reps),
        weightKg: Value(weightKg),
        completedAt: log ? Value(DateTime.now()) : const Value.absent(),
      ),
    );
    if (weightKg != set.weightKg) {
      await (_db.update(_db.workoutSets)..where(
            (s) =>
                s.workoutExerciseId.equals(set.workoutExerciseId) &
                s.setIndex.isBiggerThanValue(set.setIndex) &
                s.completedAt.isNull(),
          ))
          .write(
            WorkoutSetsCompanion(
              weightKg: Value(weightKg),
              updatedAt: Value(DateTime.now()),
            ),
          );
    }
  });

  Future<void> _touchSet(String setId, WorkoutSetsCompanion changes) =>
      (_db.update(_db.workoutSets)..where((s) => s.id.equals(setId))).write(
        changes.copyWith(updatedAt: Value(DateTime.now())),
      );

  /// Adds a set copying the last one.
  Future<void> addSet(String workoutExerciseId) => _db.transaction(() async {
    final last =
        await (_db.select(_db.workoutSets)
              ..where((s) => s.workoutExerciseId.equals(workoutExerciseId))
              ..orderBy([(s) => OrderingTerm.desc(s.setIndex)])
              ..limit(1))
            .getSingle();
    await _db
        .into(_db.workoutSets)
        .insert(
          WorkoutSetsCompanion.insert(
            workoutExerciseId: workoutExerciseId,
            setIndex: last.setIndex + 1,
            weightKg: Value(last.weightKg),
            reps: last.reps,
            targetReps: last.targetReps,
          ),
        );
  });

  /// Removes the last unlogged set.
  Future<void> removeSet(String workoutExerciseId) async {
    final last =
        await (_db.select(_db.workoutSets)
              ..where(
                (s) =>
                    s.workoutExerciseId.equals(workoutExerciseId) &
                    s.completedAt.isNull(),
              )
              ..orderBy([(s) => OrderingTerm.desc(s.setIndex)])
              ..limit(1))
            .getSingleOrNull();
    if (last == null) return;
    await (_db.delete(
      _db.workoutSets,
    )..where((s) => s.id.equals(last.id))).go();
  }

  Future<void> setSkipped(String workoutExerciseId, {required bool skipped}) =>
      (_db.update(
        _db.workoutExercises,
      )..where((e) => e.id.equals(workoutExerciseId))).write(
        WorkoutExercisesCompanion(
          skipped: Value(skipped),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<void> addExercise(
    String workoutId,
    String exerciseId,
    Prescription p, {
    Units units = Units.kg,
  }) => _db.transaction(() async {
    final count = await (_db.select(
      _db.workoutExercises,
    )..where((e) => e.workoutId.equals(workoutId))).get();
    await _insertExercise(workoutId, exerciseId, count.length, p, units);
  });

  /// Replaces an exercise mid-workout; only allowed before any set is
  /// logged on it.
  Future<void> swapExercise(
    String workoutExerciseId,
    String newExerciseId, {
    Units units = Units.kg,
  }) => _db.transaction(() async {
    final we = await (_db.select(
      _db.workoutExercises,
    )..where((e) => e.id.equals(workoutExerciseId))).getSingle();
    final sets = await (_db.select(
      _db.workoutSets,
    )..where((s) => s.workoutExerciseId.equals(we.id))).get();
    await (_db.delete(
      _db.workoutSets,
    )..where((s) => s.workoutExerciseId.equals(we.id))).go();
    await (_db.update(
      _db.workoutExercises,
    )..where((e) => e.id.equals(we.id))).write(
      WorkoutExercisesCompanion(
        exerciseId: Value(newExerciseId),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await _insertSets(
      we.id,
      newExerciseId,
      Prescription(
        sets: sets.length,
        repMin: we.repMin,
        repMax: we.repMax,
        restSeconds: we.restSeconds,
      ),
      units,
    );
  });

  /// Moves an exercise to [newIndex], shifting the others.
  Future<void> moveExercise(String workoutId, int oldIndex, int newIndex) =>
      _db.transaction(() async {
        final rows =
            await (_db.select(_db.workoutExercises)
                  ..where((e) => e.workoutId.equals(workoutId))
                  ..orderBy([(e) => OrderingTerm.asc(e.sortOrder)]))
                .get();
        final moved = rows.removeAt(oldIndex);
        rows.insert(newIndex.clamp(0, rows.length), moved);
        for (final (i, r) in rows.indexed) {
          if (r.sortOrder == i) continue;
          await (_db.update(_db.workoutExercises)
                ..where((e) => e.id.equals(r.id)))
              .write(WorkoutExercisesCompanion(sortOrder: Value(i)));
        }
      });

  // ---------------------------------------------------------------- finish

  /// Completes the workout and applies progression in one transaction.
  Future<List<ProgressionResult>> finishWorkout(
    String workoutId, {
    required Units units,
    Feeling? feeling,
  }) => _db.transaction(() async {
    final view = await workout(workoutId);
    if (view == null) return const [];
    final now = DateTime.now();
    await (_db.update(
      _db.workouts,
    )..where((w) => w.id.equals(workoutId))).write(
      WorkoutsCompanion(
        status: const Value(WorkoutStatus.completed),
        finishedAt: Value(now),
        durationS: Value(now.difference(view.startedAt).inSeconds),
        feeling: Value(feeling?.name),
        updatedAt: Value(now),
      ),
    );

    final results = <ProgressionResult>[];
    for (final e in view.exercises.where((e) => !e.skipped)) {
      final working = [
        for (final s in e.sets.where((s) => s.done))
          SetResult(reps: s.reps, weightKg: s.weightKg),
      ];
      if (working.isEmpty) continue;
      final exercise = _catalog.byId(e.exerciseId);
      final previous = await _state(e.exerciseId);
      final outcome = engine.evaluate(
        previous: previous == null
            ? null
            : ExerciseProgress(
                weightKg: previous.currentWeightKg,
                repTarget: previous.currentRepTarget,
                stallCount: previous.stallCount,
                lastTotalReps: previous.lastTotalReps,
              ),
        workingSets: working,
        repMin: e.repMin,
        repMax: e.repMax,
        incrementKg: LoadIncrements.forExercise(exercise, units),
        feeling: feeling,
      );
      await _saveState(e.exerciseId, outcome, previous?.id, now);
      results.add(
        ProgressionResult(
          exerciseId: e.exerciseId,
          decision: outcome.decision,
          next: outcome.next,
        ),
      );
    }
    return results;
  });

  Future<void> abandonWorkout(String workoutId) =>
      (_db.update(_db.workouts)..where((w) => w.id.equals(workoutId))).write(
        WorkoutsCompanion(
          status: const Value(WorkoutStatus.abandoned),
          finishedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );

  // ---------------------------------------------------------------- state

  Future<ExerciseState?> _state(String exerciseId) => (_db.select(
    _db.exerciseStates,
  )..where((s) => s.exerciseId.equals(exerciseId))).getSingleOrNull();

  Future<void> _saveState(
    String exerciseId,
    ProgressionOutcome outcome,
    String? existingId,
    DateTime now,
  ) async {
    final next = outcome.next;
    final row = ExerciseStatesCompanion(
      exerciseId: Value(exerciseId),
      currentWeightKg: Value(next.weightKg),
      currentRepTarget: Value(next.repTarget),
      stallCount: Value(next.stallCount),
      lastTotalReps: Value(next.lastTotalReps),
      lastDecision: Value(outcome.decision.name),
      lastProgressedAt: Value(now),
      updatedAt: Value(now),
    );
    if (existingId == null) {
      await _db.into(_db.exerciseStates).insert(row);
    } else {
      await (_db.update(
        _db.exerciseStates,
      )..where((s) => s.id.equals(existingId))).write(row);
    }
  }
}
