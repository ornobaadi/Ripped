import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/domain/engagement/notification_plan.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/domain/plan/schedule.dart';

void main() {
  // Mon / Wed / Fri plan, reminders at 18:00, created well before.
  const days = {1, 3, 5};
  final since = DateTime(2026, 9);
  // 2026-10-05 is a Monday.
  DateTime day(int d, [int h = 9]) => DateTime(2026, 10, d, h);

  List<Notice> plan(
    DateTime now, {
    List<DateTime> done = const [],
    DateTime? handled,
  }) => NotificationPlanner.plan(
    now: now,
    trainingWeekdays: days,
    hour: 18,
    minute: 0,
    completedAt: done,
    planSince: since,
    missedHandled: handled,
  );

  group('missed day', () {
    DateTime? missed(DateTime now, {List<DateTime> done = const []}) =>
        Schedule.missedDay(
          now: now,
          trainingWeekdays: days,
          completedAt: done,
          planSince: since,
        );

    test('yesterday was a training day with no workout', () {
      expect(missed(day(6)), DateTime(2026, 10, 5));
    });

    test('not missed when it was done, even late', () {
      expect(missed(day(6), done: [day(5, 23)]), isNull);
    });

    test('caught up since: nothing to report', () {
      // Missed Monday, trained Tuesday; on Wednesday there is no miss.
      expect(missed(day(7), done: [day(6)]), isNull);
    });

    test('still mentioned two days later, not after the lookback', () {
      // Friday missed; Sunday still says so.
      expect(missed(day(11)), DateTime(2026, 10, 9));
      // Trained Friday; the following Tuesday has only Monday in range.
      expect(missed(day(13), done: [day(9)]), DateTime(2026, 10, 12));
    });

    test('days before the plan existed do not count', () {
      expect(
        Schedule.missedDay(
          now: day(6),
          trainingWeekdays: days,
          completedAt: const [],
          planSince: DateTime(2026, 10, 5, 20),
        ),
        isNull,
      );
    });
  });

  group('notification plan', () {
    test('reminds on training days only, within a week', () {
      final notices = plan(day(5)); // Monday morning
      final workouts = notices
          .where((n) => n.kind == NoticeKind.workout)
          .map((n) => n.at);
      expect(workouts, [day(5, 18), day(7, 18), day(9, 18)]);
      expect(notices.every((n) => n.at.isAfter(day(5))), isTrue);
      expect(notices.every((n) => n.at.isBefore(day(12, 23))), isTrue);
    });

    test('one catch-up, the day after the next training day', () {
      final catchUps = plan(day(5)).where((n) => n.kind == NoticeKind.catchUp);
      expect(catchUps.map((n) => n.at), [day(6, 18)]);
    });

    test('training today removes today and its catch-up', () {
      final notices = plan(day(5, 12), done: [day(5, 10)]);
      expect(notices.map((n) => n.at), isNot(contains(day(5, 18))));
      // The catch-up now guards Wednesday instead of Monday.
      expect(
        notices.where((n) => n.kind == NoticeKind.catchUp).map((n) => n.at),
        [day(8, 18)],
      );
    });

    test("no reminder once today's time has passed", () {
      final notices = plan(day(5, 19));
      expect(notices.map((n) => n.at), isNot(contains(day(5, 18))));
    });

    test("a miss on a rest day gets today's catch-up unless handled", () {
      // Tuesday morning, Monday missed.
      expect(plan(day(6)), contains(Notice(NoticeKind.catchUp, day(6, 18))));
      expect(
        plan(day(6), handled: DateTime(2026, 10, 5)),
        isNot(contains(Notice(NoticeKind.catchUp, day(6, 18)))),
      );
    });

    test('no catch-up when the next day is a training day itself', () {
      final notices = NotificationPlanner.plan(
        now: day(5),
        trainingWeekdays: const {1, 2, 4, 5},
        hour: 18,
        minute: 0,
        completedAt: const [],
        planSince: since,
      );
      expect(notices.where((n) => n.kind == NoticeKind.catchUp), isEmpty);
    });

    test('nothing without training days; never two at the same moment', () {
      expect(
        NotificationPlanner.plan(
          now: day(5),
          trainingWeekdays: const {},
          hour: 18,
          minute: 0,
          completedAt: const [],
        ),
        isEmpty,
      );
      final times = plan(day(6)).map((n) => n.at).toList();
      expect(times.toSet().length, times.length);
    });
  });

  group('choosing the next workout', () {
    TodayStatus status({int? override, int? last}) => Schedule.today(
      now: day(5),
      profile: const TrainingProfile(),
      programDayCount: 3,
      completedAt: const [],
      lastCompletedDayIndex: last,
      nextDayOverride: override,
    );

    test("rotation by default, the user's pick when set", () {
      expect(status(last: 0).nextDayIndex, 1);
      expect(status(last: 0, override: 2).nextDayIndex, 2);
      expect(status(override: 4).nextDayIndex, 1);
    });
  });
}
