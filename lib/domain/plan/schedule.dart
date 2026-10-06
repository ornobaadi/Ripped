import 'package:ripped/domain/plan/profile.dart';

enum TodayKind {
  /// Scheduled training day, nothing logged yet.
  training,

  /// Not a scheduled day (the user can still train if they want).
  rest,

  /// A workout was already completed today.
  done,
}

class TodayStatus {
  const new({
    required this.kind,
    required this.nextDayIndex,
    required this.completedThisWeek,
    required this.weeklyTarget,
    required this.weekDays,
  });

  final TodayKind kind;

  /// Program day to do next. Rotation, not weekday: a missed Monday
  /// shifts to the next session instead of being skipped.
  final int nextDayIndex;
  final int completedThisWeek;
  final int weeklyTarget;

  /// Monday..Sunday of the current week, for the weekly strip.
  final List<WeekDayState> weekDays;
}

enum WeekDayState { done, planned, rest, today }

/// Pure scheduling rules for the Today screen.
abstract final class Schedule {
  /// Monday 00:00 of [date]'s week.
  /// Calendar arithmetic, not Duration: a DST day is 23 or 25 hours long.
  static DateTime weekStart(DateTime date) =>
      DateTime(date.year, date.month, date.day - (date.weekday - 1));

  static DateTime addDays(DateTime date, int days) =>
      DateTime(date.year, date.month, date.day + days);

  static bool sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// How far back a missed workout is still worth mentioning.
  static const missedLookbackDays = 3;

  /// The most recent training day before today that went by without a
  /// workout (and nothing was done since), or null. Days before the plan
  /// existed don't count.
  static DateTime? missedDay({
    required DateTime now,
    required Set<int> trainingWeekdays,
    required List<DateTime> completedAt,
    DateTime? planSince,
  }) {
    final today = DateTime(now.year, now.month, now.day);
    for (var back = 1; back <= missedLookbackDays; back++) {
      final day = addDays(today, -back);
      if (!trainingWeekdays.contains(day.weekday)) continue;
      // Only the latest scheduled day matters.
      if (planSince == null || !planSince.isBefore(day)) return null;
      final trainedSince = completedAt.any((d) => !d.isBefore(day));
      return trainedSince ? null : day;
    }
    return null;
  }

  static TodayStatus today({
    required DateTime now,
    required TrainingProfile profile,
    required int programDayCount,
    required List<DateTime> completedAt,
    required int? lastCompletedDayIndex,
    int? nextDayOverride,
  }) {
    final start = weekStart(now);
    final end = addDays(start, 7);
    final thisWeek = completedAt
        .where((d) => !d.isBefore(start) && d.isBefore(end))
        .toList();
    final doneToday = thisWeek.any((d) => sameDay(d, now));
    final trainingDays = profile.trainingDays.toSet();

    // The user's own pick (skip a workout, choose another) wins over the
    // rotation.
    final next = programDayCount == 0
        ? 0
        : nextDayOverride != null
        ? nextDayOverride % programDayCount
        : lastCompletedDayIndex == null
        ? 0
        : (lastCompletedDayIndex + 1) % programDayCount;

    final week = [
      for (var i = 0; i < 7; i++)
        () {
          final day = addDays(start, i);
          if (thisWeek.any((d) => sameDay(d, day))) return WeekDayState.done;
          if (sameDay(day, now)) return WeekDayState.today;
          return trainingDays.contains(day.weekday)
              ? WeekDayState.planned
              : WeekDayState.rest;
        }(),
    ];

    return TodayStatus(
      kind: doneToday
          ? TodayKind.done
          : trainingDays.contains(now.weekday)
          ? TodayKind.training
          : TodayKind.rest,
      nextDayIndex: next,
      completedThisWeek: thisWeek.length,
      weeklyTarget: profile.daysPerWeek,
      weekDays: week,
    );
  }
}
