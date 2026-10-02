import 'dart:math' as math;

import 'package:meta/meta.dart';
import 'package:ripped/domain/catalog/exercise.dart';
import 'package:ripped/domain/plan/profile.dart';

/// Per-exercise memory between sessions (architecture.md 4.2
/// `exercise_state`). Weight is always kg; null for unloaded work.
@immutable
class ExerciseProgress {
  const new({
    required this.repTarget,
    this.weightKg,
    this.stallCount = 0,
    this.lastTotalReps = 0,
  });

  final double? weightKg;

  /// Reps (or seconds) to aim for on every working set next time.
  final int repTarget;
  final int stallCount;

  /// Sum of working reps last session; "did reps improve?" baseline.
  final int lastTotalReps;

  @override
  bool operator ==(Object other) =>
      other is ExerciseProgress &&
      other.weightKg == weightKg &&
      other.repTarget == repTarget &&
      other.stallCount == stallCount &&
      other.lastTotalReps == lastTotalReps;

  @override
  int get hashCode =>
      Object.hash(weightKg, repTarget, stallCount, lastTotalReps);

  @override
  String toString() =>
      'ExerciseProgress($weightKg kg, target $repTarget, '
      'stalls $stallCount, last $lastTotalReps)';
}

class SetResult {
  const new({required this.reps, this.weightKg});

  final double? weightKg;
  final int reps;
}

enum Feeling { easy, justRight, tough }

enum ProgressionDecision {
  /// First session: we now know the working weight.
  baseline,
  increaseWeight,
  increaseReps,

  /// Bodyweight/timed at the top of the range: time for a harder variation.
  suggestHarderVariation,
  hold,
  deload,
}

class ProgressionOutcome {
  const new(this.decision, this.next);

  final ProgressionDecision decision;
  final ExerciseProgress next;
}

/// Double progression with auto-deload (architecture.md 6.3).
/// Pure: same inputs, same output. At most one step per session.
class ProgressionEngine {
  const new();

  static const stallsBeforeDeload = 3;
  static const deloadFactor = 0.9;

  ProgressionOutcome evaluate({
    required ExerciseProgress? previous,
    required List<SetResult> workingSets,
    required int repMin,
    required int repMax,
    required double incrementKg,
    Feeling? feeling,
  }) {
    final total = workingSets.fold(0, (sum, s) => sum + s.reps);
    final weight = _workingWeight(workingSets);

    if (workingSets.isEmpty) {
      return ProgressionOutcome(
        ProgressionDecision.hold,
        previous ?? ExerciseProgress(repTarget: repMin, weightKg: weight),
      );
    }

    final hitTop = workingSets.every((s) => s.reps >= repMax);

    if (previous == null) {
      return ProgressionOutcome(
        ProgressionDecision.baseline,
        ExerciseProgress(
          weightKg: weight,
          repTarget: _clampTarget(_minReps(workingSets) + 1, repMin, repMax),
          lastTotalReps: total,
        ),
      );
    }

    final weighted = weight != null;
    // Lifting less than prescribed doesn't earn a weight increase.
    final atPrescribedLoad =
        !weighted || previous.weightKg == null || weight >= previous.weightKg!;

    if (hitTop && atPrescribedLoad && feeling != Feeling.tough) {
      if (weighted) {
        return ProgressionOutcome(
          ProgressionDecision.increaseWeight,
          ExerciseProgress(
            weightKg: _round(weight + incrementKg, incrementKg),
            repTarget: repMin,
            lastTotalReps: total,
          ),
        );
      }
      return ProgressionOutcome(
        ProgressionDecision.suggestHarderVariation,
        ExerciseProgress(repTarget: repMax, lastTotalReps: total),
      );
    }

    if (total > previous.lastTotalReps) {
      return ProgressionOutcome(
        ProgressionDecision.increaseReps,
        ExerciseProgress(
          weightKg: weight ?? previous.weightKg,
          repTarget: _clampTarget(previous.repTarget + 1, repMin, repMax),
          lastTotalReps: total,
        ),
      );
    }

    final stalls = previous.stallCount + 1;
    if (stalls >= stallsBeforeDeload) {
      final base = weight ?? previous.weightKg;
      return ProgressionOutcome(
        ProgressionDecision.deload,
        ExerciseProgress(
          weightKg: base == null
              ? null
              : math.max(incrementKg, _round(base * deloadFactor, incrementKg)),
          repTarget: repMin,
          lastTotalReps: total,
        ),
      );
    }

    return ProgressionOutcome(
      ProgressionDecision.hold,
      ExerciseProgress(
        weightKg: weight ?? previous.weightKg,
        repTarget: previous.repTarget,
        stallCount: stalls,
        lastTotalReps: total,
      ),
    );
  }

  /// The heaviest weight used on working sets.
  static double? _workingWeight(List<SetResult> sets) {
    double? best;
    for (final s in sets) {
      final w = s.weightKg;
      if (w != null && (best == null || w > best)) best = w;
    }
    return best;
  }

  static int _minReps(List<SetResult> sets) =>
      sets.map((s) => s.reps).reduce(math.min);

  static int _clampTarget(int v, int min, int max) => v.clamp(min, max);

  static double _round(double kg, double step) =>
      double.parse(((kg / step).round() * step).toStringAsFixed(3));
}

/// Smallest sensible load jump per equipment (architecture.md 6.3).
abstract final class LoadIncrements {
  static const _lbToKg = 0.45359237;

  static double forExercise(Exercise e, Units units) {
    final label = e.equipmentLabel;
    return switch (units) {
      Units.kg => switch (label) {
        'barbell' || 'e-z curl bar' => 2.5,
        'dumbbell' => 2,
        'kettlebells' => 4,
        'machine' || 'cable' => 5,
        _ => 2.5,
      },
      Units.lb => switch (label) {
        'kettlebells' => 10 * _lbToKg,
        'machine' || 'cable' => 10 * _lbToKg,
        _ => 5 * _lbToKg,
      },
    };
  }

  /// Light, safe first-session starting point ("find your weight"), in
  /// round numbers for the user's units.
  static double? startingWeightKg(Exercise e, [Units units = Units.kg]) {
    if (!e.isWeighted) return null;
    return switch (units) {
      Units.kg => switch (e.equipmentLabel) {
        'barbell' => 20,
        'e-z curl bar' => 10,
        'dumbbell' => 5,
        'kettlebells' => 8,
        'machine' || 'cable' => 10,
        _ => 5,
      },
      Units.lb =>
        switch (e.equipmentLabel) {
              'barbell' => 45,
              'e-z curl bar' => 25,
              'dumbbell' => 10,
              'kettlebells' => 20,
              'machine' || 'cable' => 20,
              _ => 10,
            } *
            _lbToKg,
    };
  }
}
