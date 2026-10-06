import 'package:ripped/domain/catalog/exercise.dart';
import 'package:ripped/domain/insights/session_log.dart';

/// Broad groups people actually think in; the catalog's finer muscle names
/// are folded into these.
enum MuscleGroup {
  chest,
  back,
  shoulders,
  arms,
  core,
  legs;

  static MuscleGroup? fromCatalog(String muscle) => switch (muscle) {
    'chest' => chest,
    'lats' || 'middle back' || 'lower back' || 'traps' => back,
    'shoulders' || 'neck' => shoulders,
    'biceps' || 'triceps' || 'forearms' => arms,
    'abdominals' => core,
    'quadriceps' ||
    'hamstrings' ||
    'glutes' ||
    'calves' ||
    'adductors' ||
    'abductors' => legs,
    _ => null,
  };
}

abstract final class MuscleBalance {
  /// Logged sets per group (by each exercise's primary muscle), every group
  /// present so the chart keeps a stable order.
  static Map<MuscleGroup, int> setsPerGroup(
    Iterable<SessionLog> sessions,
    Exercise? Function(String id) exercise,
  ) {
    final totals = {for (final g in MuscleGroup.values) g: 0};
    for (final session in sessions) {
      for (final set in session.sets) {
        final primary = exercise(set.exerciseId)?.primaryMuscles.firstOrNull;
        final group = primary == null ? null : MuscleGroup.fromCatalog(primary);
        if (group != null) totals[group] = totals[group]! + 1;
      }
    }
    return totals;
  }

  static MuscleGroup? top(Map<MuscleGroup, int> sets) {
    MuscleGroup? best;
    for (final MapEntry(:key, :value) in sets.entries) {
      if (value > 0 && (best == null || value > sets[best]!)) best = key;
    }
    return best;
  }
}
