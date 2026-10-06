import 'package:meta/meta.dart';
import 'package:ripped/domain/plan/schedule.dart';

enum NoticeKind {
  /// "Today is a training day."
  workout,

  /// "Yesterday's workout is still waiting."
  catchUp,
}

@immutable
class Notice {
  const new(this.kind, this.at);

  final NoticeKind kind;
  final DateTime at;

  @override
  bool operator ==(Object other) =>
      other is Notice && other.kind == kind && other.at == at;

  @override
  int get hashCode => Object.hash(kind, at);

  @override
  String toString() => 'Notice(${kind.name}, $at)';
}

/// Decides which notifications are worth sending. The whole list is rebuilt
/// whenever something changes (app opened, workout finished, settings), so
/// nothing stale is ever left scheduled.
///
/// Rules, all aimed at never being noise:
/// - only on the user's own training days, at their chosen time;
/// - never for a day they have already trained;
/// - at most one catch-up, the day after a missed workout, and only when
///   that day isn't a training day with its own reminder;
/// - nothing beyond [windowDays]: someone who hasn't opened the app for a
///   week is left alone.
abstract final class NotificationPlanner {
  static const windowDays = 7;

  static List<Notice> plan({
    required DateTime now,
    required Set<int> trainingWeekdays,
    required int hour,
    required int minute,
    required List<DateTime> completedAt,
    DateTime? planSince,
    DateTime? missedHandled,
  }) {
    if (trainingWeekdays.isEmpty) return const [];
    final today = DateTime(now.year, now.month, now.day);
    DateTime at(DateTime day) =>
        DateTime(day.year, day.month, day.day, hour, minute);
    final trainedToday = completedAt.any((d) => Schedule.sameDay(d, now));
    final notices = <Notice>[];

    // Reminders for upcoming training days.
    DateTime? firstOpenTrainingDay;
    for (var i = 0; i < windowDays; i++) {
      final day = Schedule.addDays(today, i);
      if (!trainingWeekdays.contains(day.weekday)) continue;
      if (i == 0 && trainedToday) continue;
      firstOpenTrainingDay ??= day;
      if (at(day).isAfter(now)) {
        notices.add(Notice(NoticeKind.workout, at(day)));
      }
    }

    // One catch-up after the next training day, in case it gets missed.
    // Finishing that workout rebuilds the plan and removes it.
    if (firstOpenTrainingDay != null) {
      final after = Schedule.addDays(firstOpenTrainingDay, 1);
      if (!trainingWeekdays.contains(after.weekday) && at(after).isAfter(now)) {
        notices.add(Notice(NoticeKind.catchUp, at(after)));
      }
    }

    // A workout already missed yesterday, on a rest day, not yet dealt with.
    final missed = Schedule.missedDay(
      now: now,
      trainingWeekdays: trainingWeekdays,
      completedAt: completedAt,
      planSince: planSince,
    );
    if (missed != null &&
        Schedule.sameDay(Schedule.addDays(missed, 1), now) &&
        !trainingWeekdays.contains(now.weekday) &&
        !(missedHandled != null && Schedule.sameDay(missedHandled, missed)) &&
        at(today).isAfter(now)) {
      notices.add(Notice(NoticeKind.catchUp, at(today)));
    }

    final unique = notices.toSet().toList()
      ..sort((a, b) => a.at.compareTo(b.at));
    return unique;
  }
}
