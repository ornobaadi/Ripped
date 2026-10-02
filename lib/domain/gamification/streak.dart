import 'package:meta/meta.dart';
import 'package:ripped/domain/plan/schedule.dart';

enum WeekStatus {
  /// Weekly target met.
  hit,

  /// Missed, but the month's free shield covered it.
  shielded,

  /// Missed and not covered (the streak restarted).
  missed,

  /// The week in progress: never counts against the user.
  current,
}

@immutable
class StreakWeek {
  const new({required this.start, required this.done, required this.status});

  /// Monday of the week (local date).
  final DateTime start;
  final int done;
  final WeekStatus status;

  @override
  bool operator ==(Object other) =>
      other is StreakWeek &&
      other.start == start &&
      other.done == done &&
      other.status == status;

  @override
  int get hashCode => Object.hash(start, done, status);

  @override
  String toString() => 'StreakWeek($start, $done, ${status.name})';
}

class StreakInfo {
  const new({
    required this.weeks,
    required this.history,
    required this.currentWeekDone,
    required this.target,
    required this.shieldAvailable,
  });

  /// Consecutive successful (hit or shielded) weeks, including the current
  /// week once its target is met.
  final int weeks;

  /// Oldest first, ending with the current week.
  final List<StreakWeek> history;
  final int currentWeekDone;
  final int target;

  /// Whether this month's shield is still unused.
  final bool shieldAvailable;
}

/// Weekly streak (PRD 7.7): weeks, not days, so rest is rewarded rather
/// than punished. One free shield per calendar month covers a missed week
/// automatically. Pure and deterministic: recomputed from workout dates.
abstract final class Streaks {
  /// After this long away the app says "Welcome back" (design.md 4).
  static const comebackGap = Duration(days: 14);

  static StreakInfo compute({
    required List<DateTime> workoutDates,
    required int weeklyTarget,
    required DateTime now,
  }) {
    final current = Schedule.weekStart(now);
    final counts = <DateTime, int>{};
    for (final d in workoutDates) {
      final w = Schedule.weekStart(d);
      if (w.isAfter(current)) continue;
      counts[w] = (counts[w] ?? 0) + 1;
    }
    final currentDone = counts[current] ?? 0;

    if (counts.isEmpty) {
      return StreakInfo(
        weeks: 0,
        history: [
          StreakWeek(start: current, done: 0, status: WeekStatus.current),
        ],
        currentWeekDone: 0,
        target: weeklyTarget,
        shieldAvailable: true,
      );
    }

    final first = counts.keys.reduce((a, b) => a.isBefore(b) ? a : b);
    final shieldUsedInMonth = <(int, int)>{};
    final history = <StreakWeek>[];
    var streak = 0;

    for (
      var week = first;
      !week.isAfter(current);
      week = Schedule.addDays(week, 7)
    ) {
      final done = counts[week] ?? 0;
      if (week == current) {
        history.add(
          StreakWeek(start: week, done: done, status: WeekStatus.current),
        );
        if (done >= weeklyTarget) streak++;
        break;
      }
      final month = (week.year, week.month);
      final WeekStatus status;
      if (done >= weeklyTarget) {
        status = WeekStatus.hit;
        streak++;
      } else if (streak > 0 && !shieldUsedInMonth.contains(month)) {
        // The shield protects an existing streak; it doesn't start one.
        shieldUsedInMonth.add(month);
        status = WeekStatus.shielded;
        streak++;
      } else {
        status = WeekStatus.missed;
        streak = 0;
      }
      history.add(StreakWeek(start: week, done: done, status: status));
    }

    return StreakInfo(
      weeks: streak,
      history: history,
      currentWeekDone: currentDone,
      target: weeklyTarget,
      shieldAvailable: !shieldUsedInMonth.contains((
        current.year,
        current.month,
      )),
    );
  }

  /// Whether finishing a workout now completes this week's target (and
  /// earns the streak-week bonus). [doneBefore] excludes this workout.
  static bool completesWeek({required int doneBefore, required int target}) =>
      doneBefore + 1 == target;

  /// Back after a long break: welcome them, never mention the gap.
  static bool isComeback({
    required DateTime? lastWorkout,
    required DateTime now,
  }) => lastWorkout != null && now.difference(lastWorkout) >= comebackGap;
}
