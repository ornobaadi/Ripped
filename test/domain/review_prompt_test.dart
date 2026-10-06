import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/domain/engagement/review_prompt.dart';

void main() {
  final now = DateTime(2026, 10, 6);
  bool ask({int workouts = 3, bool positive = true, DateTime? last}) =>
      ReviewPrompt.shouldAsk(
        completedWorkouts: workouts,
        positiveMoment: positive,
        now: now,
        lastAskedAt: last,
      );

  test('asks after the third workout with a positive moment', () {
    expect(ask(), isTrue);
    expect(ask(workouts: 12), isTrue);
  });

  test('never before three workouts or without a positive moment', () {
    expect(ask(workouts: 2), isFalse);
    expect(ask(positive: false), isFalse);
  });

  test('waits 120 days before asking again', () {
    expect(ask(last: DateTime(2026, 9)), isFalse);
    expect(ask(last: DateTime(2026, 6, 8)), isTrue);
    expect(ask(last: DateTime(2026, 6, 9)), isFalse);
  });
}
