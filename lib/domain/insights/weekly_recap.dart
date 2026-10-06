import 'package:ripped/domain/insights/session_log.dart';
import 'package:ripped/domain/plan/schedule.dart';

/// One calendar week of training in numbers. Totals only: nothing here
/// identifies the person, so the card is safe to share.
class WeeklyRecap {
  const new({
    required this.weekStart,
    required this.workouts,
    required this.sets,
    required this.volumeKg,
    required this.minutes,
    required this.previousVolumeKg,
    required this.previousWorkouts,
    required this.sessions,
  });

  /// The week containing [now], compared with the week before it.
  factory of(List<SessionLog> all, DateTime now) {
    final start = Schedule.weekStart(now);
    final end = Schedule.addDays(start, 7);
    final previousStart = Schedule.addDays(start, -7);
    bool within(SessionLog s, DateTime from, DateTime to) =>
        !s.startedAt.isBefore(from) && s.startedAt.isBefore(to);

    final week = [
      for (final s in all)
        if (within(s, start, end)) s,
    ];
    final previous = [
      for (final s in all)
        if (within(s, previousStart, start)) s,
    ];
    return WeeklyRecap(
      weekStart: start,
      workouts: week.length,
      sets: week.fold(0, (n, s) => n + s.sets.length),
      volumeKg: week.fold(0, (n, s) => n + s.volumeKg),
      minutes: week.fold(0, (n, s) => n + s.duration.inMinutes),
      previousVolumeKg: previous.fold(0, (n, s) => n + s.volumeKg),
      previousWorkouts: previous.length,
      sessions: week,
    );
  }

  final DateTime weekStart;
  final int workouts;
  final int sets;
  final double volumeKg;
  final int minutes;
  final double previousVolumeKg;
  final int previousWorkouts;
  final List<SessionLog> sessions;

  bool get isEmpty => workouts == 0;

  /// Volume change vs last week as a fraction (0.12 = +12%), or null when
  /// there's nothing to compare with.
  double? get volumeChange => previousVolumeKg <= 0 || volumeKg <= 0
      ? null
      : (volumeKg - previousVolumeKg) / previousVolumeKg;
}
