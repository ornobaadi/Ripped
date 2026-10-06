import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/domain/catalog/exercise.dart';
import 'package:ripped/domain/plan/plan_generator.dart';
import 'package:ripped/domain/plan/plan_summary.dart';
import 'package:ripped/domain/plan/profile.dart';

import '../helpers/catalog.dart';

void main() {
  final generator = PlanGenerator(realCatalog());

  test('summarises the answers and the plan', () {
    const profile = TrainingProfile(
      daysPerWeek: 4,
      sessionMinutes: 60,
      equipment: {Equipment.bodyweight, Equipment.bands, Equipment.dumbbells},
      avoid: {Joint.shoulder, Joint.knee},
    );
    final plan = generator.generate(profile);
    final summary = PlanSummary.of(profile, plan);

    expect(summary.daysPerWeek, 4);
    expect(summary.sessionMinutes, 60);
    expect(summary.trainingWeekdays, hasLength(4));
    // Bodyweight is implied; the rest in a stable order.
    expect(summary.equipment, [Equipment.dumbbells, Equipment.bands]);
    expect(summary.protecting, [Joint.knee, Joint.shoulder]);
    expect(summary.workouts, plan.days.length);
    expect(
      summary.totalExercises,
      plan.days.fold<int>(0, (n, d) => n + d.exercises.length),
    );
    expect(summary.bodyweightOnly, isFalse);
  });

  test('a full gym is one item; no equipment is bodyweight only', () {
    final gym = PlanSummary.from(
      const TrainingProfile(
        equipment: {Equipment.gym, Equipment.dumbbells, Equipment.bodyweight},
      ),
      workouts: 3,
      totalExercises: 15,
    );
    expect(gym.equipment, [Equipment.gym]);

    final none = PlanSummary.from(
      const TrainingProfile(equipment: {Equipment.bodyweight}),
      workouts: 3,
      totalExercises: 12,
    );
    expect(none.bodyweightOnly, isTrue);
    expect(none.protecting, isEmpty);
  });
}
