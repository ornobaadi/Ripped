import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:ripped/app/config.dart';
import 'package:ripped/core/analytics/analytics.dart';
import 'package:ripped/core/analytics/posthog_analytics.dart';
import 'package:ripped/core/auth/auth_service.dart';
import 'package:ripped/core/catalog/catalog_repository.dart';
import 'package:ripped/core/db/app_database.dart';
import 'package:ripped/core/db/profile_mapping.dart';
import 'package:ripped/core/db/settings_repository.dart';
import 'package:ripped/core/notifications/reminder_service.dart';
import 'package:ripped/core/review/review_service.dart';
import 'package:ripped/core/sync/sync_service.dart';
import 'package:ripped/domain/engagement/notification_plan.dart';
import 'package:ripped/domain/gamification/streak.dart';
import 'package:ripped/domain/gamification/xp.dart';
import 'package:ripped/domain/insights/achievements.dart';
import 'package:ripped/domain/insights/muscle_balance.dart';
import 'package:ripped/domain/insights/recovery_advisor.dart';
import 'package:ripped/domain/insights/session_log.dart';
import 'package:ripped/domain/insights/weekly_recap.dart';
import 'package:ripped/domain/plan/plan_generator.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/domain/plan/schedule.dart';
import 'package:ripped/features/plan/data/program_repository.dart';
import 'package:ripped/features/workout/data/workout_models.dart';
import 'package:ripped/features/workout/data/workout_repository.dart';
import 'package:ripped/l10n/gen/app_localizations.dart';

// Infrastructure: created in bootstrap (or tests) and overridden.

/// Build-time config; empty (fully offline, no support email) by default.
final appConfigProvider = Provider<AppConfig>(
  (ref) => const AppConfig(
    flavor: AppFlavor.dev,
    supabaseUrl: '',
    supabasePublishableKey: '',
    sentryDsn: '',
    googleWebClientId: '',
    supportEmail: '',
    posthogKey: '',
    posthogHost: '',
  ),
);

final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('Overridden in bootstrap'),
);

final catalogProvider = Provider<CatalogRepository>(
  (ref) => throw UnimplementedError('Overridden in bootstrap'),
);

final planGeneratorProvider = Provider<PlanGenerator>(
  (ref) => PlanGenerator(ref.watch(catalogProvider).all),
);

final programRepositoryProvider = Provider<ProgramRepository>(
  (ref) => ProgramRepository(ref.watch(databaseProvider)),
);

final workoutRepositoryProvider = Provider<WorkoutRepository>(
  (ref) => WorkoutRepository(
    ref.watch(databaseProvider),
    ref.watch(catalogProvider),
  ),
);

/// Whether the user allows anonymous usage data (You > Data & privacy).
final analyticsEnabledProvider = StreamProvider<bool>(
  (ref) => ref.watch(settingsRepositoryProvider).watchAnalyticsEnabled(),
);

/// PostHog when a key is configured, otherwise debug prints only.
final analyticsProvider = Provider<Analytics>((ref) {
  final config = ref.watch(appConfigProvider);
  if (!config.hasAnalytics) return const DebugAnalytics();
  final settings = ref.watch(settingsRepositoryProvider);
  final client = http.Client();
  final analytics = PostHogAnalytics(
    apiKey: config.posthogKey,
    host: config.posthogHost,
    installId: settings.installId,
    client: client,
    appProps: {'flavor': config.flavor.name},
  );
  ref
    ..listen(analyticsEnabledProvider, (_, next) {
      analytics.enabled = next.value ?? true;
    }, fireImmediately: true)
    ..onDispose(client.close);
  return analytics;
});

/// Overridden in tests with a fake.
final reviewServiceProvider = Provider<ReviewService>(
  (ref) => const StoreReviewService(),
);

// Reactive state.

final profileRowProvider = StreamProvider<Profile?>(
  (ref) => ref.watch(programRepositoryProvider).watchProfileRow(),
);

/// The saved profile, or defaults before onboarding.
final profileProvider = Provider<TrainingProfile>(
  (ref) =>
      ref.watch(profileRowProvider).value?.toDomain() ??
      const TrainingProfile(),
);

final unitsProvider = Provider<Units>(
  (ref) => ref.watch(profileProvider).units,
);

final activeProgramProvider = StreamProvider<ProgramView?>(
  (ref) => ref.watch(programRepositoryProvider).watchActiveProgram(),
);

final completedWorkoutsProvider =
    StreamProvider<List<({DateTime startedAt, int? dayIndex})>>(
      (ref) => ref.watch(workoutRepositoryProvider).watchCompleted(),
    );

final activeWorkoutIdProvider = StreamProvider<String?>(
  (ref) => ref.watch(workoutRepositoryProvider).watchActiveWorkoutId(),
);

// Riverpod doesn't export the family type, so it can't be annotated.
// ignore: specify_nonobvious_property_types
final workoutProvider = StreamProvider.family<WorkoutView?, String>(
  (ref, id) => ref.watch(workoutRepositoryProvider).watchWorkout(id),
);

final historyProvider = StreamProvider<List<HistoryEntry>>(
  (ref) => ref.watch(workoutRepositoryProvider).watchHistory(),
);

/// Today's schedule state; recomputed whenever workouts or the plan change.
final todayStatusProvider = Provider<AsyncValue<TodayStatus>>((ref) {
  final program = ref.watch(activeProgramProvider);
  final completed = ref.watch(completedWorkoutsProvider);
  final profile = ref.watch(profileProvider);
  if (program.isLoading || completed.isLoading) {
    return const AsyncValue.loading();
  }
  final done = completed.value ?? const [];
  return AsyncValue.data(
    Schedule.today(
      now: DateTime.now(),
      profile: profile,
      programDayCount: program.value?.days.length ?? 0,
      completedAt: [for (final w in done) w.startedAt],
      lastCompletedDayIndex: done.isEmpty ? null : done.first.dayIndex,
      nextDayOverride: ref
          .watch(scheduleChoicesProvider)
          .value
          ?.overrideFor(done.length),
    ),
  );
});

// Gamification: all derived, never stored (CLAUDE.md rule 6).

final totalXpProvider = StreamProvider<int>(
  (ref) => ref.watch(workoutRepositoryProvider).watchTotalXp(),
);

final levelProvider = Provider<LevelInfo>(
  (ref) => Levels.fromTotal(ref.watch(totalXpProvider).value ?? 0),
);

final streakProvider = Provider<StreakInfo>((ref) {
  final done = ref.watch(completedWorkoutsProvider).value ?? const [];
  return Streaks.compute(
    workoutDates: [for (final w in done) w.startedAt],
    weeklyTarget: ref.watch(profileProvider).daysPerWeek,
    now: DateTime.now(),
  );
});

/// Two or more weeks since the last workout: greet, don't scold.
final isComebackProvider = Provider<bool>((ref) {
  final done = ref.watch(completedWorkoutsProvider).value ?? const [];
  return Streaks.isComeback(
    lastWorkout: done.isEmpty ? null : done.first.startedAt,
    now: DateTime.now(),
  );
});

final recordsProvider = StreamProvider<List<PersonalRecordRow>>(
  (ref) => ref.watch(workoutRepositoryProvider).watchRecords(),
);

// Insights (Phase 6): all derived from the workout log.

final sessionsProvider = StreamProvider<List<SessionLog>>(
  (ref) => ref.watch(workoutRepositoryProvider).watchSessions(),
);

final achievementStatsProvider = Provider<AchievementStats>(
  (ref) => AchievementStats.fromSessions(
    ref.watch(sessionsProvider).value ?? const [],
    records: ref.watch(recordsProvider).value?.length ?? 0,
    level: ref.watch(levelProvider).level,
    bestStreakWeeks: Streaks.best(ref.watch(streakProvider)),
  ),
);

final weeklyRecapProvider = Provider<WeeklyRecap>(
  (ref) => WeeklyRecap.of(
    ref.watch(sessionsProvider).value ?? const [],
    DateTime.now(),
  ),
);

/// Sets per muscle group in the current week.
final muscleBalanceProvider = Provider<Map<MuscleGroup, int>>(
  (ref) => MuscleBalance.setsPerGroup(
    ref.watch(weeklyRecapProvider).sessions,
    ref.watch(catalogProvider).maybe,
  ),
);

final coachSettingsProvider = StreamProvider<CoachSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watchCoach(),
);

/// Lighter weights are in effect right now.
final easyWeekActiveProvider = Provider<bool>((ref) {
  final until = ref.watch(coachSettingsProvider).value?.easyWeekUntil;
  return until != null && DateTime.now().isBefore(until);
});

final easyWeekSuggestionProvider = Provider<EasyWeekReason?>((ref) {
  if (ref.watch(easyWeekActiveProvider)) return null;
  final coach = ref.watch(coachSettingsProvider).value;
  if (coach == null) return null;
  return RecoveryAdvisor.suggestEasyWeek(
    sessions: ref.watch(sessionsProvider).value ?? const [],
    streakWeeks: ref.watch(streakProvider).weeks,
    now: DateTime.now(),
    lastEasyWeek: coach.lastEasyWeek,
    dismissedAt: coach.easyWeekDismissedAt,
  );
});

final planRefreshSuggestionProvider = Provider<bool>((ref) {
  final coach = ref.watch(coachSettingsProvider).value;
  if (coach == null) return false;
  return RecoveryAdvisor.suggestPlanRefresh(
    planStartedAt: ref.watch(activeProgramProvider).value?.startedAt,
    now: DateTime.now(),
    dismissedAt: coach.planRefreshDismissedAt,
  );
});

// Reminders.

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);

/// Overridden in tests with a fake.
final reminderSchedulerProvider = Provider<ReminderScheduler>(
  (ref) => LocalReminderScheduler(),
);

final hapticsEnabledProvider = StreamProvider<bool>(
  (ref) => ref.watch(settingsRepositoryProvider).watchHapticsEnabled(),
);

/// Theme read from the database before the first frame (no flash).
final initialThemeProvider = Provider<String>(
  (ref) => SettingsRepository.defaultTheme,
);

/// "system", "light" or "dark".
final themeProvider = StreamProvider<String>(
  (ref) => ref.watch(settingsRepositoryProvider).watchTheme(),
);

final remindersProvider = StreamProvider<ReminderSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watchReminders(),
);

/// Saves [settings] and rebuilds the notifications to match. Returns false
/// if permission was refused.
Future<bool> applyReminders(WidgetRef ref, ReminderSettings settings) async {
  final scheduler = ref.read(reminderSchedulerProvider);
  if (settings.enabled && !await scheduler.requestPermission()) return false;
  await ref.read(settingsRepositoryProvider).saveReminders(settings);
  await refreshNotifications(ref.container, clearWhenOff: true);
  return true;
}

/// Rebuilds every scheduled notification from the current state. Called
/// when the app opens, a workout is finished, the plan or reminder
/// settings change, or a missed workout is dealt with. Never throws.
Future<void> refreshNotifications(
  ProviderContainer container, {
  bool clearWhenOff = false,
}) async {
  final read = container.read;
  try {
    final settings = read(settingsRepositoryProvider);
    final scheduler = read(reminderSchedulerProvider);
    final reminders = await settings.reminders();
    if (!reminders.enabled) {
      // Don't wake the notification plugin for someone who never asked.
      if (clearWhenOff) await scheduler.cancelAll();
      return;
    }
    final programs = read(programRepositoryProvider);
    final profile = await programs.profile();
    final program = await programs.activeProgram();
    if (profile == null || program == null || program.days.isEmpty) {
      await scheduler.cancelAll();
      return;
    }
    final done = await read(workoutRepositoryProvider).watchCompleted().first;
    final choices = await settings.scheduleChoices();
    final now = DateTime.now();
    final completedAt = [for (final w in done) w.startedAt];
    final next = Schedule.today(
      now: now,
      profile: profile,
      programDayCount: program.days.length,
      completedAt: completedAt,
      lastCompletedDayIndex: done.isEmpty ? null : done.first.dayIndex,
      nextDayOverride: choices.overrideFor(done.length),
    ).nextDayIndex;
    final notices = NotificationPlanner.plan(
      now: now,
      trainingWeekdays: profile.trainingDays.toSet(),
      hour: reminders.hour,
      minute: reminders.minute,
      completedAt: completedAt,
      planSince: program.startedAt,
      missedHandled: choices.missedHandled,
    );
    final l10n = lookupAppLocalizations(const Locale('en'));
    final nextName = program.days[next].name;
    var named = false;
    await scheduler.replace([
      for (final n in notices)
        switch (n.kind) {
          NoticeKind.catchUp => PlannedNotification(
            at: n.at,
            title: l10n.notifyCatchUpTitle,
            body: l10n.notifyCatchUpBody(nextName),
          ),
          // Only the very next workout is known by name.
          NoticeKind.workout when !named => () {
            named = true;
            return PlannedNotification(
              at: n.at,
              title: l10n.notifyWorkoutTitle(nextName),
              body: l10n.reminderBody,
            );
          }(),
          NoticeKind.workout => PlannedNotification(
            at: n.at,
            title: l10n.reminderTitle,
            body: l10n.reminderBody,
          ),
        },
    ]);
  } on Object catch (e) {
    debugPrint('Notification refresh failed: $e');
  }
}

final scheduleChoicesProvider = StreamProvider<ScheduleChoices>(
  (ref) => ref.watch(settingsRepositoryProvider).watchScheduleChoices(),
);

/// A training day that went by without a workout and hasn't been dealt
/// with yet (see `Schedule.missedDay`).
final missedDayProvider = Provider<DateTime?>((ref) {
  final choices = ref.watch(scheduleChoicesProvider).value;
  final done = ref.watch(completedWorkoutsProvider).value;
  final program = ref.watch(activeProgramProvider).value;
  if (choices == null || done == null || program == null) return null;
  final missed = Schedule.missedDay(
    now: DateTime.now(),
    trainingWeekdays: ref.watch(profileProvider).trainingDays.toSet(),
    completedAt: [for (final w in done) w.startedAt],
    planSince: program.startedAt,
  );
  if (missed == null) return null;
  final handled = choices.missedHandled;
  return handled != null && Schedule.sameDay(handled, missed) ? null : missed;
});

// Accounts (optional).

/// Auth + sync transport, once Supabase has initialised. Bootstrap starts
/// it without awaiting, so a slow network never delays the first frame.
class Backend {
  const new({required this.auth, this.remote});

  static const offline = Backend(auth: OfflineAuthService());

  final AuthService auth;
  final SyncRemote? remote;
}

/// Overridden in bootstrap with the in-flight initialisation.
final backendProvider = FutureProvider<Backend>((ref) async => Backend.offline);

/// Signed-out until the backend is ready (or forever, when offline).
final authServiceProvider = Provider<AuthService>(
  (ref) => ref.watch(backendProvider).value?.auth ?? const OfflineAuthService(),
);

final currentUserProvider = StreamProvider<AppUser?>((ref) async* {
  final auth = ref.watch(authServiceProvider);
  yield auth.currentUser;
  yield* auth.userChanges;
});
