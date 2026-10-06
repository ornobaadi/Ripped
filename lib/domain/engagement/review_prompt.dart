/// When to ask for a store review (phases.md Phase 5): only after a
/// positive moment, only once someone has a little history, and rarely.
abstract final class ReviewPrompt {
  static const minWorkouts = 3;
  static const daysBetweenAsks = 120;

  static bool shouldAsk({
    required int completedWorkouts,
    required bool positiveMoment,
    required DateTime now,
    DateTime? lastAskedAt,
  }) {
    if (!positiveMoment || completedWorkouts < minWorkouts) return false;
    if (lastAskedAt == null) return true;
    return now.difference(lastAskedAt).inDays >= daysBetweenAsks;
  }
}
