import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/domain/gamification/streak.dart';
import 'package:ripped/domain/gamification/xp.dart';
import 'package:ripped/domain/plan/schedule.dart';

void main() {
  group('XP', () {
    test('awards sets, workout, PRs, streak and comeback', () {
      final awards = XpRules.forWorkout(
        loggedSets: 5,
        prs: 1,
        streakWeekCompleted: true,
        isComeback: false,
        alreadyEarnedToday: 0,
      );
      expect(awards, const [
        XpAward(XpSource.streakWeek, 100),
        XpAward(XpSource.workout, 50),
        XpAward(XpSource.pr, 25),
        XpAward(XpSource.set, 50),
      ]);
    });

    test('daily cap trims per-set XP first', () {
      final awards = XpRules.forWorkout(
        loggedSets: 40,
        prs: 0,
        streakWeekCompleted: false,
        isComeback: true,
        alreadyEarnedToday: 0,
      );
      final total = awards.fold(0, (s, a) => s + a.amount);
      expect(total, XpRules.dailyCap);
      expect(awards.first, const XpAward(XpSource.comeback, 100));
      expect(awards.last.source, XpSource.set);
    });

    test('a second workout on a capped day earns nothing', () {
      expect(
        XpRules.forWorkout(
          loggedSets: 10,
          prs: 2,
          streakWeekCompleted: false,
          isComeback: false,
          alreadyEarnedToday: 400,
        ),
        isEmpty,
      );
    });

    test('partial room is used, never exceeded', () {
      final awards = XpRules.forWorkout(
        loggedSets: 10,
        prs: 0,
        streakWeekCompleted: false,
        isComeback: false,
        alreadyEarnedToday: 380,
      );
      expect(awards, const [XpAward(XpSource.workout, 20)]);
    });
  });

  group('levels', () {
    test('curve: round(100 * n^1.5)', () {
      expect(Levels.xpForLevel(1), 100);
      expect(Levels.xpForLevel(2), 283);
      expect(Levels.xpForLevel(4), 800);
    });

    test('level and progress from total XP', () {
      expect(
        Levels.fromTotal(0),
        const LevelInfo(level: 1, totalXp: 0, xpIntoLevel: 0, xpForNext: 100),
      );
      expect(Levels.fromTotal(100).level, 2);
      final info = Levels.fromTotal(150);
      expect(info.level, 2);
      expect(info.xpIntoLevel, 50);
      expect(info.progress, closeTo(50 / 283, 1e-9));
      expect(Levels.fromTotal(-5).level, 1);
    });

    test('a regular early user levels up within ~2 weeks', () {
      // 3 workouts/week x ~15 sets = ~600 XP/week.
      final afterTwoWeeks = Levels.fromTotal(1200);
      expect(afterTwoWeeks.level, greaterThanOrEqualTo(4));
    });

    test('titles by level', () {
      expect(LevelTitle.forLevel(1), LevelTitle.beginner);
      expect(LevelTitle.forLevel(5), LevelTitle.regular);
      expect(LevelTitle.forLevel(12), LevelTitle.dedicated);
      expect(LevelTitle.forLevel(20), LevelTitle.athlete);
      expect(LevelTitle.forLevel(50), LevelTitle.legend);
      expect(Levels.fromTotal(0).title, LevelTitle.beginner);
    });
  });

  group('streak', () {
    // Monday 2026-09-07; weeks start on Mondays.
    DateTime week(int n, [int day = 0]) =>
        DateTime(2026, 9, 7 + n * 7 + day, 18);

    StreakInfo run(List<DateTime> dates, {int target = 3, DateTime? now}) =>
        Streaks.compute(
          workoutDates: dates,
          weeklyTarget: target,
          now: now ?? week(4, 2),
        );

    List<DateTime> hitWeek(int n) => [week(n), week(n, 2), week(n, 4)];

    test('no workouts: zero streak, current week only', () {
      final s = run(const []);
      expect(s.weeks, 0);
      expect(s.history.single.status, WeekStatus.current);
      expect(s.shieldAvailable, isTrue);
    });

    test('consecutive hit weeks count; current week is never a miss', () {
      final s = run([...hitWeek(1), ...hitWeek(2), ...hitWeek(3)]);
      expect(s.weeks, 3);
      expect(s.history.last.status, WeekStatus.current);
    });

    test('current week counts once its target is met', () {
      final s = run([...hitWeek(3), ...hitWeek(4)], now: week(4, 5));
      expect(s.weeks, 2);
      expect(s.currentWeekDone, 3);
    });

    test('one missed week per month is shielded automatically', () {
      // Weeks 0,1 hit; week 2 missed (September); week 3 hit.
      final s = run([...hitWeek(0), ...hitWeek(1), ...hitWeek(3)]);
      expect(s.history[2].status, WeekStatus.shielded);
      expect(s.weeks, 4);
    });

    test('a second miss in the same month breaks the streak', () {
      final s = run([...hitWeek(0), week(1), ...hitWeek(3)]);
      // Week 1 (Sep) shielded, week 2 (Sep) missed.
      expect(s.history[1].status, WeekStatus.shielded);
      expect(s.history[2].status, WeekStatus.missed);
      expect(s.weeks, 1);
    });

    test('a shield never starts a streak from nothing', () {
      final s = run([week(0), ...hitWeek(2)]);
      expect(s.history.first.status, WeekStatus.missed);
    });

    test('shield availability tracks the current month', () {
      final s = run([...hitWeek(0), ...hitWeek(2)], now: week(3, 1));
      expect(s.shieldAvailable, isFalse);
    });

    test('Sunday workouts belong to the week that started on Monday', () {
      final sunday = DateTime(2026, 9, 13, 23, 30);
      expect(Schedule.weekStart(sunday), DateTime(2026, 9, 7));
      final monday = DateTime(2026, 9, 14, 0, 5);
      expect(Schedule.weekStart(monday), DateTime(2026, 9, 14));
    });

    test('week math stays on midnight across DST and year boundaries', () {
      // Walk a full year day by day: every week start is a Monday at 00:00.
      for (var d = DateTime(2026); d.year == 2026; d = Schedule.addDays(d, 1)) {
        final start = Schedule.weekStart(d);
        expect(start.weekday, DateTime.monday, reason: '$d');
        expect(start.hour, 0, reason: '$d');
        expect(Schedule.addDays(start, 7).weekday, DateTime.monday);
      }
      expect(Schedule.weekStart(DateTime(2027)), DateTime(2026, 12, 28));
    });

    test('workouts dated in the future are ignored', () {
      final s = run([week(6)], now: week(4));
      expect(s.weeks, 0);
    });

    test('completesWeek fires exactly when the target is reached', () {
      expect(Streaks.completesWeek(doneBefore: 2, target: 3), isTrue);
      expect(Streaks.completesWeek(doneBefore: 3, target: 3), isFalse);
      expect(Streaks.completesWeek(doneBefore: 0, target: 3), isFalse);
    });

    test('comeback after two weeks away', () {
      final now = DateTime(2026, 10);
      expect(
        Streaks.isComeback(lastWorkout: DateTime(2026, 9, 10), now: now),
        isTrue,
      );
      expect(
        Streaks.isComeback(lastWorkout: DateTime(2026, 9, 25), now: now),
        isFalse,
      );
      expect(Streaks.isComeback(lastWorkout: null, now: now), isFalse);
    });

    test('value types', () {
      final a = StreakWeek(
        start: DateTime(2026),
        done: 1,
        status: WeekStatus.hit,
      );
      expect(
        a,
        StreakWeek(start: DateTime(2026), done: 1, status: WeekStatus.hit),
      );
      expect(a.hashCode, isNot(0));
      expect(a.toString(), contains('hit'));
      expect(const XpAward(XpSource.set, 10).toString(), contains('set'));
      expect(Levels.fromTotal(10).toString(), contains('Level 1'));
      expect(Levels.fromTotal(10).hashCode, Levels.fromTotal(10).hashCode);
      expect(const XpAward(XpSource.set, 1).hashCode, isNot(0));
    });
  });
}
