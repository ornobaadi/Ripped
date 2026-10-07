import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/core/db/app_database.dart';
import 'package:ripped/core/db/settings_repository.dart';
import 'package:ripped/core/design/brand.dart';

void main() {
  group('reminder settings', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(DatabaseConnection(NativeDatabase.memory())));
    tearDown(() => db.close());

    test('default off at 18:00, then round-trips', () async {
      final repo = SettingsRepository(db);
      final initial = await repo.reminders();
      expect(initial.enabled, isFalse);
      expect(initial.hour, 18);

      await repo.saveReminders(
        const ReminderSettings(enabled: true, hour: 7, minute: 5),
      );
      final saved = await repo.reminders();
      expect(saved.enabled, isTrue);
      expect(saved.hour, 7);
      expect(saved.minute, 5);

      // Saving again updates in place.
      await repo.saveReminders(saved.copyWith(enabled: false));
      expect((await repo.reminders()).enabled, isFalse);
    });
  });

  group('theme setting', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(DatabaseConnection(NativeDatabase.memory())));
    tearDown(() => db.close());

    test('usage data on by default; install id is stable', () async {
      final repo = SettingsRepository(db);
      expect(await repo.watchAnalyticsEnabled().first, isTrue);
      await repo.saveAnalyticsEnabled(enabled: false);
      expect(await repo.watchAnalyticsEnabled().first, isFalse);

      final id = await repo.installId();
      expect(id, isNotEmpty);
      expect(await repo.installId(), id);

      expect(await repo.reviewAskedAt(), isNull);
      await repo.saveReviewAskedAt(DateTime(2026, 10, 6));
      expect(await repo.reviewAskedAt(), DateTime(2026, 10, 6));
    });

    test('the chosen training style is remembered', () async {
      final repo = SettingsRepository(db);
      expect(await repo.planStyle(), isNull);
      await repo.savePlanStyle('bodyPart');
      expect(await repo.planStyle(), 'bodyPart');
    });

    test('the logo is Volt until another one is picked', () async {
      final repo = SettingsRepository(db);
      expect(await repo.watchLogo().first, BrandLogo.volt);
      await repo.saveLogo(BrandLogo.chalk);
      expect(await repo.watchLogo().first, BrandLogo.chalk);
    });

    test('haptics on by default and can be turned off', () async {
      final repo = SettingsRepository(db);
      expect(await repo.hapticsEnabled(), isTrue);
      await repo.saveHapticsEnabled(enabled: false);
      expect(await repo.hapticsEnabled(), isFalse);
      expect(await repo.watchHapticsEnabled().first, isFalse);
    });

    test(
      'schedule choices: next workout pick, missed day, second workout',
      () async {
        final repo = SettingsRepository(db);
        var c = await repo.scheduleChoices();
        expect(c.overrideFor(0), isNull);
        expect(c.missedHandled, isNull);

        await repo.chooseNextDay(completedCount: 4, dayIndex: 2);
        await repo.markMissedHandled(DateTime(2026, 10, 5, 17, 30));
        await repo.allowSecondWorkout(DateTime(2026, 10, 6, 8));
        c = await repo.scheduleChoices();
        // The pick holds only until another workout is finished.
        expect(c.overrideFor(4), 2);
        expect(c.overrideFor(5), isNull);
        expect(c.missedHandled, DateTime(2026, 10, 5));
        expect(c.bothOn, DateTime(2026, 10, 6));
      },
    );

    test('coach choices are remembered', () async {
      final repo = SettingsRepository(db);
      final now = DateTime(2026, 10, 7, 9);
      expect((await repo.watchCoach().first).easyWeekUntil, isNull);

      await repo.startEasyWeek(now: now, until: DateTime(2026, 10, 12));
      var coach = await repo.watchCoach().first;
      expect(coach.easyWeekUntil, DateTime(2026, 10, 12));
      expect(coach.lastEasyWeek, now);

      await repo.endEasyWeek(now);
      await repo.dismissEasyWeek(now);
      await repo.dismissPlanRefresh(now);
      coach = await repo.watchCoach().first;
      expect(coach.easyWeekUntil, now);
      expect(coach.easyWeekDismissedAt, now);
      expect(coach.planRefreshDismissedAt, now);
    });

    test('dark by default, round-trips, ignores junk', () async {
      final repo = SettingsRepository(db);
      expect(await repo.theme(), 'dark');
      await repo.saveTheme('system');
      expect(await repo.theme(), 'system');
      await repo.saveTheme('purple');
      expect(await repo.theme(), 'dark');
    });
  });
}
