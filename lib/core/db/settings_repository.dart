import 'package:drift/drift.dart';
import 'package:ripped/core/db/app_database.dart';
import 'package:ripped/core/design/brand.dart';

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

/// What the user decided about the order of workouts.
class ScheduleChoices {
  const new({
    this.nextDayAtCount,
    this.nextDayIndex,
    this.missedHandled,
    this.bothOn,
  });

  final int? nextDayAtCount;
  final int? nextDayIndex;

  /// The missed day the user already dealt with.
  final DateTime? missedHandled;

  /// The day a second workout was asked for.
  final DateTime? bothOn;

  /// The chosen next program day, while no workout was finished since.
  int? overrideFor(int completedCount) =>
      nextDayAtCount == completedCount ? nextDayIndex : null;
}

/// What the user has decided about coaching suggestions.
class CoachSettings {
  const new({
    this.easyWeekUntil,
    this.lastEasyWeek,
    this.easyWeekDismissedAt,
    this.planRefreshDismissedAt,
  });

  /// End (exclusive) of the running easy week, if any.
  final DateTime? easyWeekUntil;
  final DateTime? lastEasyWeek;
  final DateTime? easyWeekDismissedAt;
  final DateTime? planRefreshDismissedAt;
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

  static const _logo = 'appearance.logo';

  /// The logo colourway shown in the app and on share cards. The home
  /// screen icon is always the primary one.
  Stream<BrandLogo> watchLogo() =>
      _one(_logo).watchSingleOrNull().map((r) => _logo_(r?.value));

  Future<void> saveLogo(BrandLogo logo) => _put(_logo, logo.name);

  static BrandLogo _logo_(String? name) =>
      BrandLogo.values.asNameMap()[name] ?? BrandLogo.volt;

  static const _easyUntil = 'coach.easyWeekUntil';
  static const _easyStarted = 'coach.easyWeekStartedAt';
  static const _easyDismissed = 'coach.easyWeekDismissedAt';
  static const _planDismissed = 'coach.planRefreshDismissedAt';

  Stream<CoachSettings> watchCoach() =>
      _db.select(_db.settings).watch().map((rows) {
        final map = {for (final r in rows) r.key: r.value};
        DateTime? date(String key) => DateTime.tryParse(map[key] ?? '');
        return CoachSettings(
          easyWeekUntil: date(_easyUntil),
          lastEasyWeek: date(_easyStarted),
          easyWeekDismissedAt: date(_easyDismissed),
          planRefreshDismissedAt: date(_planDismissed),
        );
      });

  Future<void> startEasyWeek({
    required DateTime now,
    required DateTime until,
  }) => _db.batch((b) {
    b.insertAllOnConflictUpdate(_db.settings, [
      SettingsCompanion.insert(key: _easyStarted, value: _iso(now)),
      SettingsCompanion.insert(key: _easyUntil, value: _iso(until)),
    ]);
  });

  /// Back to normal weights straight away.
  Future<void> endEasyWeek(DateTime now) => _put(_easyUntil, _iso(now));

  Future<void> dismissEasyWeek(DateTime now) => _put(_easyDismissed, _iso(now));

  Future<void> dismissPlanRefresh(DateTime now) =>
      _put(_planDismissed, _iso(now));

  static String _iso(DateTime d) => d.toIso8601String();

  static const _nextDay = 'schedule.nextDay';
  static const _missedHandled = 'schedule.missedHandled';
  static const _bothOn = 'schedule.bothOn';

  /// The user's choices about what to train next.
  Stream<ScheduleChoices> watchScheduleChoices() =>
      _db.select(_db.settings).watch().map(_choices);

  Future<ScheduleChoices> scheduleChoices() async =>
      _choices(await _db.select(_db.settings).get());

  static ScheduleChoices _choices(List<Setting> rows) {
    final map = {for (final r in rows) r.key: r.value};
    final next = (map[_nextDay] ?? '').split(':');
    return ScheduleChoices(
      nextDayAtCount: next.length == 2 ? int.tryParse(next[0]) : null,
      nextDayIndex: next.length == 2 ? int.tryParse(next[1]) : null,
      missedHandled: DateTime.tryParse(map[_missedHandled] ?? ''),
      bothOn: DateTime.tryParse(map[_bothOn] ?? ''),
    );
  }

  /// Do program day [dayIndex] next. Holds until the next workout is
  /// finished ([completedCount] is how many are done right now).
  Future<void> chooseNextDay({
    required int completedCount,
    required int dayIndex,
  }) => _put(_nextDay, '$completedCount:$dayIndex');

  /// The missed workout of [day] has been dealt with: stop mentioning it.
  Future<void> markMissedHandled(DateTime day) =>
      _put(_missedHandled, _iso(DateTime(day.year, day.month, day.day)));

  /// The user wants a second workout on [day].
  Future<void> allowSecondWorkout(DateTime day) =>
      _put(_bothOn, _iso(DateTime(day.year, day.month, day.day)));

  static const _hapticsOn = 'haptics.enabled';

  /// Vibration feedback: on unless the user turns it off.
  Stream<bool> watchHapticsEnabled() =>
      _one(_hapticsOn).watchSingleOrNull().map((r) => r?.value != 'false');

  Future<bool> hapticsEnabled() async =>
      (await _one(_hapticsOn).getSingleOrNull())?.value != 'false';

  Future<void> saveHapticsEnabled({required bool enabled}) =>
      _put(_hapticsOn, enabled.toString());

  static const _planStyle = 'plan.style';

  /// The training style chosen when the plan was last built (a
  /// `TrainingStyle` name); null means the coach's pick.
  Future<String?> planStyle() async =>
      (await _one(_planStyle).getSingleOrNull())?.value;

  Future<void> savePlanStyle(String style) => _put(_planStyle, style);

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
