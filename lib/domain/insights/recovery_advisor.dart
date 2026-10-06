import 'package:ripped/domain/insights/session_log.dart';
import 'package:ripped/domain/progression/progression_engine.dart';

enum EasyWeekReason {
  /// Recent sessions have all felt tough.
  fatigue,

  /// Many weeks of training without a lighter one.
  longRun,
}

/// Decides when to offer a lighter ("easy") week and how light it is.
/// It only ever suggests: the user chooses (PRD: guidance, not orders).
abstract final class RecoveryAdvisor {
  static const toughSessions = 3;
  static const recentDays = 21;
  static const longRunWeeks = 6;
  static const daysBetweenEasyWeeks = 28;
  static const snoozeDays = 14;

  /// Weights during an easy week, as a share of the normal load.
  static const loadFactor = 0.9;

  static EasyWeekReason? suggestEasyWeek({
    required List<SessionLog> sessions,
    required int streakWeeks,
    required DateTime now,
    DateTime? lastEasyWeek,
    DateTime? dismissedAt,
  }) {
    if (_within(lastEasyWeek, now, daysBetweenEasyWeeks)) return null;
    if (_within(dismissedAt, now, snoozeDays)) return null;

    final recent = [
      for (final s in sessions)
        if (_within(s.startedAt, now, recentDays)) s,
    ]..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    final latest = recent.take(toughSessions).toList();
    if (latest.length == toughSessions &&
        latest.every((s) => s.feeling == Feeling.tough)) {
      return EasyWeekReason.fatigue;
    }
    if (streakWeeks >= longRunWeeks) return EasyWeekReason.longRun;
    return null;
  }

  /// One set fewer on bigger prescriptions; never below two.
  static int easySets(int sets) => sets >= 3 ? sets - 1 : sets;

  /// About 10% lighter, rounded down to a loadable step.
  static double? easyWeight(double? weightKg, double incrementKg) {
    if (weightKg == null) return null;
    final steps = (weightKg * loadFactor / incrementKg).floor();
    final eased = steps * incrementKg;
    return eased <= 0 ? weightKg : eased;
  }

  /// A plan older than this has usually stopped being a fresh stimulus.
  static const planRefreshDays = 56;

  static bool suggestPlanRefresh({
    required DateTime? planStartedAt,
    required DateTime now,
    DateTime? dismissedAt,
  }) {
    if (planStartedAt == null) return false;
    if (_within(dismissedAt, now, snoozeDays)) return false;
    return now.difference(planStartedAt).inDays >= planRefreshDays;
  }

  static bool _within(DateTime? then, DateTime now, int days) =>
      then != null && now.difference(then).inDays < days;
}
