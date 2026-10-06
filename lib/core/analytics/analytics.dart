import 'package:flutter/foundation.dart';

/// The beta funnel (phases.md Phase 4). Behaviour only: never weights,
/// reps, body data, emails or names (CLAUDE.md rule 7).
enum AnalyticsEvent {
  appOpened,
  onboardingCompleted,
  planAccepted,
  workoutStarted,
  workoutCompleted,
  workoutAbandoned,
  signedIn,
  remindersEnabled,
  dataExported,
  accountDeleted,
}

/// Properties allowed on events. Anything else is dropped, so a careless
/// call can't leak health data.
const analyticsAllowedProps = {
  'days_per_week',
  'session_minutes',
  'goal',
  'experience',
  'sets',
  'minutes',
  'prs',
  'leveled_up',
  'week_completed',
};

abstract interface class Analytics {
  void track(AnalyticsEvent event, [Map<String, Object> props]);
}

/// Keeps only allow-listed keys with plain, non-identifying values.
Map<String, Object> sanitizeAnalyticsProps(Map<String, Object> props) => {
  for (final MapEntry(:key, :value) in props.entries)
    if (analyticsAllowedProps.contains(key) &&
        (value is num || value is bool || value is String && value.length < 32))
      key: value,
};

/// Default until a provider is chosen: prints in debug, nothing in release.
class DebugAnalytics implements Analytics {
  const new();

  @override
  void track(AnalyticsEvent event, [Map<String, Object> props = const {}]) {
    if (kDebugMode) {
      debugPrint('[analytics] ${event.name} ${sanitizeAnalyticsProps(props)}');
    }
  }
}
