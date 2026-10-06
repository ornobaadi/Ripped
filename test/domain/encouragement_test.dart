import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/domain/engagement/encouragement.dart';

void main() {
  Cue pick(int setIndex, int sets, int done, int total) => Encouragement.pick(
    setIndex: setIndex,
    setsInExercise: sets,
    doneInWorkout: done,
    totalInWorkout: total,
  );

  test('first set of the workout', () {
    expect(pick(0, 3, 0, 12), Cue.start);
  });

  test('middle of an exercise', () {
    expect(pick(1, 4, 1, 12), Cue.keepGoing);
  });

  test('last set of an exercise', () {
    expect(pick(2, 3, 2, 12), Cue.lastSet);
  });

  test('first set of a later exercise', () {
    expect(pick(0, 3, 3, 12), Cue.newExercise);
  });

  test('the set that crosses halfway', () {
    expect(pick(1, 4, 5, 12), Cue.halfway);
    // Odd totals: 7 sets, the 4th crosses 3.5.
    expect(pick(1, 4, 3, 7), Cue.halfway);
  });

  test('last set of the workout wins over everything', () {
    expect(pick(2, 3, 11, 12), Cue.finalSet);
    expect(pick(0, 1, 0, 1), Cue.finalSet);
  });
}
