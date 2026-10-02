import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/plan/schedule.dart';
import 'package:ripped/features/plan/data/program_repository.dart';
import 'package:ripped/l10n/l10n.dart';

/// One clear next action (PRD principle 1).
class TodayScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final status = ref.watch(todayStatusProvider).value;
    final program = ref.watch(activeProgramProvider).value;
    final activeId = ref.watch(activeWorkoutIdProvider).value;
    final streak = ref.watch(streakProvider);
    final comeback = ref.watch(isComebackProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat.EEEE().format(DateTime.now()),
                    style: text.titleLarge,
                  ),
                ),
                StreakFlame(
                  weeks: streak.weeks,
                  label: l10n.streakWeeks(streak.weeks),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            if (status != null)
              WeeklyStrip(
                days: status.weekDays,
                label: l10n.weekProgress(
                  status.completedThisWeek,
                  status.weeklyTarget,
                ),
              ),
            const SizedBox(height: AppSpacing.xl),
            if (comeback && activeId == null) ...[
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.welcomeBackTitle, style: text.headlineSmall),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.welcomeBackMessage,
                      style: text.bodyLarge?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            AnimatedSwitcher(
              duration: AppMotion.base,
              child: switch ((status, program)) {
                (_, _) when activeId != null => _ResumeCard(
                  key: const ValueKey('resume'),
                  workoutId: activeId,
                ),
                (final TodayStatus s, final ProgramView p)
                    when p.days.isNotEmpty =>
                  _forStatus(s, p),
                _ => const SizedBox.shrink(),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _forStatus(TodayStatus s, ProgramView p) {
    final day = p.days[s.nextDayIndex.clamp(0, p.days.length - 1)];
    return switch (s.kind) {
      TodayKind.training => _WorkoutCard(key: ValueKey(day.id), day: day),
      TodayKind.rest => _RestCard(key: const ValueKey('rest'), next: day),
      TodayKind.done => _DoneCard(key: const ValueKey('done'), next: day),
    };
  }
}

Future<void> _start(
  BuildContext context,
  WidgetRef ref,
  ProgramDayView day,
) async {
  final id = await ref
      .read(workoutRepositoryProvider)
      .startWorkout(day, units: ref.read(unitsProvider));
  if (context.mounted) await context.push('/workout/$id');
}

class _WorkoutCard extends ConsumerWidget {
  const new({required this.day, super.key});

  final ProgramDayView day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final catalog = ref.watch(catalogProvider);
    final names = day.exercises
        .map((e) => catalog.byId(e.exerciseId).name)
        .take(4)
        .join(' · ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(day.name, style: text.displayLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${l10n.exerciseCount(day.exercises.length)} · '
                '${l10n.approxMinutes(day.estimatedMinutes)}',
                style: text.bodyLarge?.copyWith(color: c.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                names,
                style: text.bodyMedium?.copyWith(color: c.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: l10n.startWorkout,
                onPressed: () => _start(context, ref, day),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: AppButton(
            label: l10n.previewPlan,
            variant: AppButtonVariant.ghost,
            onPressed: () => context.push('/plan'),
          ),
        ),
      ],
    );
  }
}

class _RestCard extends ConsumerWidget {
  const new({required this.next, super.key});

  final ProgramDayView next;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return AppCard(
      child: EmptyState(
        icon: Icons.bedtime_outlined,
        title: l10n.restDayTitle,
        message: l10n.restDayMessage,
        actionLabel: l10n.trainAnyway,
        onAction: () => _start(context, ref, next),
      ),
    );
  }
}

class _DoneCard extends StatelessWidget {
  const new({required this.next, super.key});

  final ProgramDayView next;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppCard(
      child: EmptyState(
        icon: Icons.check_circle_outline,
        title: l10n.doneTodayTitle,
        message: l10n.doneTodayMessage(next.name),
      ),
    );
  }
}

class _ResumeCard extends ConsumerWidget {
  const new({required this.workoutId, super.key});

  final String workoutId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final workout = ref.watch(workoutProvider(workoutId)).value;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.workoutInProgress,
            style: text.bodyLarge?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(workout?.name ?? '', style: text.displayLarge),
          if (workout != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.setsProgress(workout.doneSets, workout.totalSets),
              style: text.bodyLarge,
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: l10n.resumeWorkout,
            onPressed: () => context.push('/workout/$workoutId'),
          ),
        ],
      ),
    );
  }
}
