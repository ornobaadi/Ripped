import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/analytics/analytics.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/components/plan_animation.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/plan/plan.dart';
import 'package:ripped/domain/plan/plan_summary.dart';
import 'package:ripped/features/plan/data/program_repository.dart';
import 'package:ripped/features/plan/presentation/plan_edit.dart';
import 'package:ripped/features/plan/presentation/plan_labels.dart';
import 'package:ripped/features/plan/presentation/swap_sheet.dart';
import 'package:ripped/l10n/l10n.dart';

/// The week at a glance; each day expandable (design.md 3.1). Also the
/// "View plan" screen later on.
class PlanScreen extends ConsumerStatefulWidget {
  const new({this.fromOnboarding = false, super.key});

  final bool fromOnboarding;

  @override
  ConsumerState<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends ConsumerState<PlanScreen> {
  bool _editing = false;

  bool get fromOnboarding => widget.fromOnboarding;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final program = ref.watch(activeProgramProvider).value;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !fromOnboarding,
        title: Text(fromOnboarding ? '' : l10n.planTitle),
        actions: [
          // An icon, so the bar still fits at 200% text.
          IconButton(
            tooltip: _editing ? l10n.planEditDone : l10n.planEdit,
            onPressed: () => setState(() => _editing = !_editing),
            icon: Icon(_editing ? Symbols.check_rounded : Symbols.edit_rounded),
          ),
          if (fromOnboarding && !_editing)
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
                if (fromOnboarding) ...[
                  const Center(
                    child: PlanAnimation(
                      name: 'ready',
                      size: 96,
                      repeat: false,
                    ),
                  ),
                  Text(l10n.planReadyTitle, style: text.titleLarge),
                ],
                Text(
                  program.name,
                  style: text.bodyLarge?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _PlanHeader(
                  summary: PlanSummary.from(
                    ref.watch(profileProvider),
                    workouts: program.days.length,
                    totalExercises: program.days.fold(
                      0,
                      (n, d) => n + d.exercises.length,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                for (final (i, day) in program.days.indexed) ...[
                  _Entrance(
                    index: i,
                    enabled: fromOnboarding,
                    child: _DayCard(
                      // Rebuilt on toggle so every day opens for editing.
                      key: ValueKey('${day.id}$_editing'),
                      day: day,
                      initiallyExpanded: i == 0 || _editing,
                      editing: _editing,
                    ),
                  ),
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
                  onPressed: () {
                    ref
                        .read(analyticsProvider)
                        .track(AnalyticsEvent.planAccepted);
                    context.go('/');
                  },
                ),
              ),
            )
          : null,
    );
  }
}

/// "Built for you": the answers this plan came from, and the training week.
class _PlanHeader extends StatelessWidget {
  const new({required this.summary});

  final PlanSummary summary;

  static const _letters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final facts = [
      summary.goalLabel(l10n),
      summary.scheduleLabel(l10n),
      summary.equipmentLabel(l10n),
      ?summary.protectLabel(l10n),
    ];
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.builtForYou.toUpperCase(),
            style: text.labelLarge?.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final fact in facts)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      Symbols.check_rounded,
                      size: 18,
                      color: c.success,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(fact, style: text.bodyLarge)),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          Semantics(
            label: l10n.trainingDaysCount(summary.trainingWeekdays.length),
            excludeSemantics: true,
            child: Row(
              children: [
                for (var d = 1; d <= 7; d++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Container(
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: summary.trainingWeekdays.contains(d)
                              ? c.textPrimary
                              : c.surfaceRaised,
                          borderRadius: BorderRadius.circular(AppRadii.chip),
                        ),
                        child: Text(
                          _letters[d - 1],
                          textScaler: TextScaler.noScaling,
                          style: text.labelLarge?.copyWith(
                            color: summary.trainingWeekdays.contains(d)
                                ? c.bg
                                : c.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Cards slide up one after another the first time the plan is shown.
class _Entrance extends StatefulWidget {
  const new({required this.index, required this.enabled, required this.child});

  final int index;
  final bool enabled;
  final Widget child;

  @override
  State<_Entrance> createState() => _EntranceState();
}

class _EntranceState extends State<_Entrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _t = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 320 + 90 * widget.index.clamp(0, 6)),
    value: widget.enabled ? 0 : 1,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _t.value = 1;
    } else if (_t.value == 0 && !_t.isAnimating) {
      _t.forward();
    }
  }

  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Later cards wait their turn inside one controller: no stray timers.
    final total = _t.duration!.inMilliseconds;
    final curve = CurvedAnimation(
      parent: _t,
      curve: Interval((total - 320) / total, 1, curve: AppMotion.baseCurve),
    );
    return FadeTransition(
      opacity: curve,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(curve),
        child: widget.child,
      ),
    );
  }
}

class _DayCard extends ConsumerWidget {
  const new({
    required this.day,
    required this.initiallyExpanded,
    required this.editing,
    super.key,
  });

  final ProgramDayView day;
  final bool initiallyExpanded;
  final bool editing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          title: Row(
            children: [
              Flexible(
                child: Text(
                  day.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              if (editing)
                IconButton(
                  tooltip: l10n.planRenameDay,
                  icon: const Icon(Symbols.edit_rounded, size: 20),
                  onPressed: () async {
                    final name = await showRenameDayDialog(context, day.name);
                    if (name != null) {
                      await ref
                          .read(programRepositoryProvider)
                          .renameDay(day.id, name);
                    }
                  },
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l10n.exerciseCount(day.exercises.length)} · '
                '${l10n.approxMinutes(day.estimatedMinutes)}',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: c.textSecondary),
              ),
              _ThumbRow(day: day),
            ],
          ),
          children: [
            if (editing)
              EditableDay(day: day)
            else
              for (final e in day.exercises) _PlannedExerciseRow(entry: e),
          ],
        ),
      ),
    );
  }
}

/// Small row of what's in a day, shown under its title.
class _ThumbRow extends ConsumerWidget {
  const new({required this.day});

  final ProgramDayView day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(catalogProvider);
    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.sm),
        child: Row(
          children: [
            for (final e in day.exercises.take(6))
              if (catalog.maybe(e.exerciseId) case final exercise?)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: ExerciseThumb(exercise: exercise, size: 32),
                ),
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
