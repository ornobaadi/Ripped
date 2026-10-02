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
  static DateTime weekStart(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  static bool sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static TodayStatus today({
    required DateTime now,
    required TrainingProfile profile,
    required int programDayCount,
    required List<DateTime> completedAt,
    required int? lastCompletedDayIndex,
  }) {
    final start = weekStart(now);
    final end = start.add(const Duration(days: 7));
    final thisWeek = completedAt
        .where((d) => !d.isBefore(start) && d.isBefore(end))
        .toList();
    final doneToday = thisWeek.any((d) => sameDay(d, now));
    final trainingDays = profile.trainingDays.toSet();

    final next = programDayCount == 0 || lastCompletedDayIndex == null
        ? 0
        : (lastCompletedDayIndex + 1) % programDayCount;

    final week = [
      for (var i = 0; i < 7; i++)
        () {
          final day = start.add(Duration(days: i));
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
