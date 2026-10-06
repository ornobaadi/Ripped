import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/analytics/analytics.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/core/haptics/haptics.dart';
import 'package:ripped/core/sync/sync_controller.dart';
import 'package:ripped/core/utils/format.dart';
import 'package:ripped/domain/catalog/exercise.dart';
import 'package:ripped/domain/engagement/encouragement.dart';
import 'package:ripped/domain/plan/plan_generator.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/domain/progression/progression_engine.dart';
import 'package:ripped/features/plan/presentation/swap_sheet.dart';
import 'package:ripped/features/workout/data/workout_models.dart';
import 'package:ripped/features/workout/presentation/add_exercise_sheet.dart';
import 'package:ripped/features/workout/presentation/finish_sheet.dart';
import 'package:ripped/l10n/l10n.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// The logger (design.md 3.3). Every tap writes to the database
/// immediately, so leaving or killing the app never loses a set.
class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const new({required this.workoutId, super.key});

  final String workoutId;

  @override
  ConsumerState<ActiveWorkoutScreen> createState() =>
      _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen>
    with SingleTickerProviderStateMixin {
  PageController? _pages;
  int _page = 0;
  late final AnimationController _rest = AnimationController(vsync: this)
    ..addStatusListener(_onRestStatus);

  @override
  void initState() {
    super.initState();
    _wakelock(on: true);
  }

  /// Keep the screen on while training. Never let a plugin hiccup break
  /// the workout.
  static void _wakelock({required bool on}) {
    unawaited(WakelockPlus.toggle(enable: on).catchError((Object _) {}));
  }

  @override
  void dispose() {
    _wakelock(on: false);
    _rest.dispose();
    _pages?.dispose();
    super.dispose();
  }

  void _onRestStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      // Strong double buzz: felt with the phone in a pocket or on a bench.
      Haptics.play(HapticCue.restOver);
      setState(() {});
    }
  }

  bool get _resting => _rest.isAnimating;

  void _startRest(int seconds) {
    if (seconds <= 0) return;
    _rest
      ..duration = Duration(seconds: seconds)
      ..forward(from: 0);
    setState(() {});
  }

  /// Extends the current rest by 15 s without a visual jump backwards.
  void _addRest() {
    final total = _rest.duration!;
    final elapsed = total * _rest.value;
    final extended = total + const Duration(seconds: 15);
    _rest
      ..duration = extended
      ..forward(from: elapsed.inMilliseconds / extended.inMilliseconds);
  }

  void _skipRest() {
    _rest.stop();
    setState(() {});
  }

  Future<void> _goTo(int page) async {
    final c = _pages;
    if (c == null || !c.hasClients) return;
    await c.animateToPage(
      page,
      duration: AppMotion.base,
      curve: AppMotion.baseCurve,
    );
  }

  Future<void> _toggleSet(
    WorkoutView w,
    WorkoutExerciseView e,
    WorkoutSetView s,
  ) async {
    final repo = ref.read(workoutRepositoryProvider);
    if (s.done) {
      await repo.undoSet(s.id);
      return;
    }
    await repo.logSet(s.id);
    _afterLog(w, e, s);
  }

  /// Starts rest, and moves on when the exercise is finished.
  void _afterLog(WorkoutView w, WorkoutExerciseView e, WorkoutSetView s) {
    final remainingHere = e.sets.where((x) => !x.done && x.id != s.id).length;
    final remainingAll = w.totalSets - w.doneSets - 1;
    if (remainingAll > 0) _startRest(e.restSeconds);
    if (remainingHere == 0) {
      final next = w.exercises.indexWhere((x) => x.id != e.id && !x.complete);
      if (next != -1) {
        Future<void>.delayed(const Duration(milliseconds: 350), () {
          if (mounted) unawaited(_goTo(next));
        });
      }
    }
  }

  Future<void> _editSet(
    WorkoutView w,
    WorkoutExerciseView e,
    WorkoutSetView s,
  ) async {
    final exercise = ref.read(catalogProvider).byId(e.exerciseId);
    final units = ref.read(unitsProvider);
    final result = await showAppSheet<_SetEdit>(
      context,
      builder: (_) => _EditSetSheet(exercise: exercise, set: s, units: units),
    );
    if (result == null) return;
    final log = result.log && !s.done;
    await ref
        .read(workoutRepositoryProvider)
        .editSet(s.id, reps: result.reps, weightKg: result.weightKg, log: log);
    if (log) _afterLog(w, e, s);
  }

  Future<void> _finish(WorkoutView w) async {
    final outcome = await showFinishSheet(
      context,
      unlogged: w.totalSets - w.doneSets,
    );
    if (outcome == null || !mounted) return;
    final repo = ref.read(workoutRepositoryProvider);
    if (outcome.discard) {
      await repo.abandonWorkout(w.id);
      ref.read(analyticsProvider).track(AnalyticsEvent.workoutAbandoned);
      if (mounted) context.go('/');
      return;
    }
    final result = await repo.finishWorkout(
      w.id,
      units: ref.read(unitsProvider),
      feeling: outcome.feeling,
      weeklyTarget: ref.read(profileProvider).daysPerWeek,
      easyWeek: ref.read(easyWeekActiveProvider),
    );
    // Today's reminder and its catch-up no longer apply.
    unawaited(refreshNotifications(ref.container));
    ref.read(analyticsProvider).track(AnalyticsEvent.workoutCompleted, {
      'sets': w.doneSets,
      'minutes': w.duration.inMinutes,
      'prs': result.records.length,
      'leveled_up': result.leveledUp,
      'week_completed': result.weekCompleted,
    });
    unawaited(ref.read(syncControllerProvider.notifier).requestSync());
    if (mounted) context.go('/workout/${w.id}/complete', extra: result);
  }

  Future<void> _menu(WorkoutView w, WorkoutExerciseView e, int index) async {
    final l10n = context.l10n;
    final repo = ref.read(workoutRepositoryProvider);
    final action = await showAppSheet<String>(
      context,
      builder: (context) => Column(
        children: [
          AppListTile(
            icon: Symbols.info_rounded,
            title: l10n.exerciseDetails,
            onTap: () => Navigator.pop(context, 'info'),
          ),
          if (e.sets.every((s) => !s.done))
            AppListTile(
              icon: Symbols.swap_horiz_rounded,
              title: l10n.swapExercise,
              onTap: () => Navigator.pop(context, 'swap'),
            ),
          AppListTile(
            icon: Symbols.add_rounded,
            title: l10n.addSet,
            onTap: () => Navigator.pop(context, 'addSet'),
          ),
          if (e.sets.any((s) => !s.done) && e.sets.length > 1)
            AppListTile(
              icon: Symbols.remove_rounded,
              title: l10n.removeSet,
              onTap: () => Navigator.pop(context, 'removeSet'),
            ),
          if (index > 0)
            AppListTile(
              icon: Symbols.arrow_upward_rounded,
              title: l10n.moveUp,
              onTap: () => Navigator.pop(context, 'up'),
            ),
          if (index < w.exercises.length - 1)
            AppListTile(
              icon: Symbols.arrow_downward_rounded,
              title: l10n.moveDown,
              onTap: () => Navigator.pop(context, 'down'),
            ),
          AppListTile(
            icon: e.skipped ? Symbols.undo_rounded : Symbols.skip_next_rounded,
            title: e.skipped ? l10n.unskipExercise : l10n.skipExercise,
            onTap: () => Navigator.pop(context, 'skip'),
          ),
          AppListTile(
            icon: Symbols.playlist_add_rounded,
            title: l10n.addExercise,
            onTap: () => Navigator.pop(context, 'addExercise'),
          ),
        ],
      ),
    );
    if (!mounted || action == null) return;
    switch (action) {
      case 'info':
        await context.push('/exercise/${e.exerciseId}');
      case 'swap':
        final picked = await showSwapSheet(context, ref, e.exerciseId);
        if (picked != null) {
          await repo.swapExercise(e.id, picked, units: ref.read(unitsProvider));
        }
      case 'addSet':
        await repo.addSet(e.id);
      case 'removeSet':
        await repo.removeSet(e.id);
      case 'up':
        await repo.moveExercise(w.id, index, index - 1);
        await _goTo(index - 1);
      case 'down':
        await repo.moveExercise(w.id, index, index + 1);
        await _goTo(index + 1);
      case 'skip':
        await repo.setSkipped(e.id, skipped: !e.skipped);
        if (!e.skipped && index < w.exercises.length - 1) {
          await _goTo(index + 1);
        }
      case 'addExercise':
        final id = await showAddExerciseSheet(context, ref);
        if (id == null) return;
        final exercise = ref.read(catalogProvider).byId(id);
        await repo.addExercise(
          w.id,
          id,
          PlanGenerator.prescribe(exercise, ref.read(profileProvider)),
          units: ref.read(unitsProvider),
        );
        await Future<void>.delayed(AppMotion.fast);
        await _goTo(w.exercises.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final async = ref.watch(workoutProvider(widget.workoutId));
    final w = async.value;
    if (w == null) {
      return const Scaffold(body: SizedBox.shrink());
    }
    _pages ??= PageController(initialPage: _page = w.currentExerciseIndex);

    final text = Theme.of(context).textTheme;
    final c = context.colors;
    if (_page >= w.exercises.length) _page = w.exercises.length - 1;
    final entry = w.exercises[_page];
    final pending = entry.skipped
        ? null
        : entry.sets.where((x) => !x.done).firstOrNull;
    // Prefer what comes after this exercise, then anything left before it.
    var nextIndex = w.exercises.indexWhere(
      (x) => !x.complete && w.exercises.indexOf(x) > _page,
    );
    if (nextIndex == -1) {
      nextIndex = w.exercises.indexWhere(
        (x) => !x.complete && x.id != entry.id,
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          icon: const Icon(Symbols.keyboard_arrow_down_rounded),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            _ElapsedClock(start: w.startedAt),
            const SizedBox(width: AppSpacing.md),
            Flexible(
              child: Text(
                l10n.setsProgress(w.doneSets, w.totalSets),
                style: text.bodyMedium?.copyWith(color: c.textSecondary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: TextButton(
              onPressed: () => _finish(w),
              style: TextButton.styleFrom(
                foregroundColor: c.textPrimary,
                textStyle: text.labelLarge,
              ),
              child: Text(l10n.finish),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(14),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: WorkoutProgressStrip(
              current: _page,
              label: l10n.workoutProgress(w.doneSets, w.totalSets),
              segments: [
                for (final e in w.exercises)
                  if (e.skipped) (0, 0) else (e.doneSets, e.sets.length),
              ],
            ),
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pages,
        itemCount: w.exercises.length,
        onPageChanged: (i) => setState(() => _page = i),
        itemBuilder: (context, i) => _FocusPage(
          key: ValueKey(w.exercises[i].id),
          workout: w,
          entry: w.exercises[i],
          index: i,
          rest: _resting && i == _page ? _rest : null,
          onEdit: (s) => _editSet(w, w.exercises[i], s),
          onMenu: () => _menu(w, w.exercises[i], i),
          onAllSets: () => _allSets(w.exercises[i].id),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: AnimatedSwitcher(
            duration: AppMotion.base,
            switchInCurve: AppMotion.baseCurve,
            child: _action(w, entry, pending, nextIndex),
          ),
        ),
      ),
    );
  }

  /// The one thing to do next, as a single large button.
  Widget _action(
    WorkoutView w,
    WorkoutExerciseView entry,
    WorkoutSetView? pending,
    int nextIndex,
  ) {
    final l10n = context.l10n;
    if (_resting) {
      return Row(
        key: const ValueKey('rest'),
        children: [
          Expanded(
            child: AppButton(label: l10n.skipRestLong, onPressed: _skipRest),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppButton(
            label: l10n.addTime,
            variant: AppButtonVariant.secondary,
            onPressed: _addRest,
          ),
        ],
      );
    }
    if (pending != null) {
      return AppButton(
        key: ValueKey('log${pending.id}'),
        label: l10n.setDone(pending.index + 1),
        onPressed: () {
          // The last set of an exercise feels different from the others.
          Haptics.play(
            entry.sets.where((x) => !x.done).length == 1
                ? HapticCue.exerciseDone
                : HapticCue.setDone,
          );
          unawaited(_toggleSet(w, entry, pending));
        },
      );
    }
    if (nextIndex != -1) {
      return AppButton(
        key: ValueKey('next$nextIndex'),
        label: l10n.nextExercise,
        variant: AppButtonVariant.secondary,
        onPressed: () => _goTo(nextIndex),
      );
    }
    return AppButton(
      key: const ValueKey('finish'),
      label: l10n.allDoneFinish,
      onPressed: () => _finish(w),
    );
  }

  /// Every set of one exercise, for edits, undo and adding or removing sets.
  Future<void> _allSets(String workoutExerciseId) => showAppSheet<void>(
    context,
    builder: (_) => _AllSetsSheet(
      workoutId: widget.workoutId,
      workoutExerciseId: workoutExerciseId,
      onToggle: _toggleSet,
      onEdit: _editSet,
    ),
  );
}

class _ElapsedClock extends StatefulWidget {
  const new({required this.start});

  final DateTime start;

  @override
  State<_ElapsedClock> createState() => _ElapsedClockState();
}

class _ElapsedClockState extends State<_ElapsedClock> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text(
    Fmt.clock(DateTime.now().difference(widget.start)),
    style: Theme.of(context).textTheme.headlineSmall,
  );
}

/// One exercise, one set at a time: the demo, the target as the hero, and
/// a line of encouragement. While resting, the hero becomes the countdown.
class _FocusPage extends ConsumerWidget {
  const new({
    required this.workout,
    required this.entry,
    required this.index,
    required this.rest,
    required this.onEdit,
    required this.onMenu,
    required this.onAllSets,
    super.key,
  });

  final WorkoutView workout;
  final WorkoutExerciseView entry;
  final int index;

  /// The running rest countdown, or null when not resting on this page.
  final AnimationController? rest;
  final ValueChanged<WorkoutSetView> onEdit;
  final VoidCallback onMenu;
  final VoidCallback onAllSets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final exercise = ref.watch(catalogProvider).byId(entry.exerciseId);
    final units = ref.watch(unitsProvider);
    final pending = entry.skipped
        ? null
        : entry.sets.where((s) => !s.done).firstOrNull;

    String load(WorkoutSetView s) => Fmt.set(
      kg: s.weightKg,
      reps: s.reps,
      timed: exercise.isTimed,
      units: units,
      l10n: l10n,
    );

    final resting = rest;
    final Widget hero;
    if (entry.skipped) {
      hero = _Status(icon: Symbols.skip_next_rounded, label: l10n.skipped);
    } else if (resting != null) {
      hero = _RestHero(
        rest: resting,
        next: pending == null
            ? null
            : l10n.restNext(
                l10n.setOf(pending.index + 1, entry.sets.length),
                load(pending),
              ),
      );
    } else if (pending == null) {
      hero = _Status(
        icon: Symbols.check_circle_rounded,
        label: l10n.exerciseDone,
        color: c.success,
      );
    } else {
      final cue = Encouragement.pick(
        setIndex: pending.index,
        setsInExercise: entry.sets.length,
        doneInWorkout: workout.doneSets,
        totalInWorkout: workout.totalSets,
      );
      hero = Column(
        children: [
          Text(
            l10n.setOf(pending.index + 1, entry.sets.length).toUpperCase(),
            style: text.labelLarge?.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Semantics(
            button: true,
            label: l10n.changeSet(pending.index + 1, load(pending)),
            excludeSemantics: true,
            child: InkWell(
              onTap: () => onEdit(pending),
              borderRadius: BorderRadius.circular(AppRadii.card),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: AppTapTargets.workout,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      load(pending),
                      maxLines: 1,
                      style: text.displayLarge,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(
            l10n.tapToChange,
            style: text.bodySmall?.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            switch (cue) {
              Cue.start => l10n.cueStart,
              Cue.newExercise => l10n.cueNewExercise,
              Cue.keepGoing => l10n.cueKeepGoing,
              Cue.halfway => l10n.cueHalfway,
              Cue.lastSet => l10n.cueLastSet,
              Cue.finalSet => l10n.cueFinalSet,
            },
            textAlign: TextAlign.center,
            style: text.bodyLarge,
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.focusExerciseOf(index + 1, workout.exercises.length),
                    style: text.bodySmall?.copyWith(color: c.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Semantics(
                    button: true,
                    hint: l10n.exerciseDetails,
                    child: GestureDetector(
                      onTap: () => context.push('/exercise/${exercise.id}'),
                      child: Text(exercise.name, style: text.titleLarge),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: MaterialLocalizations.of(context).showMenuTooltip,
              onPressed: onMenu,
              icon: const Icon(Symbols.more_vert_rounded),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ExerciseMotion(exercise: exercise),
        const SizedBox(height: AppSpacing.lg),
        AnimatedSwitcher(
          duration: AppMotion.base,
          switchInCurve: AppMotion.baseCurve,
          child: KeyedSubtree(
            key: ValueKey(
              entry.skipped
                  ? 'skipped'
                  : resting != null
                  ? 'rest'
                  : pending?.id ?? 'done',
            ),
            child: hero,
          ),
        ),
        if (!entry.skipped) ...[
          const SizedBox(height: AppSpacing.lg),
          // Sets of this exercise as dots: a small preview of what's left.
          ExcludeSemantics(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final s in entry.sets)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                    ),
                    child: AnimatedContainer(
                      duration: AppMotion.base,
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: s.done ? c.success : Colors.transparent,
                        border: Border.all(
                          color: s.done
                              ? c.success
                              : s.id == pending?.id
                              ? c.textPrimary
                              : c.border,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: TextButton(
              onPressed: onAllSets,
              style: TextButton.styleFrom(foregroundColor: c.textSecondary),
              child: Text(l10n.allSets),
            ),
          ),
        ],
        if (entry.firstTime && exercise.isWeighted && !entry.skipped)
          _Hint(
            icon: Symbols.tune_rounded,
            text: l10n.findYourWeight(entry.repMax),
          )
        else if (entry.last != null)
          _Hint(
            icon: Symbols.history_rounded,
            text: l10n.lastTime(
              _lastSummary(entry.last!, exercise, units, l10n),
            ),
          ),
      ],
    );
  }

  static String _lastSummary(
    LastPerformance last,
    Exercise e,
    Units units,
    AppLocalizations l10n,
  ) {
    final w = last.sets.first.weightKg;
    final reps = last.sets.map((s) => s.reps).join(', ');
    final unit = e.isTimed ? ' ${l10n.seconds}' : '';
    return w == null
        ? '$reps$unit'
        : '${Fmt.weight(w, units, l10n)} × $reps$unit';
  }
}

class _Status extends StatelessWidget {
  const new({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        children: [
          Icon(icon, fill: 1, size: 48, color: color ?? c.textSecondary),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color == null ? c.textSecondary : c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// The rest countdown as the main thing on screen.
class _RestHero extends StatelessWidget {
  const new({required this.rest, required this.next});

  final AnimationController rest;
  final String? next;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final l10n = context.l10n;
    return AnimatedBuilder(
      animation: rest,
      builder: (context, _) {
        final total = rest.duration ?? Duration.zero;
        final remaining = Duration(
          seconds: (total.inMilliseconds * (1 - rest.value) / 1000).ceil(),
        );
        return Semantics(
          label: '${l10n.rest} ${Fmt.clock(remaining)}',
          excludeSemantics: true,
          child: Column(
            children: [
              Text(
                l10n.rest.toUpperCase(),
                style: text.labelLarge?.copyWith(color: c.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xs),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(Fmt.clock(remaining), style: text.displayLarge),
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.chip),
                child: LinearProgressIndicator(
                  value: 1 - rest.value,
                  minHeight: 6,
                  backgroundColor: c.surfaceRaised,
                  color: c.textPrimary,
                ),
              ),
              if (next != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  next!,
                  textAlign: TextAlign.center,
                  style: text.bodyLarge?.copyWith(color: c.textSecondary),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Live list of one exercise's sets inside a sheet.
class _AllSetsSheet extends ConsumerWidget {
  const new({
    required this.workoutId,
    required this.workoutExerciseId,
    required this.onToggle,
    required this.onEdit,
  });

  final String workoutId;
  final String workoutExerciseId;
  final Future<void> Function(WorkoutView, WorkoutExerciseView, WorkoutSetView)
  onToggle;
  final Future<void> Function(WorkoutView, WorkoutExerciseView, WorkoutSetView)
  onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final w = ref.watch(workoutProvider(workoutId)).value;
    final entry = w?.exercises
        .where((e) => e.id == workoutExerciseId)
        .firstOrNull;
    if (w == null || entry == null) return const SizedBox.shrink();
    final exercise = ref.watch(catalogProvider).byId(entry.exerciseId);
    final units = ref.watch(unitsProvider);
    final repo = ref.read(workoutRepositoryProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(exercise.name, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        for (final s in entry.sets)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: SetRow(
              setNumber: s.index + 1,
              load: Fmt.set(
                kg: s.weightKg,
                reps: s.reps,
                timed: exercise.isTimed,
                units: units,
                l10n: l10n,
              ),
              done: s.done,
              onToggle: () => onToggle(w, entry, s),
              onTap: () => onEdit(w, entry, s),
            ),
          ),
        AppListTile(
          icon: Symbols.add_rounded,
          title: l10n.addSet,
          onTap: () => repo.addSet(entry.id),
        ),
        if (entry.sets.any((s) => !s.done) && entry.sets.length > 1)
          AppListTile(
            icon: Symbols.remove_rounded,
            title: l10n.removeSet,
            onTap: () => repo.removeSet(entry.id),
          ),
      ],
    );
  }
}

class _Hint extends StatelessWidget {
  const new({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: c.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: c.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _SetEdit {
  const new({required this.reps, required this.weightKg, required this.log});

  final int reps;
  final double? weightKg;
  final bool log;
}

class _EditSetSheet extends StatefulWidget {
  const new({required this.exercise, required this.set, required this.units});

  final Exercise exercise;
  final WorkoutSetView set;
  final Units units;

  @override
  State<_EditSetSheet> createState() => _EditSetSheetState();
}

class _EditSetSheetState extends State<_EditSetSheet> {
  late double? _weight = widget.set.weightKg == null
      ? null
      : Fmt.toDisplay(widget.set.weightKg!, widget.units);
  late double _reps = widget.set.reps.toDouble();

  double get _step => Fmt.toDisplay(
    LoadIncrements.forExercise(widget.exercise, widget.units),
    widget.units,
  );

  _SetEdit _result({required bool log}) => _SetEdit(
    reps: _reps.round(),
    weightKg: _weight == null ? null : Fmt.toKg(_weight!, widget.units),
    log: log,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final timed = widget.exercise.isTimed;
    final step = _step;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.editSet(widget.set.index + 1),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.xl),
        if (_weight != null) ...[
          ValueStepper(
            label: l10n.weight,
            value: _weight!,
            step: step,
            unit: Fmt.unit(widget.units, l10n),
            fractionDigits: step % 1 == 0 && _weight! % 1 == 0 ? 0 : 1,
            onChanged: (v) => setState(() => _weight = v),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
        ValueStepper(
          label: timed ? l10n.secondsLabel : l10n.repsLabel,
          value: _reps,
          step: timed ? 5 : 1,
          max: timed ? 3600 : 100,
          onChanged: (v) => setState(() => _reps = v),
        ),
        const SizedBox(height: AppSpacing.xxl),
        AppButton(
          label: widget.set.done ? l10n.save : l10n.logSet,
          onPressed: () => Navigator.pop(context, _result(log: true)),
        ),
        if (!widget.set.done) ...[
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: l10n.save,
            variant: AppButtonVariant.ghost,
            onPressed: () => Navigator.pop(context, _result(log: false)),
          ),
        ],
      ],
    );
  }
}
