import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/domain/catalog/exercise.dart';
import 'package:ripped/domain/plan/plan.dart';
import 'package:ripped/domain/plan/plan_generator.dart';
import 'package:ripped/domain/plan/profile.dart';

import '../helpers/catalog.dart';

Exercise ex(
  String id,
  MovementPattern pattern, {
  int priority = 50,
  Equipment equipment = Equipment.gym,
  Level level = Level.beginner,
  List<String> muscles = const [],
  Set<Joint> joints = const {},
  List<String> substitutes = const [],
}) => Exercise(
  id: id,
  name: id,
  pattern: pattern,
  equipment: equipment,
  equipmentLabel: equipment == Equipment.bodyweight ? 'body only' : 'barbell',
  level: level,
  priority: priority,
  primaryMuscles: muscles,
  jointStress: joints,
  isBodyweight: equipment == Equipment.bodyweight,
  substitutes: substitutes,
);

void main() {
  group('against the real catalog', () {
    final catalog = realCatalog();
    final byId = {for (final e in catalog) e.id: e};
    final generator = PlanGenerator(catalog);

    const equipmentSets = {
      'bodyweight only': {Equipment.bodyweight},
      'dumbbells': {Equipment.dumbbells},
      'home kit': {
        Equipment.dumbbells,
        Equipment.bands,
        Equipment.pullUpBar,
        Equipment.kettlebells,
      },
      'gym': {Equipment.gym},
    };

    for (final days in [2, 3, 4, 5, 6]) {
      for (final MapEntry(key: kitName, value: kit) in equipmentSets.entries) {
        for (final experience in Experience.values) {
          for (final goal in Goal.values) {
            final profile = TrainingProfile(
              goal: goal,
              experience: experience,
              equipment: kit,
              daysPerWeek: days,
            );
            test('$days days · $kitName · ${experience.name} · '
                '${goal.name}', () {
              final plan = generator.generate(profile);

              expect(plan.days, hasLength(days));
              expect(plan.generatorVersion, PlanGenerator.version);
              for (final day in plan.days) {
                expect(
                  day.exercises.length,
                  greaterThanOrEqualTo(3),
                  reason: '${day.name} too short',
                );
                expect(
                  day.exercises.length,
                  lessThanOrEqualTo(
                    PlanGenerator.slotsForMinutes(profile.sessionMinutes),
                  ),
                );
                final ids = day.exercises.map((e) => e.exerciseId).toList();
                expect(ids.toSet(), hasLength(ids.length), reason: 'dupes');

                for (final planned in day.exercises) {
                  final e = byId[planned.exerciseId]!;
                  expect(hasAccess(kit, e.equipment), isTrue, reason: e.id);
                  expect(
                    e.level.index,
                    lessThanOrEqualTo(experience.maxLevel.index),
                    reason: e.id,
                  );
                  expect(planned.reason, isNotEmpty);
                  final p = planned.prescription;
                  expect(p.sets, greaterThan(0));
                  expect(p.repMin, lessThanOrEqualTo(p.repMax));
                }
              }
            });
          }
        }
      }
    }

    test('days fit the chosen session length', () {
      for (final minutes in [20, 30, 45, 60]) {
        for (final goal in Goal.values) {
          final plan = generator.generate(
            TrainingProfile(
              goal: goal,
              sessionMinutes: minutes,
              experience: Experience.advanced,
              daysPerWeek: 4,
            ),
          );
          for (final day in plan.days) {
            if (day.exercises.length <= 3) continue;
            expect(
              day.estimatedMinutes,
              lessThanOrEqualTo(minutes * 1.15),
              reason: '${goal.name} $minutes min ${day.name}',
            );
          }
        }
      }
    });

    test('is deterministic', () {
      const profile = TrainingProfile(daysPerWeek: 4);
      List<String> ids(GeneratedPlan p) => [
        for (final d in p.days) ...d.exercises.map((e) => e.exerciseId),
      ];
      expect(
        ids(generator.generate(profile)),
        ids(generator.generate(profile)),
      );
    });

    test('respects every avoid-list joint', () {
      for (final joint in Joint.values) {
        final plan = generator.generate(TrainingProfile(avoid: {joint}));
        for (final day in plan.days) {
          for (final p in day.exercises) {
            expect(byId[p.exerciseId]!.jointStress, isNot(contains(joint)));
          }
        }
      }
    });

    test('fitness goal ends each day with conditioning', () {
      final plan = generator.generate(
        const TrainingProfile(goal: Goal.fitness),
      );
      for (final day in plan.days) {
        expect(
          byId[day.exercises.last.exerciseId]!.pattern,
          MovementPattern.conditioning,
        );
      }
    });

    test('mobility goal opens each day with mobility', () {
      final plan = generator.generate(
        const TrainingProfile(goal: Goal.mobility),
      );
      for (final day in plan.days) {
        expect(
          byId[day.exercises.first.exerciseId]!.pattern,
          MovementPattern.mobility,
        );
      }
    });

    test('swap options share pattern and respect the profile', () {
      const profile = TrainingProfile(equipment: {Equipment.dumbbells});
      final options = generator.swapOptions('dumbbell_bench_press', profile);
      expect(options, isNotEmpty);
      for (final o in options) {
        expect(o.pattern, MovementPattern.horizontalPush);
        expect(hasAccess(profile.equipment, o.equipment), isTrue);
      }
      // Curated substitute ranks first.
      expect(options.first.id, 'push_up');
    });
  });

  group('rules (synthetic catalog)', () {
    test('picks highest priority, then avoids repeats across the week', () {
      final generator = PlanGenerator([
        for (final p in MovementPattern.values) ...[
          ex('${p.name}_best', p, priority: 90),
          ex('${p.name}_ok', p, priority: 40),
        ],
      ]);
      final plan = generator.generate(const TrainingProfile());
      final a = plan.days[0].exercises.first.exerciseId;
      expect(a, 'squat_best');
      // Full Body C has squat again: the alternative is preferred.
      final c = plan.days[2].exercises.map((e) => e.exerciseId);
      expect(c, contains('squat_ok'));
    });

    test('muscle-targeted slot falls back to any exercise of the pattern', () {
      final generator = PlanGenerator([
        ex('squat', MovementPattern.squat),
        ex('row', MovementPattern.horizontalPull),
        ex('bench', MovementPattern.horizontalPush),
        ex('rdl', MovementPattern.hinge),
        ex('ohp', MovementPattern.verticalPush),
        ex('plank', MovementPattern.coreAntiExtension),
        ex(
          'lateral_raise',
          MovementPattern.isolationArm,
          muscles: ['shoulders'],
        ),
      ]);
      final plan = generator.generate(
        const TrainingProfile(sessionMinutes: 60),
      );
      // Full Body A wants biceps; only a shoulder isolation exists.
      expect(
        plan.days.first.exercises.map((e) => e.exerciseId),
        contains('lateral_raise'),
      );
    });

    test('skips slots that cannot be filled', () {
      final generator = PlanGenerator([
        ex('pushup', MovementPattern.horizontalPush),
      ]);
      final plan = generator.generate(const TrainingProfile());
      expect(plan.days.first.exercises.single.exerciseId, 'pushup');
    });

    test('beginners prefer beginner-level exercises', () {
      final generator = PlanGenerator([
        ex('hard', MovementPattern.squat, priority: 60, level: Level.expert),
        ex(
          'medium',
          MovementPattern.squat,
          priority: 60,
          level: Level.intermediate,
        ),
        ex('easy', MovementPattern.squat),
      ]);
      expect(
        generator
            .generate(const TrainingProfile())
            .days
            .first
            .exercises
            .first
            .exerciseId,
        'easy',
      );
      expect(
        generator
            .generate(
              const TrainingProfile(experience: Experience.intermediate),
            )
            .days
            .first
            .exercises
            .first
            .exerciseId,
        'medium',
      );
    });

    test('session length controls exercise count', () {
      expect(PlanGenerator.slotsForMinutes(20), 4);
      expect(PlanGenerator.slotsForMinutes(30), 5);
      expect(PlanGenerator.slotsForMinutes(45), 6);
      expect(PlanGenerator.slotsForMinutes(60), 7);
    });
  });

  group('prescriptions', () {
    final squat = ex('squat', MovementPattern.squat);
    final curl = ex('curl', MovementPattern.isolationArm);

    test('strength compounds are heavy and low rep', () {
      final p = PlanGenerator.prescribe(
        squat,
        const TrainingProfile(
          goal: Goal.strength,
          experience: Experience.advanced,
        ),
      );
      expect(
        p,
        const Prescription(sets: 5, repMin: 4, repMax: 6, restSeconds: 180),
      );
    });

    test('muscle accessories use higher reps', () {
      final p = PlanGenerator.prescribe(curl, const TrainingProfile());
      expect(p.repMin, 10);
      expect(p.repMax, 15);
    });

    test('timed exercises get seconds', () {
      const plank = Exercise(
        id: 'plank',
        name: 'Plank',
        pattern: MovementPattern.coreAntiExtension,
        equipment: Equipment.bodyweight,
        equipmentLabel: 'body only',
        level: Level.beginner,
        priority: 50,
        isBodyweight: true,
        isTimed: true,
      );
      final p = PlanGenerator.prescribe(plank, const TrainingProfile());
      expect(p.repMin, 20);
      expect(p.repMax, 40);
    });
  });

  group('value types', () {
    test('prescriptions compare by value', () {
      const a = Prescription(sets: 3, repMin: 8, repMax: 12, restSeconds: 90);
      expect(
        a,
        const Prescription(sets: 3, repMin: 8, repMax: 12, restSeconds: 90),
      );
      expect(a.hashCode, isNot(0));
      expect(a.toString(), '3x8-12 r90');
    });

    test('planned exercise copyWith keeps the prescription', () {
      const p = PlannedExercise(
        exerciseId: 'a',
        prescription: Prescription(
          sets: 3,
          repMin: 8,
          repMax: 12,
          restSeconds: 90,
        ),
        reason: 'r',
      );
      final swapped = p.copyWith(exerciseId: 'b');
      expect(swapped.exerciseId, 'b');
      expect(swapped.prescription, p.prescription);
      expect(swapped.reason, 'r');
    });

    test('profile copyWith replaces only given fields', () {
      final p = const TrainingProfile().copyWith(
        experience: Experience.advanced,
        units: Units.lb,
        sessionMinutes: 30,
      );
      expect(p.experience, Experience.advanced);
      expect(p.units, Units.lb);
      expect(p.goal, Goal.muscle);
    });

    test('catalog enums reject unknown values', () {
      expect(() => MovementPattern.parse('nope'), throwsArgumentError);
      expect(() => Joint.parse('nope'), throwsArgumentError);
      expect(Level.parse('expert'), Level.expert);
      expect(Equipment.fromCatalog('pull-up bar'), Equipment.pullUpBar);
      expect(Equipment.fromCatalog('cable'), Equipment.gym);
    });
  });

  group('training days', () {
    test('default spreads leave recovery gaps', () {
      expect(const TrainingProfile(daysPerWeek: 2).trainingDays, [1, 4]);
      expect(const TrainingProfile().trainingDays, [1, 3, 5]);
    });

    test('preferred days win when the count matches', () {
      expect(const TrainingProfile(preferredDays: {6, 2, 4}).trainingDays, [
        2,
        4,
        6,
      ]);
    });
  });
}
