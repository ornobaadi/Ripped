import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/plan/plan.dart';
import 'package:ripped/features/plan/data/program_repository.dart';
import 'package:ripped/features/plan/presentation/swap_sheet.dart';
import 'package:ripped/l10n/l10n.dart';

/// The week at a glance; each day expandable (design.md 3.1). Also the
/// "View plan" screen later on.
class PlanScreen extends ConsumerWidget {
  const new({this.fromOnboarding = false, super.key});

  final bool fromOnboarding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final program = ref.watch(activeProgramProvider).value;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !fromOnboarding,
        title: Text(fromOnboarding ? '' : l10n.planTitle),
        actions: [
          if (fromOnboarding)
            TextButton(
              onPressed: () => context.go('/onboarding'),
              child: Text(l10n.regenerate),
            ),
        ],
      ),
      body: program == null
          ? const SizedBox.shrink()
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.xxxl * 2,
              ),
              children: [
                if (fromOnboarding)
                  Text(l10n.planReadyTitle, style: text.titleLarge),
                Text(
                  program.name,
                  style: text.bodyLarge?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                for (final (i, day) in program.days.indexed) ...[
                  _DayCard(day: day, initiallyExpanded: i == 0),
                  const SizedBox(height: AppSpacing.md),
                ],
              ],
            ),
      bottomNavigationBar: fromOnboarding
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: AppButton(
                  label: l10n.looksGood,
                  onPressed: () => context.go('/'),
                ),
              ),
            )
          : null,
    );
  }
}

class _DayCard extends StatelessWidget {
  const new({required this.day, required this.initiallyExpanded});

  final ProgramDayView day;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.sm,
            AppSpacing.md,
          ),
          iconColor: c.textSecondary,
          collapsedIconColor: c.textSecondary,
          title: Text(
            day.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          subtitle: Text(
            '${l10n.exerciseCount(day.exercises.length)} · '
            '${l10n.approxMinutes(day.estimatedMinutes)}',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: c.textSecondary),
          ),
          children: [
            for (final e in day.exercises) _PlannedExerciseRow(entry: e),
          ],
        ),
      ),
    );
  }
}

class _PlannedExerciseRow extends ConsumerWidget {
  const new({required this.entry});

  final ProgramExerciseView entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final exercise = ref.watch(catalogProvider).byId(entry.exerciseId);
    final p = entry.prescription;

    return InkWell(
      onTap: () => context.push('/exercise/${exercise.id}'),
      borderRadius: BorderRadius.circular(AppRadii.chip),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            ExerciseThumb(exercise: exercise, size: 48),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exercise.name, style: text.bodyLarge),
                  Text(
                    _prescriptionLabel(context, p, timed: exercise.isTimed),
                    style: text.labelLarge?.copyWith(color: c.textSecondary),
                  ),
                  Text(
                    entry.reason,
                    style: text.bodySmall?.copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                final picked = await showSwapSheet(context, ref, exercise.id);
                if (picked == null) return;
                unawaited(
                  ref
                      .read(programRepositoryProvider)
                      .swapExercise(entry.id, picked),
                );
              },
              style: TextButton.styleFrom(foregroundColor: c.textSecondary),
              child: Text(l10n.swap),
            ),
          ],
        ),
      ),
    );
  }
}

String _prescriptionLabel(
  BuildContext context,
  Prescription p, {
  required bool timed,
}) => timed
    ? context.l10n.setsSeconds(p.sets, p.repMin, p.repMax)
    : context.l10n.setsReps(p.sets, p.repMin, p.repMax);
