import 'package:drift/drift.dart';
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
  static const _theme = 'appearance.theme';

  /// "system", "light" or "dark". Dark until the user picks (design.md 5.1).
  static const defaultTheme = 'dark';
  static const themes = {'system', 'light', 'dark'};

  Stream<String> watchTheme() => _themeQuery.watchSingleOrNull().map(_theme_);

  Future<String> theme() async => _theme_(await _themeQuery.getSingleOrNull());

  Future<void> saveTheme(String theme) => _db
      .into(_db.settings)
      .insertOnConflictUpdate(
        SettingsCompanion.insert(key: _theme, value: theme),
      );

  static const _analyticsOn = 'analytics.enabled';
  static const _installId = 'analytics.installId';
  static const _reviewAskedAt = 'review.askedAt';

  /// Anonymous usage data: on unless the user turns it off.
  Stream<bool> watchAnalyticsEnabled() =>
      _one(_analyticsOn).watchSingleOrNull().map((r) => r?.value != 'false');

  Future<void> saveAnalyticsEnabled({required bool enabled}) =>
      _put(_analyticsOn, enabled.toString());

  /// Random id for this install; not linked to the account.
  Future<String> installId() async {
    final existing = await _one(_installId).getSingleOrNull();
    if (existing != null) return existing.value;
    final id = newId();
    await _put(_installId, id);
    return id;
  }

  Future<DateTime?> reviewAskedAt() async => DateTime.tryParse(
    (await _one(_reviewAskedAt).getSingleOrNull())?.value ?? '',
  );

  Future<void> saveReviewAskedAt(DateTime at) =>
      _put(_reviewAskedAt, at.toIso8601String());

  SimpleSelectStatement<$SettingsTable, Setting> _one(String key) =>
      _db.select(_db.settings)..where((s) => s.key.equals(key));

  Future<void> _put(String key, String value) => _db
      .into(_db.settings)
      .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));

  SimpleSelectStatement<$SettingsTable, Setting> get _themeQuery =>
      _db.select(_db.settings)..where((s) => s.key.equals(_theme));

  static String _theme_(Setting? row) =>
      themes.contains(row?.value) ? row!.value : defaultTheme;

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
