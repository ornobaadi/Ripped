import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/domain/catalog/exercise.dart';
import 'package:ripped/domain/gamification/streak.dart';
import 'package:ripped/domain/insights/achievements.dart';
import 'package:ripped/domain/insights/muscle_balance.dart';
import 'package:ripped/domain/insights/recovery_advisor.dart';
import 'package:ripped/domain/insights/session_log.dart';
import 'package:ripped/domain/insights/weekly_recap.dart';
import 'package:ripped/domain/progression/progression_engine.dart';

SessionLog session(
  DateTime at, {
  int sets = 3,
  int reps = 10,
  double? kg = 50,
  String exercise = 'bench',
  Feeling? feeling,
  int minutes = 40,
}) => SessionLog(
  id: at.toIso8601String(),
  startedAt: at,
  duration: Duration(minutes: minutes),
  feeling: feeling,
  sets: [
    for (var i = 0; i < sets; i++)
      SetLog(exerciseId: exercise, reps: reps, weightKg: kg),
  ],
);

void main() {
  group('achievements', () {
    test('ids are unique and there are about thirty', () {
      final ids = Achievements.all.map((a) => a.id).toSet();
      expect(ids.length, Achievements.all.length);
      expect(Achievements.all.length, inInclusiveRange(28, 36));
      expect(Achievements.all.where((a) => a.hidden), isNotEmpty);
    });

    test('nothing is earned with no history', () {
      expect(Achievements.earned(const AchievementStats()), isEmpty);
      expect(Achievements.next(const AchievementStats()), isNotNull);
    });

    test('stats come from the log', () {
      final stats = AchievementStats.fromSessions(
        [
          session(DateTime(2026, 9, 5, 5, 30)), // Saturday, early
          session(DateTime(2026, 9, 6, 22, 15), exercise: 'squat'), // Sunday
          session(DateTime(2026, 9, 28, 18), sets: 10, reps: 20, kg: null),
        ],
        records: 2,
        level: 3,
        bestStreakWeeks: 4,
      );
      expect(stats.workouts, 3);
      expect(stats.totalVolumeKg, 3000);
      expect(stats.distinctExercises, 2);
      expect(stats.mostRepsInWorkout, 200);
      expect(stats.earlyBird, isTrue);
      expect(stats.nightOwl, isTrue);
      expect(stats.fullWeekend, isTrue);
      expect(stats.comeback, isTrue);

      final earned = Achievements.earned(stats).map((a) => a.id);
      expect(
        earned,
        containsAll([
          'workouts_1',
          'streak_4',
          'records_1',
          'volume_1000',
          'early_bird',
          'night_owl',
          'comeback',
          'full_weekend',
          'rep_machine',
        ]),
      );
      expect(earned, isNot(contains('workouts_5')));
    });

    test('newly earned compares before and after', () {
      const before = AchievementStats(workouts: 4);
      const after = AchievementStats(workouts: 5);
      expect(Achievements.newlyEarned(before, after).map((a) => a.id), [
        'workouts_5',
      ]);
      expect(Achievements.newlyEarned(after, after), isEmpty);
    });

    test('next is the closest visible badge, with progress', () {
      const stats = AchievementStats(workouts: 4);
      final next = Achievements.next(stats)!;
      expect(next.id, 'workouts_5');
      expect(next.progress(stats), closeTo(0.8, 0.001));
      expect(next.hidden, isFalse);
    });

    test('best streak survives a later miss', () {
      DateTime monday(int week) =>
          DateTime(2026, 6).add(Duration(days: 7 * week));
      final dates = [
        for (final w in [0, 1, 2, 3])
          for (var d = 0; d < 3; d++)
            monday(w).add(Duration(days: d, hours: 12)),
        // Weeks 4-7 missed, then one good week.
        for (var d = 0; d < 3; d++) monday(8).add(Duration(days: d, hours: 12)),
      ];
      final info = Streaks.compute(
        workoutDates: dates,
        weeklyTarget: 3,
        now: monday(8).add(const Duration(days: 4)),
      );
      expect(info.weeks, 1);
      expect(Streaks.best(info), greaterThanOrEqualTo(4));
    });
  });

  group('weekly recap', () {
    // Wednesday 2026-10-07.
    final now = DateTime(2026, 10, 7, 12);

    test('totals this week and compares with last week', () {
      final recap = WeeklyRecap.of([
        session(DateTime(2026, 9, 29, 18), kg: 40), // last week: 1200
        session(DateTime(2026, 10, 5, 18)), // 1500
        session(DateTime(2026, 10, 6, 18)), // 1500
        session(DateTime(2026, 10, 12, 18)), // next week: ignored
      ], now);
      expect(recap.workouts, 2);
      expect(recap.sets, 6);
      expect(recap.volumeKg, 3000);
      expect(recap.minutes, 80);
      expect(recap.previousWorkouts, 1);
      expect(recap.volumeChange, closeTo(1.5, 0.001));
    });

    test('empty week has no comparison', () {
      final recap = WeeklyRecap.of([session(DateTime(2026, 9, 29, 18))], now);
      expect(recap.isEmpty, isTrue);
      expect(recap.volumeChange, isNull);
    });
  });

  group('muscle balance', () {
    Exercise ex(String id, String muscle) => Exercise(
      id: id,
      name: id,
      pattern: MovementPattern.squat,
      equipment: Equipment.gym,
      equipmentLabel: 'barbell',
      level: Level.beginner,
      priority: 1,
      primaryMuscles: [muscle],
    );
    final catalog = {
      'bench': ex('bench', 'chest'),
      'row': ex('row', 'lats'),
      'squat': ex('squat', 'quadriceps'),
      'odd': ex('odd', 'unknown muscle'),
    };

    test('counts sets by primary muscle group', () {
      final sets = MuscleBalance.setsPerGroup([
        session(DateTime(2026, 10, 5), sets: 4),
        session(DateTime(2026, 10, 6), exercise: 'row', sets: 2),
        session(DateTime(2026, 10, 6), exercise: 'squat', sets: 5),
        session(DateTime(2026, 10, 6), exercise: 'odd'),
        session(DateTime(2026, 10, 6), exercise: 'gone'),
      ], (id) => catalog[id]);
      expect(sets[MuscleGroup.chest], 4);
      expect(sets[MuscleGroup.back], 2);
      expect(sets[MuscleGroup.legs], 5);
      expect(sets[MuscleGroup.arms], 0);
      expect(sets.keys, MuscleGroup.values);
      expect(MuscleBalance.top(sets), MuscleGroup.legs);
    });

    test('no top group without sets', () {
      expect(
        MuscleBalance.top(MuscleBalance.setsPerGroup([], (_) => null)),
        isNull,
      );
    });
  });

  group('recovery advisor', () {
    final now = DateTime(2026, 10, 7, 12);
    List<SessionLog> last3(Feeling f) => [
      for (final d in [1, 3, 5])
        session(now.subtract(Duration(days: d)), feeling: f),
    ];

    test('three tough sessions in a row suggest an easy week', () {
      expect(
        RecoveryAdvisor.suggestEasyWeek(
          sessions: last3(Feeling.tough),
          streakWeeks: 2,
          now: now,
        ),
        EasyWeekReason.fatigue,
      );
    });

    test('mixed feelings and a short streak suggest nothing', () {
      expect(
        RecoveryAdvisor.suggestEasyWeek(
          sessions: [
            ...last3(Feeling.tough).take(2),
            session(
              now.subtract(const Duration(days: 5)),
              feeling: Feeling.easy,
            ),
          ],
          streakWeeks: 2,
          now: now,
        ),
        isNull,
      );
    });

    test('old tough sessions do not count', () {
      expect(
        RecoveryAdvisor.suggestEasyWeek(
          sessions: [
            for (final d in [30, 32, 34])
              session(now.subtract(Duration(days: d)), feeling: Feeling.tough),
          ],
          streakWeeks: 0,
          now: now,
        ),
        isNull,
      );
    });

    test('six straight weeks suggest one, unless recent or snoozed', () {
      EasyWeekReason? ask({DateTime? last, DateTime? dismissed}) =>
          RecoveryAdvisor.suggestEasyWeek(
            sessions: last3(Feeling.justRight),
            streakWeeks: 6,
            now: now,
            lastEasyWeek: last,
            dismissedAt: dismissed,
          );
      expect(ask(), EasyWeekReason.longRun);
      expect(ask(last: now.subtract(const Duration(days: 10))), isNull);
      expect(ask(last: now.subtract(const Duration(days: 40))), isNotNull);
      expect(ask(dismissed: now.subtract(const Duration(days: 3))), isNull);
      expect(ask(dismissed: now.subtract(const Duration(days: 20))), isNotNull);
    });

    test('easy loads are lighter but stay loadable', () {
      expect(RecoveryAdvisor.easyWeight(100, 2.5), 90);
      expect(RecoveryAdvisor.easyWeight(42.5, 2.5), 37.5);
      expect(RecoveryAdvisor.easyWeight(null, 2.5), isNull);
      // Too light to reduce by a full step: keep it.
      expect(RecoveryAdvisor.easyWeight(2, 2.5), 2);
      expect(RecoveryAdvisor.easySets(4), 3);
      expect(RecoveryAdvisor.easySets(3), 2);
      expect(RecoveryAdvisor.easySets(2), 2);
    });

    test('plan refresh after eight weeks, with snooze', () {
      bool ask(int days, {DateTime? dismissed}) =>
          RecoveryAdvisor.suggestPlanRefresh(
            planStartedAt: now.subtract(Duration(days: days)),
            now: now,
            dismissedAt: dismissed,
          );
      expect(ask(55), isFalse);
      expect(ask(56), isTrue);
      expect(
        ask(90, dismissed: now.subtract(const Duration(days: 2))),
        isFalse,
      );
      expect(
        RecoveryAdvisor.suggestPlanRefresh(planStartedAt: null, now: now),
        isFalse,
      );
    });
  });
}
