import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/analytics/analytics.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/plan/schedule.dart';
import 'package:ripped/features/plan/data/program_repository.dart';
import 'package:ripped/features/today/presentation/coach_cards.dart';
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
      // Scrolls behind the floating nav bar; the bottom inset clears it.
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg + MediaQuery.paddingOf(context).bottom,
          ),
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
            if (activeId == null &&
                status != null &&
                status.kind != TodayKind.done &&
                program != null &&
                program.days.isNotEmpty)
              if (ref.watch(missedDayProvider) case final missed?)
                _MissedCard(missed: missed, status: status, program: program),
            if (activeId == null) const CoachCards(),
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
      .startWorkout(
        day,
        units: ref.read(unitsProvider),
        easyWeek: ref.read(easyWeekActiveProvider),
      );
  ref.read(analyticsProvider).track(AnalyticsEvent.workoutStarted);
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
        Center(
          child: AppButton(
            label: l10n.pickWorkout,
            variant: AppButtonVariant.ghost,
            onPressed: () => _pickWorkout(context, ref),
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
        icon: Symbols.bedtime_rounded,
        title: l10n.restDayTitle,
        message: l10n.restDayMessage,
        actionLabel: l10n.trainAnyway,
        onAction: () => _start(context, ref, next),
      ),
    );
  }
}

class _DoneCard extends ConsumerWidget {
  const new({required this.next, super.key});

  final ProgramDayView next;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // Only when they asked to do two today (catching up a missed one).
    final both = ref.watch(scheduleChoicesProvider).value?.bothOn;
    final second = both != null && Schedule.sameDay(both, DateTime.now());
    return AppCard(
      child: EmptyState(
        icon: Symbols.check_circle_rounded,
        title: l10n.doneTodayTitle,
        message: l10n.doneTodayMessage(next.name),
        actionLabel: second ? l10n.secondWorkout(next.name) : null,
        onAction: second ? () => _start(context, ref, next) : null,
      ),
    );
  }
}

/// Lets the user train any day of the plan next, not just the one in turn.
Future<void> _pickWorkout(BuildContext context, WidgetRef ref) async {
  final program = ref.read(activeProgramProvider).value;
  if (program == null) return;
  final l10n = context.l10n;
  final index = await showAppSheet<int>(
    context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.pickWorkoutTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        for (final day in program.days)
          AppListTile(
            title: day.name,
            subtitle:
                '${l10n.exerciseCount(day.exercises.length)} · '
                '${l10n.approxMinutes(day.estimatedMinutes)}',
            onTap: () => Navigator.pop(context, day.index),
          ),
      ],
    ),
  );
  if (index == null) return;
  await ref
      .read(settingsRepositoryProvider)
      .chooseNextDay(
        completedCount: ref.read(completedWorkoutsProvider).value?.length ?? 0,
        dayIndex: index,
      );
}

/// A training day went by without a workout. No blame: say what's
/// waiting and let the user decide what happens to it.
class _MissedCard extends ConsumerWidget {
  const new({
    required this.missed,
    required this.status,
    required this.program,
  });

  final DateTime missed;
  final TodayStatus status;
  final ProgramView program;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final settings = ref.read(settingsRepositoryProvider);
    final count = program.days.length;
    final waiting = program.days[status.nextDayIndex % count];
    final after = program.days[(status.nextDayIndex + 1) % count];
    final training = status.kind == TodayKind.training;

    Future<void> handled() async {
      await settings.markMissedHandled(missed);
      await refreshNotifications(ref.container);
    }

    Future<void> doIt({bool both = false}) async {
      if (both) await settings.allowSecondWorkout(DateTime.now());
      await handled();
      if (context.mounted) await _start(context, ref, waiting);
    }

    Future<void> skip() async {
      final messenger = ScaffoldMessenger.of(context);
      await settings.chooseNextDay(
        completedCount: ref.read(completedWorkoutsProvider).value?.length ?? 0,
        dayIndex: after.index,
      );
      await handled();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.missedSkipped(after.name))),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Symbols.event_repeat_rounded, color: c.textSecondary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    l10n.missedTitle(DateFormat.EEEE().format(missed)),
                    style: text.headlineSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              training
                  ? l10n.missedTraining(waiting.name, after.name)
                  : l10n.missedRest(waiting.name),
              style: text.bodyLarge?.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                FilledButton.tonal(
                  onPressed: doIt,
                  child: Text(l10n.missedDoIt(waiting.name)),
                ),
                if (training && count > 1)
                  OutlinedButton(
                    onPressed: () => doIt(both: true),
                    child: Text(l10n.missedDoBoth),
                  ),
                if (count > 1)
                  OutlinedButton(
                    onPressed: skip,
                    child: Text(l10n.missedSkip(waiting.name)),
                  ),
                if (!training)
                  TextButton(onPressed: handled, child: Text(l10n.missedKeep)),
              ],
            ),
          ],
        ),
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
