import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/domain/plan/schedule.dart';

void main() {
  // 2026-10-05 is a Monday.
  final monday = DateTime(2026, 10, 5, 9);
  const profile = TrainingProfile(); // Mon/Wed/Fri

  TodayStatus status(
    DateTime now, {
    List<DateTime> done = const [],
    int? last,
  }) => Schedule.today(
    now: now,
    profile: profile,
    programDayCount: 3,
    completedAt: done,
    lastCompletedDayIndex: last,
  );

  test('scheduled day with nothing logged is a training day', () {
    final s = status(monday);
    expect(s.kind, TodayKind.training);
    expect(s.nextDayIndex, 0);
    expect(s.weeklyTarget, 3);
  });

  test('unscheduled day is a rest day', () {
    expect(status(monday.add(const Duration(days: 1))).kind, TodayKind.rest);
  });

  test('a completed workout today marks the day done', () {
    final s = status(monday, done: [monday], last: 0);
    expect(s.kind, TodayKind.done);
    expect(s.completedThisWeek, 1);
  });

  test('rotation continues from the last completed day and wraps', () {
    expect(status(monday, last: 0).nextDayIndex, 1);
    expect(status(monday, last: 2).nextDayIndex, 0);
  });

  test('only this week counts toward the weekly target', () {
    final s = status(
      monday.add(const Duration(days: 2)),
      done: [monday.subtract(const Duration(days: 2)), monday],
    );
    expect(s.completedThisWeek, 1);
  });

  test('weekly strip marks done, today, planned and rest days', () {
    final s = status(monday.add(const Duration(days: 2)), done: [monday]);
    expect(s.weekDays, [
      WeekDayState.done,
      WeekDayState.rest,
      WeekDayState.today,
      WeekDayState.rest,
      WeekDayState.planned,
      WeekDayState.rest,
      WeekDayState.rest,
    ]);
  });

  test('week starts on Monday', () {
    expect(Schedule.weekStart(DateTime(2026, 10, 11)), DateTime(2026, 10, 5));
  });
}
