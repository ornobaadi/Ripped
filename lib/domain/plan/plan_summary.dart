import 'package:ripped/domain/catalog/exercise.dart';
import 'package:ripped/domain/plan/plan.dart';
import 'package:ripped/domain/plan/profile.dart';

/// The person's own answers and what the plan made of them, as plain facts
/// for the "building your plan" moment and the plan header.
class PlanSummary {
  const new({
    required this.goal,
    required this.daysPerWeek,
    required this.sessionMinutes,
    required this.trainingWeekdays,
    required this.equipment,
    required this.protecting,
    required this.workouts,
    required this.totalExercises,
  });

  factory of(TrainingProfile profile, GeneratedPlan plan) => PlanSummary.from(
    profile,
    workouts: plan.days.length,
    totalExercises: plan.days.fold(0, (n, d) => n + d.exercises.length),
  );

  /// From a saved program, where only the counts are at hand.
  factory from(
    TrainingProfile profile, {
    required int workouts,
    required int totalExercises,
  }) {
    final gear = profile.equipment.contains(Equipment.gym)
        ? [Equipment.gym]
        : ([...profile.equipment]
            ..remove(Equipment.bodyweight)
            ..sort((a, b) => a.index.compareTo(b.index)));
    return PlanSummary(
      goal: profile.goal,
      daysPerWeek: profile.daysPerWeek,
      sessionMinutes: profile.sessionMinutes,
      trainingWeekdays: profile.trainingDays,
      equipment: gear,
      protecting: profile.avoid.toList()
        ..sort((a, b) => a.index.compareTo(b.index)),
      workouts: workouts,
      totalExercises: totalExercises,
    );
  }

  final Goal goal;
  final int daysPerWeek;
  final int sessionMinutes;

  /// 1 = Monday … 7 = Sunday.
  final List<int> trainingWeekdays;

  /// What they train with. A full gym is just `[gym]`; empty means
  /// bodyweight only.
  final List<Equipment> equipment;

  /// Joints the plan goes easy on.
  final List<Joint> protecting;
  final int workouts;
  final int totalExercises;

  bool get bodyweightOnly => equipment.isEmpty;
}
