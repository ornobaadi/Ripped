import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/core/catalog/catalog_repository.dart';
import 'package:ripped/core/db/app_database.dart';
import 'package:ripped/domain/gamification/xp.dart';
import 'package:ripped/domain/plan/plan_generator.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/domain/progression/progression_engine.dart';
import 'package:ripped/domain/records/personal_records.dart';
import 'package:ripped/features/plan/data/program_repository.dart';
import 'package:ripped/features/workout/data/workout_repository.dart';
import 'package:sqlite3/sqlite3.dart';

import '../helpers/catalog.dart';

void main() {
  late Database raw;
  late AppDatabase db;
  late ProgramRepository programs;
  late WorkoutRepository workouts;
  final catalog = CatalogRepository(realCatalog());
  const profile = TrainingProfile();

  AppDatabase open() => AppDatabase(
    DatabaseConnection(
      NativeDatabase.opened(raw, closeUnderlyingOnClose: false),
    ),
  );

  setUp(() async {
    raw = sqlite3.openInMemory();
    db = open();
    programs = ProgramRepository(db);
    workouts = WorkoutRepository(db, catalog);
    await programs.saveProfile(profile, onboardingDone: true);
    await programs.saveProgram(PlanGenerator(catalog.all).generate(profile));
  });

  tearDown(() async {
    await db.close();
    raw.close();
  });

  Future<ProgramDayView> firstDay() async =>
      (await programs.activeProgram())!.days.first;

  test('profile round-trips', () async {
    final saved = await programs.profile();
    expect(saved!.goal, Goal.muscle);
    expect(saved.trainingDays, profile.trainingDays);
  });

  test('saving a new program deactivates the old one', () async {
    final first = await programs.activeProgram();
    await programs.saveProgram(
      PlanGenerator(catalog.all).generate(profile.copyWith(daysPerWeek: 4)),
    );
    final active = await programs.activeProgram();
    expect(active!.id, isNot(first!.id));
    expect(active.days, hasLength(4));
  });

  test('new workout pre-fills light starting weights', () async {
    final day = await firstDay();
    final id = await workouts.startWorkout(day);
    final w = (await workouts.workout(id))!;

    expect(w.exercises, hasLength(day.exercises.length));
    final squat = w.exercises.first;
    expect(squat.exerciseId, 'barbell_back_squat');
    expect(squat.firstTime, isTrue);
    expect(squat.sets.first.weightKg, 20);
    expect(squat.sets.first.reps, squat.repMin);
    expect(w.doneSets, 0);
  });

  test('logged sets survive an app kill', () async {
    final id = await workouts.startWorkout(await firstDay());
    final w = (await workouts.workout(id))!;
    await workouts.logSet(w.exercises.first.sets.first.id);

    // "Kill": close the database and reopen it from the same file.
    await db.close();
    db = open();
    workouts = WorkoutRepository(db, catalog);

    expect(await workouts.activeWorkoutId(), id);
    final reopened = (await workouts.workout(id))!;
    expect(reopened.exercises.first.sets.first.done, isTrue);
    expect(reopened.doneSets, 1);
  });

  test('editing weight carries to the remaining unlogged sets', () async {
    final id = await workouts.startWorkout(await firstDay());
    final sets = (await workouts.workout(id))!.exercises.first.sets;
    await workouts.logSet(sets[0].id);
    await workouts.editSet(sets[1].id, weightKg: 40, reps: 8, log: true);

    final after = (await workouts.workout(id))!.exercises.first.sets;
    expect(after[0].weightKg, 20, reason: 'logged sets are untouched');
    expect(after[1].weightKg, 40);
    expect(after[1].done, isTrue);
    expect(after[2].weightKg, 40);
    expect(after[2].done, isFalse);
  });

  test('finishing applies progression to the next session', () async {
    final day = await firstDay();
    final id = await workouts.startWorkout(day);
    var w = (await workouts.workout(id))!;
    final squat = w.exercises.first;
    for (final s in squat.sets) {
      await workouts.editSet(s.id, weightKg: 60, reps: squat.repMax, log: true);
    }

    final results = await workouts.finishWorkout(id, units: Units.kg);
    expect(results.progression.single.decision, ProgressionDecision.baseline);
    expect(await workouts.activeWorkoutId(), isNull);

    // Session 2: baseline weight carries over.
    final id2 = await workouts.startWorkout(day);
    w = (await workouts.workout(id2))!;
    final squat2 = w.exercises.first;
    expect(squat2.firstTime, isFalse);
    expect(squat2.sets.first.weightKg, 60);
    expect(squat2.last!.sets.first.reps, squat.repMax);

    // Hit the top of the range again -> +2.5 kg next time.
    for (final s in squat2.sets) {
      await workouts.editSet(s.id, weightKg: 60, reps: squat.repMax, log: true);
    }
    final results2 = await workouts.finishWorkout(id2, units: Units.kg);
    expect(
      results2.progression.single.decision,
      ProgressionDecision.increaseWeight,
    );

    final w3 = (await workouts.workout(await workouts.startWorkout(day)))!;
    expect(w3.exercises.first.sets.first.weightKg, 62.5);
    expect(w3.exercises.first.sets.first.reps, squat.repMin);
  });

  test('skipped exercises do not progress or count', () async {
    final id = await workouts.startWorkout(await firstDay());
    final w = (await workouts.workout(id))!;
    await workouts.setSkipped(w.exercises.first.id, skipped: true);
    final after = (await workouts.workout(id))!;
    expect(after.totalSets, w.totalSets - w.exercises.first.sets.length);
    expect(
      (await workouts.finishWorkout(id, units: Units.kg)).progression,
      isEmpty,
    );
  });

  test('add/remove sets, swap and reorder exercises', () async {
    final id = await workouts.startWorkout(await firstDay());
    var w = (await workouts.workout(id))!;
    final first = w.exercises.first;

    await workouts.addSet(first.id);
    w = (await workouts.workout(id))!;
    expect(w.exercises.first.sets, hasLength(first.sets.length + 1));

    await workouts.removeSet(first.id);
    w = (await workouts.workout(id))!;
    expect(w.exercises.first.sets, hasLength(first.sets.length));

    await workouts.swapExercise(first.id, 'goblet_squat');
    w = (await workouts.workout(id))!;
    expect(w.exercises.first.exerciseId, 'goblet_squat');
    expect(
      w.exercises.first.sets.first.weightKg,
      8,
      reason: 'kettlebell start',
    );

    await workouts.moveExercise(id, 0, 2);
    w = (await workouts.workout(id))!;
    expect(w.exercises[2].exerciseId, 'goblet_squat');
  });

  test('history lists completed workouts with volume', () async {
    final id = await workouts.startWorkout(await firstDay());
    final w = (await workouts.workout(id))!;
    final s = w.exercises.first.sets.first;
    await workouts.editSet(s.id, weightKg: 50, reps: 10, log: true);
    await workouts.finishWorkout(id, units: Units.kg);

    final history = await workouts.watchHistory().first;
    expect(history.single.sets, 1);
    expect(history.single.volumeKg, 500);
  });

  test('abandoned workouts are not active and not in history', () async {
    final id = await workouts.startWorkout(await firstDay());
    await workouts.abandonWorkout(id);
    expect(await workouts.activeWorkoutId(), isNull);
    expect(await workouts.watchHistory().first, isEmpty);
  });

  group('gamification on finish', () {
    Future<String> logSquat(double kg, int reps) async {
      final id = await workouts.startWorkout(await firstDay());
      final w = (await workouts.workout(id))!;
      for (final s in w.exercises.first.sets) {
        await workouts.editSet(s.id, weightKg: kg, reps: reps, log: true);
      }
      return id;
    }

    test('first workout earns set + workout XP, no PRs', () async {
      final id = await logSquat(60, 10);
      final out = await workouts.finishWorkout(id, units: Units.kg);
      expect(out.records, isEmpty);
      expect(out.xp, contains(const XpAward(XpSource.workout, 50)));
      expect(out.xpEarned, greaterThan(50));
      expect(out.levelAfter.totalXp, out.xpEarned);
      expect(await workouts.watchTotalXp().first, out.xpEarned);
    });

    test('beating a previous session records PRs and awards XP', () async {
      await workouts.finishWorkout(await logSquat(60, 8), units: Units.kg);
      final out = await workouts.finishWorkout(
        await logSquat(65, 8),
        units: Units.kg,
      );
      final types = out.records.map((r) => r.type).toSet();
      expect(types, containsAll([PrType.e1rm, PrType.volume]));
      final saved = await workouts.watchRecords().first;
      expect(saved, hasLength(out.records.length));
    });

    test('the daily cap holds across several workouts', () async {
      var total = 0;
      for (var i = 0; i < 5; i++) {
        final out = await workouts.finishWorkout(
          await logSquat(60, 10),
          units: Units.kg,
        );
        total += out.xpEarned;
      }
      expect(total, lessThanOrEqualTo(XpRules.dailyCap));
    });

    test('hitting the weekly target awards the streak week', () async {
      final first = await workouts.finishWorkout(
        await logSquat(60, 10),
        units: Units.kg,
        weeklyTarget: 1,
      );
      expect(first.weekCompleted, isTrue);
      expect(first.streakAfter, 1);
      expect(first.xp.first.source, XpSource.streakWeek);
    });

    test('exercise history has one point per session', () async {
      await workouts.finishWorkout(await logSquat(60, 8), units: Units.kg);
      await workouts.finishWorkout(await logSquat(65, 8), units: Units.kg);
      final history = await workouts.exerciseHistory('barbell_back_squat');
      expect(history.map((h) => h.topWeightKg), [60, 65]);
      expect(history.last.bestE1rm, greaterThan(history.first.bestE1rm!));
      expect(
        await workouts.trainedExerciseIds(),
        contains('barbell_back_squat'),
      );
    });

    test('weekly volumes put this week last', () async {
      await workouts.finishWorkout(await logSquat(50, 10), units: Units.kg);
      final v = await workouts.weeklyVolumes(DateTime.now());
      expect(v, hasLength(5));
      expect(v.last, 1500);
    });
  });
}
