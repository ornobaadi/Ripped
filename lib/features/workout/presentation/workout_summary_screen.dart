import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/core/utils/format.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/domain/progression/progression_engine.dart';
import 'package:ripped/features/workout/data/workout_models.dart';
import 'package:ripped/l10n/l10n.dart';

/// Post-workout summary (design.md 3.4), and the read-only view of a past
/// workout from history.
class WorkoutSummaryScreen extends ConsumerStatefulWidget {
  const new({
    required this.workoutId,
    this.results,
    this.justFinished = false,
    super.key,
  });

  final String workoutId;

  /// Progression decisions from finishing. Null when opened from history.
  final List<ProgressionResult>? results;
  final bool justFinished;

  @override
  ConsumerState<WorkoutSummaryScreen> createState() =>
      _WorkoutSummaryScreenState();
}

class _WorkoutSummaryScreenState extends ConsumerState<WorkoutSummaryScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: AppMotion.celebrate,
  );

  @override
  void initState() {
    super.initState();
    if (widget.justFinished) {
      unawaited(HapticFeedback.heavyImpact());
      _intro.forward();
    } else {
      _intro.value = 1;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) _intro.value = 1;
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  /// Staggered fade + rise for section [i].
  Widget _reveal(int i, Widget child) {
    final start = (i * 0.15).clamp(0.0, 0.6);
    final anim = CurvedAnimation(
      parent: _intro,
      curve: Interval(
        start,
        (start + 0.4).clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(anim),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final c = context.colors;
    final units = ref.watch(unitsProvider);
    final w = ref.watch(workoutProvider(widget.workoutId)).value;
    if (w == null) return const Scaffold(body: SizedBox.shrink());

    final results = widget.results;
    return PopScope(
      canPop: !widget.justFinished,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go('/');
      },
      child: Scaffold(
        appBar: widget.justFinished ? null : AppBar(),
        body: SafeArea(
          child: GestureDetector(
            // Tap anywhere skips the intro animation.
            onTap: () => _intro.value = 1,
            behavior: HitTestBehavior.translucent,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                _reveal(
                  0,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.justFinished) ...[
                        const SizedBox(height: AppSpacing.xl),
                        Icon(Icons.check_circle, color: c.success, size: 48),
                        const SizedBox(height: AppSpacing.md),
                        Text(l10n.workoutCompleteTitle, style: text.titleLarge),
                      ] else
                        Text(
                          DateFormat.yMMMEd().format(w.startedAt),
                          style: text.bodyLarge?.copyWith(
                            color: c.textSecondary,
                          ),
                        ),
                      Text(w.name, style: text.displayLarge),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _reveal(
                  1,
                  AppCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: StatTile(
                            value: Fmt.clock(w.duration),
                            label: l10n.statDuration,
                          ),
                        ),
                        Expanded(
                          child: StatTile(
                            value: '${w.doneSets}',
                            label: l10n.statSets,
                          ),
                        ),
                        Expanded(
                          child: StatTile(
                            value: Fmt.volume(w.volumeKg, units, l10n),
                            label: l10n.statVolume,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (results != null && results.isNotEmpty) ...[
                  _reveal(2, SectionHeader(l10n.nextTimeTitle)),
                  _reveal(
                    2,
                    AppCard(
                      child: Column(
                        children: [
                          for (final r in results)
                            _ProgressRow(result: r, units: units),
                        ],
                      ),
                    ),
                  ),
                ],
                if (!widget.justFinished)
                  for (final e in w.exercises.where(
                    (e) => !e.skipped && e.doneSets > 0,
                  ))
                    _ExerciseLog(entry: e, units: units),
              ],
            ),
          ),
        ),
        bottomNavigationBar: widget.justFinished
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: AppButton(
                    label: l10n.done,
                    onPressed: () => context.go('/'),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class _ProgressRow extends ConsumerWidget {
  const new({required this.result, required this.units});

  final ProgressionResult result;
  final Units units;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final exercise = ref.watch(catalogProvider).byId(result.exerciseId);
    final next = result.next;
    final weight = Fmt.weight(next.weightKg, units, l10n);

    final (label, highlight) = switch (result.decision) {
      ProgressionDecision.increaseWeight => (
        l10n.progressIncreaseWeight(
          Fmt.weight(LoadIncrements.forExercise(exercise, units), units, l10n),
          weight,
        ),
        true,
      ),
      ProgressionDecision.increaseReps => (
        l10n.progressIncreaseReps(next.repTarget),
        true,
      ),
      ProgressionDecision.baseline => (l10n.progressBaseline, false),
      ProgressionDecision.hold => (l10n.progressHold, false),
      ProgressionDecision.deload => (l10n.progressDeload(weight), false),
      ProgressionDecision.suggestHarderVariation => (l10n.progressHarder, true),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(exercise.name, style: text.bodyLarge)),
          const SizedBox(width: AppSpacing.md),
          Text(
            label,
            style: text.labelLarge?.copyWith(
              color: highlight ? c.success : c.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseLog extends ConsumerWidget {
  const new({required this.entry, required this.units});

  final WorkoutExerciseView entry;
  final Units units;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final exercise = ref.watch(catalogProvider).byId(entry.exerciseId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(exercise.name),
        for (final s in entry.sets.where((s) => s.done))
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                SizedBox(
                  width: 64,
                  child: Text(
                    l10n.setLabel(s.index + 1),
                    style: text.bodyMedium?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ),
                Text(
                  Fmt.set(
                    kg: s.weightKg,
                    reps: s.reps,
                    timed: exercise.isTimed,
                    units: units,
                    l10n: l10n,
                  ),
                  style: text.bodyLarge,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
