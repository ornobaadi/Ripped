import 'package:drift/drift.dart';
import 'package:ripped/core/db/app_database.dart';
import 'package:ripped/core/db/profile_mapping.dart';
import 'package:ripped/domain/plan/plan.dart';
import 'package:ripped/domain/plan/profile.dart';

class ProgramExerciseView {
  const new({
    required this.id,
    required this.exerciseId,
    required this.prescription,
    required this.reason,
  });

  final String id;
  final String exerciseId;
  final Prescription prescription;
  final String reason;
}

class ProgramDayView {
  const new({
    required this.id,
    required this.index,
    required this.name,
    required this.exercises,
  });

  final String id;
  final int index;
  final String name;
  final List<ProgramExerciseView> exercises;

  int get estimatedMinutes => PlanDay(
    name: name,
    exercises: [
      for (final e in exercises)
        PlannedExercise(
          exerciseId: e.exerciseId,
          prescription: e.prescription,
          reason: e.reason,
        ),
    ],
  ).estimatedMinutes;
}

class ProgramView {
  const new({
    required this.id,
    required this.name,
    required this.days,
    this.startedAt,
  });

  final String id;

  /// When this plan became the active one.
  final DateTime? startedAt;
  final String name;
  final List<ProgramDayView> days;
}

/// Profile + active program persistence.
class ProgramRepository {
  new(this._db);

  final AppDatabase _db;

  // ---- profile ----

  Stream<Profile?> watchProfileRow() =>
      (_db.select(_db.profiles)
            ..where((p) => p.deletedAt.isNull())
            ..orderBy([(p) => OrderingTerm.desc(p.updatedAt)])
            ..limit(1))
          .watchSingleOrNull();

  Future<Profile?> profileRow() =>
      (_db.select(_db.profiles)
            ..where((p) => p.deletedAt.isNull())
            ..orderBy([(p) => OrderingTerm.desc(p.updatedAt)])
            ..limit(1))
          .getSingleOrNull();

  Future<TrainingProfile?> profile() async => (await profileRow())?.toDomain();

  /// Upserts the single profile row.
  Future<void> saveProfile(
    TrainingProfile profile, {
    bool onboardingDone = false,
    bool disclaimerAccepted = false,
  }) async {
    final existing = await profileRow();
    var row = profile.toCompanion();
    if (onboardingDone) {
      row = row.copyWith(onboardingDoneAt: Value(DateTime.now()));
    }
    if (disclaimerAccepted) {
      row = row.copyWith(disclaimerAcceptedAt: Value(DateTime.now()));
    }
    if (existing == null) {
      await _db.into(_db.profiles).insert(row);
    } else {
      await (_db.update(
        _db.profiles,
      )..where((p) => p.id.equals(existing.id))).write(row);
    }
  }

  Future<void> setUnits(Units units) async {
    final existing = await profileRow();
    if (existing == null) return;
    await (_db.update(
      _db.profiles,
    )..where((p) => p.id.equals(existing.id))).write(
      ProfilesCompanion(
        units: Value(units.name),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ---- program ----

  /// Replaces the active program in one transaction.
  Future<String> saveProgram(GeneratedPlan plan) => _db.transaction(() async {
    await (_db.update(_db.programs)..where((p) => p.active.equals(true))).write(
      ProgramsCompanion(
        active: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
    final program = await _db
        .into(_db.programs)
        .insertReturning(
          ProgramsCompanion.insert(
            name: plan.name,
            splitType: plan.split.name,
            generatedByVersion: plan.generatorVersion,
            startedAt: DateTime.now(),
          ),
        );
    for (final (i, day) in plan.days.indexed) {
      final dayRow = await _db
          .into(_db.programDays)
          .insertReturning(
            ProgramDaysCompanion.insert(
              programId: program.id,
              dayIndex: i,
              name: day.name,
            ),
          );
      for (final (order, e) in day.exercises.indexed) {
        await _db
            .into(_db.programExercises)
            .insert(
              ProgramExercisesCompanion.insert(
                programDayId: dayRow.id,
                exerciseId: e.exerciseId,
                sortOrder: order,
                sets: e.prescription.sets,
                repMin: e.prescription.repMin,
                repMax: e.prescription.repMax,
                restSeconds: e.prescription.restSeconds,
                reason: e.reason,
              ),
            );
      }
    }
    return program.id;
  });

  Stream<ProgramView?> watchActiveProgram() => _db
      .tableUpdates(
        TableUpdateQuery.onAllTables([
          _db.programs,
          _db.programDays,
          _db.programExercises,
        ]),
      )
      .asyncMap((_) => activeProgram())
      .startWith(activeProgram);

  Future<ProgramView?> activeProgram() async {
    final program =
        await (_db.select(_db.programs)
              ..where((p) => p.active.equals(true) & p.deletedAt.isNull())
              ..orderBy([(p) => OrderingTerm.desc(p.startedAt)])
              ..limit(1))
            .getSingleOrNull();
    if (program == null) return null;

    final days =
        await (_db.select(_db.programDays)
              ..where((d) => d.programId.equals(program.id))
              ..orderBy([(d) => OrderingTerm.asc(d.dayIndex)]))
            .get();
    final exercises =
        await (_db.select(_db.programExercises)
              ..where(
                (e) =>
                    e.programDayId.isIn(days.map((d) => d.id)) &
                    e.deletedAt.isNull(),
              )
              ..orderBy([(e) => OrderingTerm.asc(e.sortOrder)]))
            .get();

    return ProgramView(
      id: program.id,
      name: program.name,
      startedAt: program.startedAt,
      days: [
        for (final d in days)
          ProgramDayView(
            id: d.id,
            index: d.dayIndex,
            name: d.name,
            exercises: [
              for (final e in exercises.where((e) => e.programDayId == d.id))
                ProgramExerciseView(
                  id: e.id,
                  exerciseId: e.exerciseId,
                  prescription: Prescription(
                    sets: e.sets,
                    repMin: e.repMin,
                    repMax: e.repMax,
                    restSeconds: e.restSeconds,
                  ),
                  reason: e.reason,
                ),
            ],
          ),
      ],
    );
  }

  /// Swaps one planned exercise for another (same prescription).
  Future<void> swapExercise(String programExerciseId, String newExerciseId) =>
      (_db.update(
        _db.programExercises,
      )..where((e) => e.id.equals(programExerciseId))).write(
        ProgramExercisesCompanion(
          exerciseId: Value(newExerciseId),
          reason: const Value('Your pick'),
          updatedAt: Value(DateTime.now()),
        ),
      );

  // ---- editing (the user's own changes to the plan) ----

  Future<List<ProgramExercise>> _dayRows(String dayId) =>
      (_db.select(_db.programExercises)
            ..where((e) => e.programDayId.equals(dayId) & e.deletedAt.isNull())
            ..orderBy([(e) => OrderingTerm.asc(e.sortOrder)]))
          .get();

  /// Appends an exercise to a day. Returns false when the day is full.
  Future<bool> addExercise(
    String dayId,
    String exerciseId,
    Prescription prescription,
  ) => _db.transaction(() async {
    final rows = await _dayRows(dayId);
    if (rows.length >= PlanLimits.maxExercisesPerDay) return false;
    final p = PlanLimits.clamp(prescription);
    await _db
        .into(_db.programExercises)
        .insert(
          ProgramExercisesCompanion.insert(
            programDayId: dayId,
            exerciseId: exerciseId,
            sortOrder: rows.isEmpty ? 0 : rows.last.sortOrder + 1,
            sets: p.sets,
            repMin: p.repMin,
            repMax: p.repMax,
            restSeconds: p.restSeconds,
            reason: 'Your pick',
          ),
        );
    return true;
  });

  /// Soft-deletes one planned exercise. A day always keeps at least one;
  /// returns false when this is the last.
  Future<bool> removeExercise(String programExerciseId) => _db.transaction(
    () async {
      final row = await (_db.select(
        _db.programExercises,
      )..where((e) => e.id.equals(programExerciseId))).getSingleOrNull();
      if (row == null) return false;
      if ((await _dayRows(row.programDayId)).length <= 1) return false;
      final now = DateTime.now();
      await (_db.update(
        _db.programExercises,
      )..where((e) => e.id.equals(programExerciseId))).write(
        ProgramExercisesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
      return true;
    },
  );

  /// Moves an exercise within its day ([newIndex] as in a reorderable
  /// list after removal).
  Future<void> moveExercise(String dayId, int oldIndex, int newIndex) =>
      _db.transaction(() async {
        final rows = await _dayRows(dayId);
        if (oldIndex < 0 || oldIndex >= rows.length) return;
        final moved = rows.removeAt(oldIndex);
        rows.insert(newIndex.clamp(0, rows.length), moved);
        final now = DateTime.now();
        for (final (i, r) in rows.indexed) {
          if (r.sortOrder == i) continue;
          await (_db.update(
            _db.programExercises,
          )..where((e) => e.id.equals(r.id))).write(
            ProgramExercisesCompanion(
              sortOrder: Value(i),
              updatedAt: Value(now),
            ),
          );
        }
      });

  /// Replaces a day's exercises with a freshly built day (soft-deleting
  /// the old ones) and renames it to match.
  Future<void> replaceDay(
    String dayId,
    PlanDay day,
  ) => _db.transaction(() async {
    final now = DateTime.now();
    await (_db.update(
      _db.programExercises,
    )..where((e) => e.programDayId.equals(dayId) & e.deletedAt.isNull())).write(
      ProgramExercisesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
    for (final (order, e) in day.exercises.indexed) {
      await _db
          .into(_db.programExercises)
          .insert(
            ProgramExercisesCompanion.insert(
              programDayId: dayId,
              exerciseId: e.exerciseId,
              sortOrder: order,
              sets: e.prescription.sets,
              repMin: e.prescription.repMin,
              repMax: e.prescription.repMax,
              restSeconds: e.prescription.restSeconds,
              reason: e.reason,
            ),
          );
    }
    await renameDay(dayId, day.name);
  });

  Future<void> updatePrescription(
    String programExerciseId,
    Prescription prescription,
  ) {
    final p = PlanLimits.clamp(prescription);
    return (_db.update(
      _db.programExercises,
    )..where((e) => e.id.equals(programExerciseId))).write(
      ProgramExercisesCompanion(
        sets: Value(p.sets),
        repMin: Value(p.repMin),
        repMax: Value(p.repMax),
        restSeconds: Value(p.restSeconds),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> renameDay(String dayId, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    await (_db.update(_db.programDays)..where((d) => d.id.equals(dayId))).write(
      ProgramDaysCompanion(
        name: Value(
          trimmed.length > PlanLimits.maxDayNameLength
              ? trimmed.substring(0, PlanLimits.maxDayNameLength)
              : trimmed,
        ),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}

extension StartWith<T> on Stream<T> {
  /// Emits [initial]'s result first so watchers never wait for a change.
  Stream<T> startWith(Future<T> Function() initial) async* {
    yield await initial();
    yield* this;
  }
}
