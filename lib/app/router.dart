import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/app/shell.dart';
import 'package:ripped/features/exercise/presentation/exercise_detail_screen.dart';
import 'package:ripped/features/onboarding/presentation/onboarding_screen.dart';
import 'package:ripped/features/plan/presentation/plan_screen.dart';
import 'package:ripped/features/progress/presentation/progress_screen.dart';
import 'package:ripped/features/settings/presentation/legal_screen.dart';
import 'package:ripped/features/settings/presentation/you_screen.dart';
import 'package:ripped/features/today/presentation/today_screen.dart';
import 'package:ripped/features/workout/data/workout_models.dart';
import 'package:ripped/features/workout/presentation/active_workout_screen.dart';
import 'package:ripped/features/workout/presentation/workout_summary_screen.dart';

/// Onboarding state read from the database before the first frame.
final initialOnboardedProvider = Provider<bool>((ref) => false);

/// Whether onboarding is done. Seeded in bootstrap so the very first frame
/// is the right screen, then kept in sync with the profile row.
final onboardedProvider = Provider<ValueNotifier<bool>>((ref) {
  final notifier = ValueNotifier(ref.read(initialOnboardedProvider));
  ref
    ..listen(profileRowProvider, (_, next) {
      // Also flips back to onboarding when the profile is wiped.
      if (next.hasValue) {
        notifier.value = next.value?.onboardingDoneAt != null;
      }
    })
    ..onDispose(notifier.dispose);
  return notifier;
});

final routerProvider = Provider<GoRouter>((ref) {
  final onboarded = ref.watch(onboardedProvider);
  return GoRouter(
    initialLocation: onboarded.value ? '/' : '/onboarding',
    refreshListenable: onboarded,
    redirect: (context, state) {
      final atOnboarding = state.matchedLocation == '/onboarding';
      if (!onboarded.value && !atOnboarding) return '/onboarding';
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/', builder: (_, _) => const TodayScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progress',
                builder: (_, _) => const ProgressScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/you', builder: (_, _) => const YouScreen()),
            ],
          ),
        ],
      ),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(
        path: '/plan',
        builder: (_, state) => PlanScreen(
          fromOnboarding: state.uri.queryParameters['onboarding'] == '1',
        ),
      ),
      GoRoute(
        path: '/workout/:id',
        builder: (_, state) =>
            ActiveWorkoutScreen(workoutId: state.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'complete',
            builder: (_, state) => WorkoutSummaryScreen(
              workoutId: state.pathParameters['id']!,
              outcome: state.extra as WorkoutOutcome?,
              justFinished: true,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/history/:id',
        builder: (_, state) =>
            WorkoutSummaryScreen(workoutId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/legal/:doc',
        builder: (_, state) => LegalScreen(doc: state.pathParameters['doc']!),
      ),
      GoRoute(
        path: '/exercise/:id',
        builder: (_, state) =>
            ExerciseDetailScreen(exerciseId: state.pathParameters['id']!),
      ),
    ],
  );
});
