import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/core/db/app_database.dart';
import 'package:ripped/core/db/settings_repository.dart';
import 'package:ripped/core/notifications/reminder_service.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

void main() {
  group('next reminder time', () {
    setUpAll(tzdata.initializeTimeZones);

    tz.TZDateTime at(String zone, int y, int m, int d, int h, [int min = 0]) =>
        tz.TZDateTime(tz.getLocation(zone), y, m, d, h, min);

    test('later today when the time has not passed', () {
      // Monday 2026-10-05 09:00 -> Monday 18:00.
      final next = LocalReminderScheduler.nextInstance(
        at('Europe/London', 2026, 10, 5, 9),
        DateTime.monday,
        18,
        0,
      );
      expect(next, at('Europe/London', 2026, 10, 5, 18));
    });

    test('next week once the time has passed today', () {
      final next = LocalReminderScheduler.nextInstance(
        at('Europe/London', 2026, 10, 5, 19),
        DateTime.monday,
        18,
        0,
      );
      expect(next, at('Europe/London', 2026, 10, 12, 18));
    });

    test('keeps local wall-clock time across a DST change', () {
      // UK clocks go back on 2026-10-25.
      final next = LocalReminderScheduler.nextInstance(
        at('Europe/London', 2026, 10, 23, 20),
        DateTime.monday,
        18,
        30,
      );
      expect(next.day, 26);
      expect(next.hour, 18);
      expect(next.minute, 30);
    });
  });

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
}
