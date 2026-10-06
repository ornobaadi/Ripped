/// What to say under the current set. Chosen from facts only, so the same
/// moment always gets the same line (and tests stay stable). Never guilt.
enum Cue {
  /// Very first set of the workout.
  start,

  /// First set of a later exercise.
  newExercise,

  /// Somewhere in the middle of an exercise.
  keepGoing,

  /// Half of the whole workout is behind you.
  halfway,

  /// Last set of this exercise.
  lastSet,

  /// Last set of the whole workout.
  finalSet,
}

abstract final class Encouragement {
  /// [setIndex] is zero-based within the exercise; the "done" counts
  /// exclude the set about to be performed.
  static Cue pick({
    required int setIndex,
    required int setsInExercise,
    required int doneInWorkout,
    required int totalInWorkout,
  }) {
    final remaining = totalInWorkout - doneInWorkout;
    if (remaining <= 1) return Cue.finalSet;
    if (doneInWorkout == 0) return Cue.start;
    if (setIndex >= setsInExercise - 1) return Cue.lastSet;
    // The set that crosses the halfway line.
    final half = totalInWorkout / 2;
    if (doneInWorkout < half && doneInWorkout + 1 >= half) return Cue.halfway;
    if (setIndex == 0) return Cue.newExercise;
    return Cue.keepGoing;
  }
}
