import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// One notification to show at a local time.
class PlannedNotification {
  const new({required this.at, required this.title, required this.body});

  final DateTime at;
  final String title;
  final String body;
}

/// Local notifications (PRD 7.9). No server, no push token: everything is
/// decided on the phone by `NotificationPlanner`.
abstract interface class ReminderScheduler {
  /// Asks for notification permission; true when allowed.
  Future<bool> requestPermission();

  /// Replaces everything scheduled with exactly [notifications].
  Future<void> replace(List<PlannedNotification> notifications);

  Future<void> cancelAll();
}

class LocalReminderScheduler implements ReminderScheduler {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const _channel = AndroidNotificationDetails(
    'reminders',
    'Workout reminders',
    channelDescription: 'Your training days and missed workouts',
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
  Future<void> replace(List<PlannedNotification> notifications) async {
    await _init();
    await _plugin.cancelAll();
    final now = tz.TZDateTime.now(tz.local);
    for (final (id, n) in notifications.indexed) {
      final when = tz.TZDateTime(
        tz.local,
        n.at.year,
        n.at.month,
        n.at.day,
        n.at.hour,
        n.at.minute,
      );
      if (!when.isAfter(now)) continue;
      await _plugin.zonedSchedule(
        id: id + 1,
        title: n.title,
        body: n.body,
        scheduledDate: when,
        notificationDetails: const NotificationDetails(android: _channel),
        // Inexact is fine for a reminder and needs no exact-alarm permission.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  @override
  Future<void> cancelAll() async {
    await _init();
    await _plugin.cancelAll();
  }
}
