import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripped/core/catalog/catalog_repository.dart';
import 'package:ripped/core/db/app_database.dart';
import 'package:ripped/core/db/profile_mapping.dart';
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
