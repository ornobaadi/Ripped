/// Output of the plan generator. Persisted as a program.
library;

import 'package:meta/meta.dart';

enum SplitType { fullBody, upperLower, upperLowerPpl, pushPullLegs, bodyPart }

/// Sets x target range for one exercise. For timed exercises the range is
/// in seconds.
@immutable
class Prescription {
  const new({
    required this.sets,
    required this.repMin,
    required this.repMax,
    required this.restSeconds,
  });

  final int sets;
  final int repMin;
  final int repMax;
  final int restSeconds;

  @override
  bool operator ==(Object other) =>
      other is Prescription &&
      other.sets == sets &&
      other.repMin == repMin &&
      other.repMax == repMax &&
      other.restSeconds == restSeconds;

  @override
  int get hashCode => Object.hash(sets, repMin, repMax, restSeconds);

  @override
  String toString() => '${sets}x$repMin-$repMax r$restSeconds';
}

class PlannedExercise {
  const new({
    required this.exerciseId,
    required this.prescription,
    required this.reason,
  });

  final String exerciseId;
  final Prescription prescription;

  /// Human-readable "why this exercise" (architecture.md 6.1 step 6).
  final String reason;

  PlannedExercise copyWith({String? exerciseId, String? reason}) =>
      PlannedExercise(
        exerciseId: exerciseId ?? this.exerciseId,
        prescription: prescription,
        reason: reason ?? this.reason,
      );
}

class PlanDay {
  const new({required this.name, required this.exercises});

  final String name;
  final List<PlannedExercise> exercises;

  /// Rough session length: work + rest per set, plus changeover.
  int get estimatedMinutes {
    var seconds = 0;
    for (final e in exercises) {
      final p = e.prescription;
      seconds += p.sets * (40 + p.restSeconds) + 60;
    }
    return (seconds / 60).round();
  }
}

class GeneratedPlan {
  const new({
    required this.name,
    required this.split,
    required this.days,
    required this.generatorVersion,
  });

  final String name;
  final SplitType split;
  final List<PlanDay> days;
  final int generatorVersion;
}

/// Bounds for hand-edited plans, so a typo can't produce a harmful or
/// nonsensical session.
abstract final class PlanLimits {
  static const minSets = 1;
  static const maxSets = 8;
  static const minReps = 1;
  static const maxReps = 30;
  static const minRest = 15;
  static const maxRest = 300;
  static const restStep = 15;
  static const maxExercisesPerDay = 12;
  static const maxDayNameLength = 40;

  /// A prescription pulled back inside the bounds, with repMin <= repMax.
  static Prescription clamp(Prescription p) {
    final lo = p.repMin.clamp(minReps, maxReps);
    final hi = p.repMax.clamp(lo, maxReps);
    return Prescription(
      sets: p.sets.clamp(minSets, maxSets),
      repMin: lo,
      repMax: hi,
      restSeconds: p.restSeconds.clamp(minRest, maxRest),
    );
  }
}
