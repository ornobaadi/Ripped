import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Local training-day reminders (PRD 7.9). No server, no push token.
abstract interface class ReminderScheduler {
  /// Asks for notification permission; true when allowed.
  Future<bool> requestPermission();

  /// Replaces all reminders with one weekly reminder per training day.
  Future<void> schedule({
    required List<int> weekdays,
    required int hour,
    required int minute,
    required String Function(int weekday) title,
    required String body,
  });

  Future<void> cancelAll();
}

class LocalReminderScheduler implements ReminderScheduler {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const _channel = AndroidNotificationDetails(
    'reminders',
    'Workout reminders',
    channelDescription: 'Reminders on your training days',
  );

  Future<void> _init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } on Object catch (e) {
      // Unknown zone name: fall back to UTC rather than failing.
      debugPrint('Timezone lookup failed: $e');
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    _ready = true;
  }

  @override
  Future<bool> requestPermission() async {
    await _init();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return true;
    return await android.requestNotificationsPermission() ?? false;
  }

  @override
  Future<void> schedule({
    required List<int> weekdays,
    required int hour,
    required int minute,
    required String Function(int weekday) title,
    required String body,
  }) async {
    await _init();
    await _plugin.cancelAll();
    for (final day in weekdays) {
      await _plugin.zonedSchedule(
        id: day,
        title: title(day),
        body: body,
        scheduledDate: nextInstance(
          tz.TZDateTime.now(tz.local),
          day,
          hour,
          minute,
        ),
        notificationDetails: const NotificationDetails(android: _channel),
        // Inexact is fine for a reminder and needs no exact-alarm permission.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  @override
  Future<void> cancelAll() async {
    await _init();
    await _plugin.cancelAll();
  }

  /// Next [weekday] at [hour]:[minute] strictly after [now].
  @visibleForTesting
  static tz.TZDateTime nextInstance(
    tz.TZDateTime now,
    int weekday,
    int hour,
    int minute,
  ) {
    var t = tz.TZDateTime(
      now.location,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    while (t.weekday != weekday || !t.isAfter(now)) {
      t = tz.TZDateTime(now.location, t.year, t.month, t.day + 1, hour, minute);
    }
    return t;
  }
}
