import 'dart:math' as math;

import 'package:ripped/domain/insights/session_log.dart';
import 'package:ripped/domain/plan/schedule.dart';

/// Everything achievements are judged on. Derived from the log each time,
/// never stored (CLAUDE.md rule 6).
class AchievementStats {
  const new({
    this.workouts = 0,
    this.totalVolumeKg = 0,
    this.records = 0,
    this.level = 1,
    this.bestStreakWeeks = 0,
    this.distinctExercises = 0,
    this.mostRepsInWorkout = 0,
    this.longestMinutes = 0,
    this.earlyBird = false,
    this.nightOwl = false,
    this.comeback = false,
    this.fullWeekend = false,
  });

  /// [bestStreakWeeks], [records] and [level] come from their own engines.
  factory fromSessions(
    List<SessionLog> sessions, {
    int records = 0,
    int level = 1,
    int bestStreakWeeks = 0,
  }) {
    final sorted = [...sessions]
      ..sort((a, b) => a.startedAt.compareTo(b.startedAt));
    final exercises = <String>{};
    final weekendDays = <DateTime, Set<int>>{};
    var volume = 0.0;
    var mostReps = 0;
    var longest = 0;
    var early = false;
    var late = false;
    var comeback = false;
    DateTime? previous;
    for (final s in sorted) {
      volume += s.volumeKg;
      mostReps = math.max(mostReps, s.reps);
      longest = math.max(longest, s.duration.inMinutes);
      exercises.addAll(s.sets.map((x) => x.exerciseId));
      early |= s.startedAt.hour < 6;
      late |= s.startedAt.hour >= 22;
      if (previous != null &&
          s.startedAt.difference(previous).inDays >= comebackDays) {
        comeback = true;
      }
      previous = s.startedAt;
      if (s.startedAt.weekday >= DateTime.saturday) {
        (weekendDays[Schedule.weekStart(s.startedAt)] ??= {}).add(
          s.startedAt.weekday,
        );
      }
    }
    return AchievementStats(
      workouts: sorted.length,
      totalVolumeKg: volume,
      records: records,
      level: level,
      bestStreakWeeks: bestStreakWeeks,
      distinctExercises: exercises.length,
      mostRepsInWorkout: mostReps,
      longestMinutes: longest,
      earlyBird: early,
      nightOwl: late,
      comeback: comeback,
      fullWeekend: weekendDays.values.any((d) => d.length == 2),
    );
  }

  static const comebackDays = 14;

  final int workouts;
  final double totalVolumeKg;
  final int records;
  final int level;
  final int bestStreakWeeks;
  final int distinctExercises;
  final int mostRepsInWorkout;
  final int longestMinutes;
  final bool earlyBird;
  final bool nightOwl;
  final bool comeback;
  final bool fullWeekend;
}

enum AchievementGroup {
  workouts,
  streak,
  records,
  volume,
  level,
  variety,
  secret,
}

/// One badge. [goal] and [current] drive the progress bar; hidden ones
/// show as "???" until earned.
class Achievement {
  const new({
    required this.id,
    required this.group,
    required this.title,
    required this.description,
    required this.goal,
    required this.current,
    this.hidden = false,
  });

  final String id;
  final AchievementGroup group;
  final String title;
  final String description;
  final num goal;
  final num Function(AchievementStats) current;
  final bool hidden;

  bool earned(AchievementStats s) => current(s) >= goal;

  /// 0..1 towards the goal.
  double progress(AchievementStats s) =>
      (current(s) / goal).clamp(0, 1).toDouble();
}

/// The badge list. Milestones reward showing up over time, never doing
/// more in one day (CLAUDE.md rule 9). Copy is English only, like the app.
abstract final class Achievements {
  static num _workouts(AchievementStats s) => s.workouts;
  static num _streak(AchievementStats s) => s.bestStreakWeeks;
  static num _records(AchievementStats s) => s.records;
  static num _volume(AchievementStats s) => s.totalVolumeKg;
  static num _level(AchievementStats s) => s.level;
  static num _variety(AchievementStats s) => s.distinctExercises;
  static num _flag(bool value) => value ? 1 : 0;

  static final List<Achievement> all = List.unmodifiable([
    for (final (n, title) in const [
      (1, 'First step'),
      (5, 'Getting going'),
      (10, 'Double digits'),
      (25, 'Regular'),
      (50, 'Fifty strong'),
      (100, 'Centurion'),
      (250, 'Lifer'),
    ])
      Achievement(
        id: 'workouts_$n',
        group: AchievementGroup.workouts,
        title: title,
        description: n == 1
            ? 'Finish your first workout'
            : 'Finish $n workouts',
        goal: n,
        current: _workouts,
      ),
    for (final (n, title) in const [
      (2, 'Back again'),
      (4, 'One month in'),
      (8, 'Two months solid'),
      (12, 'Quarter of a year'),
      (26, 'Half a year'),
      (52, 'A full year'),
    ])
      Achievement(
        id: 'streak_$n',
        group: AchievementGroup.streak,
        title: title,
        description: 'Reach a $n-week streak',
        goal: n,
        current: _streak,
      ),
    for (final (n, title) in const [
      (1, 'New best'),
      (5, 'On the rise'),
      (15, 'Record collector'),
      (40, 'Unstoppable'),
    ])
      Achievement(
        id: 'records_$n',
        group: AchievementGroup.records,
        title: title,
        description: n == 1
            ? 'Set your first personal record'
            : 'Set $n personal records',
        goal: n,
        current: _records,
      ),
    for (final (kg, label, title) in const [
      (1000, '1,000', 'First tonne'),
      (10000, '10,000', 'Ten tonnes'),
      (50000, '50,000', 'Heavy hauler'),
      (100000, '100,000', 'Hundred tonnes'),
      (500000, '500,000', 'Mountain mover'),
    ])
      Achievement(
        id: 'volume_$kg',
        group: AchievementGroup.volume,
        title: title,
        description: 'Lift $label kg in total',
        goal: kg,
        current: _volume,
      ),
    for (final (n, title) in const [
      (5, 'Level 5'),
      (10, 'Level 10'),
      (20, 'Level 20'),
    ])
      Achievement(
        id: 'level_$n',
        group: AchievementGroup.level,
        title: title,
        description: 'Reach level $n',
        goal: n,
        current: _level,
      ),
    for (final (n, title) in const [(10, 'Explorer'), (25, 'Well rounded')])
      Achievement(
        id: 'variety_$n',
        group: AchievementGroup.variety,
        title: title,
        description: 'Train $n different exercises',
        goal: n,
        current: _variety,
      ),
    Achievement(
      id: 'early_bird',
      group: AchievementGroup.secret,
      title: 'Early bird',
      description: 'Start a workout before 6 am',
      goal: 1,
      current: (s) => _flag(s.earlyBird),
      hidden: true,
    ),
    Achievement(
      id: 'night_owl',
      group: AchievementGroup.secret,
      title: 'Night owl',
      description: 'Start a workout after 10 pm',
      goal: 1,
      current: (s) => _flag(s.nightOwl),
      hidden: true,
    ),
    Achievement(
      id: 'comeback',
      group: AchievementGroup.secret,
      title: 'Welcome back',
      description: 'Return after two weeks away',
      goal: 1,
      current: (s) => _flag(s.comeback),
      hidden: true,
    ),
    Achievement(
      id: 'full_weekend',
      group: AchievementGroup.secret,
      title: 'Weekend warrior',
      description: 'Train on Saturday and Sunday of the same week',
      goal: 1,
      current: (s) => _flag(s.fullWeekend),
      hidden: true,
    ),
    Achievement(
      id: 'rep_machine',
      group: AchievementGroup.secret,
      title: 'Rep machine',
      description: 'Log 200 reps in one workout',
      goal: 200,
      current: (s) => s.mostRepsInWorkout,
      hidden: true,
    ),
  ]);

  static List<Achievement> earned(AchievementStats s) => [
    for (final a in all)
      if (a.earned(s)) a,
  ];

  /// Badges earned in [after] that weren't in [before].
  static List<Achievement> newlyEarned(
    AchievementStats before,
    AchievementStats after,
  ) => [
    for (final a in all)
      if (a.earned(after) && !a.earned(before)) a,
  ];

  /// The closest not-yet-earned visible badge, to show as "next up".
  static Achievement? next(AchievementStats s) {
    Achievement? best;
    for (final a in all) {
      if (a.hidden || a.earned(s)) continue;
      if (best == null || a.progress(s) > best.progress(s)) best = a;
    }
    return best;
  }
}
