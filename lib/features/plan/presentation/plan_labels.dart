import 'package:ripped/domain/catalog/exercise.dart';
import 'package:ripped/domain/plan/plan_summary.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/l10n/l10n.dart';

/// Words for the facts in a [PlanSummary], shared by the building view and
/// the plan header.
extension PlanSummaryLabels on PlanSummary {
  String goalLabel(AppLocalizations l) => switch (goal) {
    Goal.strength => l.goalStrength,
    Goal.muscle => l.goalMuscle,
    Goal.fitness => l.goalFitness,
    Goal.fatLoss => l.goalFatLoss,
    Goal.mobility => l.goalMobility,
  };

  String scheduleLabel(AppLocalizations l) =>
      l.factSchedule(daysPerWeek, sessionMinutes);

  String equipmentLabel(AppLocalizations l) => bodyweightOnly
      ? l.factBodyweight
      : l.factEquipment(
          equipment
              .map(
                (e) => switch (e) {
                  Equipment.gym => l.eqGym,
                  Equipment.dumbbells => l.eqDumbbells,
                  Equipment.kettlebells => l.eqKettlebells,
                  Equipment.bands => l.eqBands,
                  Equipment.pullUpBar => l.eqPullUpBar,
                  Equipment.bodyweight => l.eqBodyweight,
                },
              )
              .join(', '),
        );

  /// Null when nothing needs protecting.
  String? protectLabel(AppLocalizations l) => protecting.isEmpty
      ? null
      : l.factProtect(
          protecting
              .map(
                (j) => switch (j) {
                  Joint.knee => l.jointKnee,
                  Joint.lowerBack => l.jointLowerBack,
                  Joint.shoulder => l.jointShoulder,
                  Joint.wrist => l.jointWrist,
                  Joint.elbow => l.jointElbow,
                  Joint.hip => l.jointHip,
                },
              )
              .join(', ')
              .toLowerCase(),
        );

  String exercisesLabel(AppLocalizations l) =>
      l.factExercises(totalExercises, workouts);

  /// The lines that tick off while the plan is built.
  List<String> buildSteps(AppLocalizations l) => [
    scheduleLabel(l),
    equipmentLabel(l),
    ?protectLabel(l),
    exercisesLabel(l),
  ];
}
