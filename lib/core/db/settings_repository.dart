import 'package:ripped/core/db/app_database.dart';

/// Typed device preferences on top of the key/value `settings` table.
class ReminderSettings {
  const new({this.enabled = false, this.hour = 18, this.minute = 0});

  final bool enabled;
  final int hour;
  final int minute;

  ReminderSettings copyWith({bool? enabled, int? hour, int? minute}) =>
      ReminderSettings(
        enabled: enabled ?? this.enabled,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
      );
}

class SettingsRepository {
  new(this._db);

  final AppDatabase _db;

  static const _remindersOn = 'reminders.enabled';
  static const _reminderTime = 'reminders.time';

  Stream<ReminderSettings> watchReminders() =>
      _db.select(_db.settings).watch().map(_parse);

  Future<ReminderSettings> reminders() async =>
      _parse(await _db.select(_db.settings).get());

  Future<void> saveReminders(ReminderSettings r) => _db.batch((b) {
    b.insertAllOnConflictUpdate(_db.settings, [
      SettingsCompanion.insert(key: _remindersOn, value: r.enabled.toString()),
      SettingsCompanion.insert(
        key: _reminderTime,
        value:
            '${r.hour.toString().padLeft(2, '0')}:'
            '${r.minute.toString().padLeft(2, '0')}',
      ),
    ]);
  });

  static ReminderSettings _parse(List<Setting> rows) {
    final map = {for (final r in rows) r.key: r.value};
    final time = (map[_reminderTime] ?? '18:00').split(':');
    return ReminderSettings(
      enabled: map[_remindersOn] == 'true',
      hour: int.tryParse(time.first) ?? 18,
      minute: int.tryParse(time.last) ?? 0,
    );
  }
}
