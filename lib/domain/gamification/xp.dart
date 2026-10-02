import 'dart:math' as math;

import 'package:meta/meta.dart';

/// Why XP was earned. Stored in the append-only `xp_events` ledger.
enum XpSource { set, workout, pr, streakWeek, comeback }

@immutable
class XpAward {
  const new(this.source, this.amount);

  final XpSource source;
  final int amount;

  @override
  bool operator ==(Object other) =>
      other is XpAward && other.source == source && other.amount == amount;

  @override
  int get hashCode => Object.hash(source, amount);

  @override
  String toString() => 'XpAward(${source.name}, $amount)';
}

/// XP rules (architecture.md 6.4). More volume past a healthy point earns
/// nothing extra: the daily cap stops XP from rewarding overtraining.
abstract final class XpRules {
  static const perSet = 10;
  static const perWorkout = 50;
  static const perPr = 25;
  static const perStreakWeek = 100;
  static const comeback = 100;
  static const dailyCap = 400;

  /// Awards for one finished workout, trimmed so the day's total never
  /// exceeds [dailyCap]. Bonuses (streak, comeback, PRs) are applied before
  /// per-set XP so a capped day still celebrates what matters.
  static List<XpAward> forWorkout({
    required int loggedSets,
    required int prs,
    required bool streakWeekCompleted,
    required bool isComeback,
    required int alreadyEarnedToday,
  }) {
    final wanted = [
      if (streakWeekCompleted)
        const XpAward(XpSource.streakWeek, perStreakWeek),
      if (isComeback) const XpAward(XpSource.comeback, comeback),
      const XpAward(XpSource.workout, perWorkout),
      if (prs > 0) XpAward(XpSource.pr, prs * perPr),
      if (loggedSets > 0) XpAward(XpSource.set, loggedSets * perSet),
    ];
    var room = math.max(0, dailyCap - alreadyEarnedToday);
    final out = <XpAward>[];
    for (final a in wanted) {
      if (room == 0) break;
      final amount = math.min(a.amount, room);
      out.add(XpAward(a.source, amount));
      room -= amount;
    }
    return out;
  }
}

@immutable
class LevelInfo {
  const new({
    required this.level,
    required this.totalXp,
    required this.xpIntoLevel,
    required this.xpForNext,
  });

  final int level;
  final int totalXp;
  final int xpIntoLevel;

  /// XP needed to go from [level] to the next one.
  final int xpForNext;

  double get progress => xpForNext == 0 ? 0 : xpIntoLevel / xpForNext;

  LevelTitle get title => LevelTitle.forLevel(level);

  @override
  bool operator ==(Object other) =>
      other is LevelInfo &&
      other.level == level &&
      other.totalXp == totalXp &&
      other.xpIntoLevel == xpIntoLevel &&
      other.xpForNext == xpForNext;

  @override
  int get hashCode => Object.hash(level, totalXp, xpIntoLevel, xpForNext);

  @override
  String toString() => 'Level $level ($xpIntoLevel/$xpForNext)';
}

enum LevelTitle {
  beginner,
  regular,
  dedicated,
  athlete,
  legend;

  static LevelTitle forLevel(int level) => switch (level) {
    < 5 => beginner,
    < 10 => regular,
    < 20 => dedicated,
    < 35 => athlete,
    _ => legend,
  };
}

/// Level is derived from total XP, never stored (CLAUDE.md rule 6).
abstract final class Levels {
  /// XP to go from level [n] to n+1: round(100 * n^1.5).
  static int xpForLevel(int n) => (100 * math.pow(n, 1.5)).round();

  static LevelInfo fromTotal(int totalXp) {
    var level = 1;
    var remaining = math.max(0, totalXp);
    while (remaining >= xpForLevel(level)) {
      remaining -= xpForLevel(level);
      level++;
    }
    return LevelInfo(
      level: level,
      totalXp: math.max(0, totalXp),
      xpIntoLevel: remaining,
      xpForNext: xpForLevel(level),
    );
  }
}
