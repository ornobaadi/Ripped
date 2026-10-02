import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripped/core/catalog/catalog_repository.dart';
import 'package:ripped/core/db/app_database.dart';
import 'package:ripped/core/db/profile_mapping.dart';
import 'package:ripped/core/db/settings_repository.dart';
import 'package:ripped/core/notifications/reminder_service.dart';
import 'package:ripped/domain/gamification/streak.dart';
import 'package:ripped/domain/gamification/xp.dart';
import 'package:ripped/domain/plan/plan_generator.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/domain/plan/schedule.dart';
import 'package:ripped/features/plan/data/program_repository.dart';
import 'package:ripped/features/workout/data/workout_models.dart';
import 'package:ripped/features/workout/data/workout_repository.dart';

// Infrastructure: created in bootstrap (or tests) and overridden.

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

// Reminders.

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);

/// Overridden in tests with a fake.
final reminderSchedulerProvider = Provider<ReminderScheduler>(
  (ref) => LocalReminderScheduler(),
);

final remindersProvider = StreamProvider<ReminderSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watchReminders(),
);

/// Saves [settings] and (re)schedules or cancels the OS reminders to match
/// the current training days. Returns false if permission was refused.
Future<bool> applyReminders(
  WidgetRef ref,
  ReminderSettings settings, {
  required String title,
  required String body,
}) async {
  final scheduler = ref.read(reminderSchedulerProvider);
  if (settings.enabled && !await scheduler.requestPermission()) return false;
  await ref.read(settingsRepositoryProvider).saveReminders(settings);
  if (!settings.enabled) {
    await scheduler.cancelAll();
    return true;
  }
  await scheduler.schedule(
    weekdays: ref.read(profileProvider).trainingDays,
    hour: settings.hour,
    minute: settings.minute,
    title: (_) => title,
    body: body,
  );
  return true;
}
