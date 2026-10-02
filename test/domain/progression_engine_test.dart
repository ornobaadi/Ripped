import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/domain/catalog/exercise.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/domain/progression/progression_engine.dart';

List<SetResult> sets(List<int> reps, [double? kg]) => [
  for (final r in reps) SetResult(reps: r, weightKg: kg),
];

void main() {
  const engine = ProgressionEngine();

  ProgressionOutcome run(
    ExerciseProgress? prev,
    List<SetResult> working, {
    Feeling? feeling,
    int min = 8,
    int max = 12,
  }) => engine.evaluate(
    previous: prev,
    workingSets: working,
    repMin: min,
    repMax: max,
    incrementKg: 2.5,
    feeling: feeling,
  );

  group('first session', () {
    test('sets a baseline from what was lifted', () {
      final out = run(null, sets([10, 9, 8], 40));
      expect(out.decision, ProgressionDecision.baseline);
      expect(
        out.next,
        const ExerciseProgress(weightKg: 40, repTarget: 9, lastTotalReps: 27),
      );
    });

    test('baseline target stays inside the range', () {
      expect(run(null, sets([12, 12], 40)).next.repTarget, 12);
      expect(run(null, sets([3, 3], 40)).next.repTarget, 8);
    });
  });

  group('double progression', () {
    const prev = ExerciseProgress(
      weightKg: 40,
      repTarget: 12,
      lastTotalReps: 33,
    );

    test('all sets at the top of the range adds weight, resets reps', () {
      final out = run(prev, sets([12, 12, 12], 40));
      expect(out.decision, ProgressionDecision.increaseWeight);
      expect(out.next.weightKg, 42.5);
      expect(out.next.repTarget, 8);
      expect(out.next.stallCount, 0);
    });

    test('"Tough" feeling blocks the weight jump', () {
      final out = run(prev, sets([12, 12, 12], 40), feeling: Feeling.tough);
      expect(out.decision, isNot(ProgressionDecision.increaseWeight));
    });

    test('hitting reps at a lighter weight does not add weight', () {
      final out = run(prev, sets([12, 12, 12], 35));
      expect(out.decision, isNot(ProgressionDecision.increaseWeight));
    });

    test('more total reps keeps weight and adds one rep to target', () {
      const p = ExerciseProgress(weightKg: 40, repTarget: 9, lastTotalReps: 27);
      final out = run(p, sets([10, 10, 9], 40));
      expect(out.decision, ProgressionDecision.increaseReps);
      expect(out.next.weightKg, 40);
      expect(out.next.repTarget, 10);
    });

    test('rep target never exceeds the range', () {
      const p = ExerciseProgress(
        weightKg: 40,
        repTarget: 12,
        lastTotalReps: 30,
      );
      expect(run(p, sets([12, 11, 11], 40)).next.repTarget, 12);
    });

    test('only one step per session, however good the session', () {
      final out = run(prev, sets([20, 20, 20], 40));
      expect(out.next.weightKg, 42.5);
    });
  });

  group('stalls and deload', () {
    test('no improvement counts a stall and holds', () {
      const p = ExerciseProgress(weightKg: 50, repTarget: 9, lastTotalReps: 27);
      final out = run(p, sets([9, 9, 9], 50));
      expect(out.decision, ProgressionDecision.hold);
      expect(out.next.stallCount, 1);
      expect(out.next.weightKg, 50);
    });

    test('third stall deloads 10% and resets reps', () {
      const p = ExerciseProgress(
        weightKg: 50,
        repTarget: 9,
        stallCount: 2,
        lastTotalReps: 27,
      );
      final out = run(p, sets([9, 9, 8], 50));
      expect(out.decision, ProgressionDecision.deload);
      expect(out.next.weightKg, 45);
      expect(out.next.repTarget, 8);
      expect(out.next.stallCount, 0);
    });

    test('deload rounds to the plate increment and never hits zero', () {
      const p = ExerciseProgress(
        weightKg: 2.5,
        repTarget: 9,
        stallCount: 2,
        lastTotalReps: 27,
      );
      expect(run(p, sets([5, 5, 5], 2.5)).next.weightKg, 2.5);
    });
  });

  group('bodyweight', () {
    test('reps climb to the ceiling, then suggest a harder variation', () {
      const p = ExerciseProgress(repTarget: 11, lastTotalReps: 30);
      expect(
        run(p, sets([11, 11, 11])).decision,
        ProgressionDecision.increaseReps,
      );
      final top = run(p, sets([12, 12, 12]));
      expect(top.decision, ProgressionDecision.suggestHarderVariation);
      expect(top.next.weightKg, isNull);
      expect(top.next.repTarget, 12);
    });
  });

  test('progress values compare by value', () {
    const a = ExerciseProgress(weightKg: 40, repTarget: 8);
    expect(a, const ExerciseProgress(weightKg: 40, repTarget: 8));
    expect(
      a.hashCode,
      const ExerciseProgress(weightKg: 40, repTarget: 8).hashCode,
    );
    expect(a.toString(), contains('40'));
  });

  test('empty session with no history starts at the bottom of the range', () {
    final out = run(null, const []);
    expect(out.next.repTarget, 8);
  });

  test('empty session holds state', () {
    const p = ExerciseProgress(weightKg: 40, repTarget: 10);
    final out = run(p, const []);
    expect(out.decision, ProgressionDecision.hold);
    expect(out.next, p);
  });

  group('load increments', () {
    Exercise e(String label, {bool bodyweight = false}) => Exercise(
      id: 'x',
      name: 'x',
      pattern: MovementPattern.squat,
      equipment: Equipment.gym,
      equipmentLabel: label,
      level: Level.beginner,
      priority: 1,
      isBodyweight: bodyweight,
    );

    test('metric steps by equipment', () {
      expect(LoadIncrements.forExercise(e('barbell'), Units.kg), 2.5);
      expect(LoadIncrements.forExercise(e('dumbbell'), Units.kg), 2);
      expect(LoadIncrements.forExercise(e('machine'), Units.kg), 5);
    });

    test('imperial steps are whole pounds', () {
      final lb = LoadIncrements.forExercise(e('barbell'), Units.lb);
      expect(lb / 0.45359237, closeTo(5, 1e-9));
    });

    test('every equipment type has a sensible step in both units', () {
      for (final label in [
        'barbell',
        'e-z curl bar',
        'dumbbell',
        'kettlebells',
        'machine',
        'cable',
        'other',
      ]) {
        for (final units in Units.values) {
          final step = LoadIncrements.forExercise(e(label), units);
          expect(step, inInclusiveRange(1.5, 5), reason: '$label $units');
        }
      }
    });

    test('imperial starting weights are round pounds', () {
      for (final (label, lb) in [
        ('barbell', 45),
        ('e-z curl bar', 25),
        ('dumbbell', 10),
        ('kettlebells', 20),
        ('machine', 20),
        ('other', 10),
      ]) {
        final kg = LoadIncrements.startingWeightKg(e(label), Units.lb)!;
        expect(kg / 0.45359237, closeTo(lb, 1e-9), reason: label);
      }
      expect(LoadIncrements.startingWeightKg(e('kettlebells')), 8);
      expect(LoadIncrements.startingWeightKg(e('machine')), 10);
      expect(LoadIncrements.startingWeightKg(e('e-z curl bar')), 10);
      expect(LoadIncrements.startingWeightKg(e('other')), 5);
    });

    test('starting weights are light; bodyweight has none', () {
      expect(LoadIncrements.startingWeightKg(e('barbell')), 20);
      expect(
        LoadIncrements.startingWeightKg(e('body only', bodyweight: true)),
        isNull,
      );
    });
  });
}
