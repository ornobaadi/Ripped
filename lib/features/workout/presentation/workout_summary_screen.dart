import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/components/confetti.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/core/haptics/haptics.dart';
import 'package:ripped/core/utils/format.dart';
import 'package:ripped/core/utils/labels.dart';
import 'package:ripped/domain/engagement/review_prompt.dart';
import 'package:ripped/domain/insights/achievements.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/domain/progression/progression_engine.dart';
import 'package:ripped/features/progress/presentation/achievement_tile.dart';
import 'package:ripped/features/workout/data/workout_models.dart';
import 'package:ripped/l10n/l10n.dart';

/// Post-workout summary (design.md 3.4), and the read-only view of a past
/// workout from history.
class WorkoutSummaryScreen extends ConsumerStatefulWidget {
  const new({
    required this.workoutId,
    this.outcome,
    this.justFinished = false,
    super.key,
  });

  final String workoutId;

  /// What finishing produced. Null when opened from history.
  final WorkoutOutcome? outcome;
  final bool justFinished;

  @override
  ConsumerState<WorkoutSummaryScreen> createState() =>
      _WorkoutSummaryScreenState();
}

class _WorkoutSummaryScreenState extends ConsumerState<WorkoutSummaryScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void initState() {
    super.initState();
    if (widget.justFinished) {
      final o = widget.outcome;
      final big = o != null && (o.records.isNotEmpty || o.leveledUp);
      // A long, strong buzz says "saved, you're done" without a glance;
      // records and level-ups get the celebration pattern instead.
      Haptics.play(big ? HapticCue.celebrate : HapticCue.workoutDone);
      _intro.forward();
    } else {
      _intro.value = 1;
    }
  }

  /// Badges this workout tipped over the line: today's stats against the
  /// same stats without this session.
  List<Achievement> _newBadges(WorkoutOutcome o) {
    final sessions = ref.watch(sessionsProvider).value;
    if (sessions == null) return const [];
    final after = ref.watch(achievementStatsProvider);
    final streakGrew = o.streakAfter > o.streakBefore;
    final before = AchievementStats.fromSessions(
      [
        for (final s in sessions)
          if (s.id != widget.workoutId) s,
      ],
      records: after.records - o.records.length,
      level: o.levelBefore.level,
      bestStreakWeeks: streakGrew && after.bestStreakWeeks == o.streakAfter
          ? o.streakBefore
          : after.bestStreakWeeks,
    );
    return Achievements.newlyEarned(before, after);
  }

  /// After a good session, back on Today: never mid-workout.
  Future<void> _maybeAskForReview() async {
    final o = widget.outcome;
    if (o == null) return;
    final settings = ref.read(settingsRepositoryProvider);
    final review = ref.read(reviewServiceProvider);
    final history = ref.read(historyProvider).value ?? const [];
    if (history.length < ReviewPrompt.minWorkouts) return;
    final now = DateTime.now();
    final ask = ReviewPrompt.shouldAsk(
      completedWorkouts: history.length,
      positiveMoment: o.records.isNotEmpty || o.leveledUp || o.weekCompleted,
      now: now,
      lastAskedAt: await settings.reviewAskedAt(),
    );
    if (!ask) return;
    await settings.saveReviewAskedAt(now);
    // Let the Today screen settle before the store sheet slides up.
    await Future<void>.delayed(const Duration(milliseconds: 900));
    await review.request();
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
    final start = (i * 0.12).clamp(0.0, 0.7);
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

  /// XP, level, records, streak: in that order (design.md 3.4).
  List<Widget> _celebration(WorkoutOutcome o, Units units) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final c = context.colors;
    final catalog = ref.read(catalogProvider);
    final after = o.levelAfter;
    return [
      if (o.xpEarned > 0) ...[
        const SizedBox(height: AppSpacing.md),
        _reveal(
          2,
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: LevelBadge(
                        level: after.level,
                        title: l10n.levelTitle(after.title),
                      ),
                    ),
                    Text(
                      l10n.xpEarned(o.xpEarned),
                      style: text.headlineSmall?.copyWith(color: c.accent),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                XpBar(
                  from: o.leveledUp ? 0 : o.levelBefore.progress,
                  value: after.progress,
                  label: l10n.xpProgress(after.xpIntoLevel, after.xpForNext),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  o.leveledUp
                      ? l10n.levelUp(after.level)
                      : l10n.xpProgress(after.xpIntoLevel, after.xpForNext),
                  style: text.bodyMedium?.copyWith(
                    color: o.leveledUp ? c.textPrimary : c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      for (final (i, pr) in o.records.indexed) ...[
        const SizedBox(height: AppSpacing.md),
        _reveal(3 + (i ~/ 2), () {
          final (headline, detail) = l10n.prText(
            pr.type,
            value: pr.value,
            previous: pr.previous,
            weightKg: pr.weightKg,
            reps: pr.reps,
            units: units,
          );
          return PrCard(
            exerciseName: catalog.byId(pr.exerciseId).name,
            headline: headline,
            detail: detail,
            badge: l10n.newBest,
          );
        }()),
      ],
      if (o.weekCompleted || o.comeback || o.volumeSpike)
        const SizedBox(height: AppSpacing.md),
      if (o.weekCompleted)
        _reveal(
          5,
          _Note(
            icon: Symbols.local_fire_department_rounded,
            text: l10n.weekTargetHit(o.streakAfter),
            color: c.warning,
          ),
        ),
      if (o.comeback)
        _reveal(
          5,
          _Note(
            icon: Symbols.waving_hand_rounded,
            text: l10n.comebackBonus,
            color: c.textSecondary,
          ),
        ),
      if (o.volumeSpike)
        _reveal(
          5,
          _Note(
            icon: Symbols.info_rounded,
            text: l10n.volumeSpikeNote,
            color: c.warning,
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final c = context.colors;
    final units = ref.watch(unitsProvider);
    final w = ref.watch(workoutProvider(widget.workoutId)).value;
    if (w == null) return const Scaffold(body: SizedBox.shrink());

    final outcome = widget.outcome;
    final results = outcome?.progression;
    final badges = outcome != null && widget.justFinished
        ? _newBadges(outcome)
        : const <Achievement>[];
    // Confetti for the moments worth it: a record, a level, a finished
    // week or a new badge.
    final celebrate =
        outcome != null &&
        (outcome.records.isNotEmpty ||
            outcome.leveledUp ||
            outcome.weekCompleted ||
            badges.isNotEmpty);
    final total = ref.watch(sessionsProvider).value?.length ?? 0;
    final week = ref.watch(weeklyRecapProvider).workouts;
    final target = ref.watch(profileProvider).daysPerWeek;
    // One personal line under the title, picked by what just happened.
    final praise = outcome == null
        ? null
        : outcome.records.isNotEmpty
        ? l10n.praiseRecords(outcome.records.length)
        : outcome.leveledUp
        ? l10n.praiseLevel(outcome.levelAfter.level)
        : outcome.weekCompleted
        ? l10n.praiseWeek(target)
        : outcome.comeback
        ? l10n.praiseComeback
        : total <= 1
        ? l10n.praiseFirst
        : week < target
        ? l10n.praiseProgress(total, target - week)
        : l10n.praiseCount(total);
    return PopScope(
      canPop: !widget.justFinished,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go('/');
      },
      child: Scaffold(
        appBar: widget.justFinished ? null : AppBar(),
        body: SafeArea(
          child: Stack(
            children: [
              GestureDetector(
                // Tap anywhere skips the intro animation.
                onTap: () => _intro.value = 1,
                behavior: HitTestBehavior.translucent,
                // A visual shortcut only; not a control for screen readers.
                excludeFromSemantics: true,
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
                            Icon(
                              Symbols.check_circle_rounded,
                              fill: 1,
                              color: c.success,
                              size: 48,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              l10n.workoutCompleteTitle,
                              style: text.titleLarge,
                            ),
                            if (praise != null) ...[
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                praise,
                                style: text.bodyLarge?.copyWith(
                                  color: c.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                            ],
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
                    if (outcome != null) ..._celebration(outcome, units),
                    if (badges.isNotEmpty) ...[
                      _reveal(5, SectionHeader(l10n.achievementUnlocked)),
                      _reveal(
                        5,
                        AppCard(
                          child: Column(
                            children: [
                              for (final badge in badges)
                                AchievementTile(
                                  achievement: badge,
                                  stats: ref.watch(achievementStatsProvider),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (results != null && results.isNotEmpty) ...[
                      _reveal(6, SectionHeader(l10n.nextTimeTitle)),
                      _reveal(
                        6,
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
              if (widget.justFinished && celebrate)
                const Positioned.fill(child: ConfettiBurst()),
            ],
          ),
        ),
        bottomNavigationBar: widget.justFinished
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: AppButton(
                    label: l10n.done,
                    onPressed: () {
                      unawaited(_maybeAskForReview());
                      context.go('/');
                    },
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

class _Note extends StatelessWidget {
  const new({required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    ),
  );
}
