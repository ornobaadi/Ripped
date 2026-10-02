import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/core/utils/format.dart';
import 'package:ripped/domain/catalog/exercise.dart';
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
      unawaited(HapticFeedback.mediumImpact());
      Future<void>.delayed(
        const Duration(milliseconds: 180),
        HapticFeedback.mediumImpact,
      );
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
      if (mounted) context.go('/');
      return;
    }
    final result = await repo.finishWorkout(
      w.id,
      units: ref.read(unitsProvider),
      feeling: outcome.feeling,
      weeklyTarget: ref.read(profileProvider).daysPerWeek,
    );
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
            icon: Icons.info_outline,
            title: l10n.exerciseDetails,
            onTap: () => Navigator.pop(context, 'info'),
          ),
          if (e.sets.every((s) => !s.done))
            AppListTile(
              icon: Icons.swap_horiz,
              title: l10n.swapExercise,
              onTap: () => Navigator.pop(context, 'swap'),
            ),
          AppListTile(
            icon: Icons.add,
            title: l10n.addSet,
            onTap: () => Navigator.pop(context, 'addSet'),
          ),
          if (e.sets.any((s) => !s.done) && e.sets.length > 1)
            AppListTile(
              icon: Icons.remove,
              title: l10n.removeSet,
              onTap: () => Navigator.pop(context, 'removeSet'),
            ),
          if (index > 0)
            AppListTile(
              icon: Icons.arrow_upward,
              title: l10n.moveUp,
              onTap: () => Navigator.pop(context, 'up'),
            ),
          if (index < w.exercises.length - 1)
            AppListTile(
              icon: Icons.arrow_downward,
              title: l10n.moveDown,
              onTap: () => Navigator.pop(context, 'down'),
            ),
          AppListTile(
            icon: e.skipped ? Icons.undo : Icons.skip_next,
            title: e.skipped ? l10n.unskipExercise : l10n.skipExercise,
            onTap: () => Navigator.pop(context, 'skip'),
          ),
          AppListTile(
            icon: Icons.playlist_add,
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
    final nextIndex = w.exercises.indexWhere(
      (x) => !x.complete && w.exercises.indexOf(x) > _page,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          icon: const Icon(Icons.keyboard_arrow_down),
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
          preferredSize: const Size.fromHeight(3),
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: w.totalSets == 0 ? 0 : w.doneSets / w.totalSets),
            duration: AppMotion.base,
            curve: AppMotion.baseCurve,
            builder: (_, v, _) => LinearProgressIndicator(
              value: v,
              minHeight: 3,
              backgroundColor: c.border,
              color: c.success,
            ),
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pages,
        itemCount: w.exercises.length,
        onPageChanged: (i) => setState(() => _page = i),
        itemBuilder: (context, i) => _ExercisePage(
          key: ValueKey(w.exercises[i].id),
          workout: w,
          entry: w.exercises[i],
          index: i,
          onToggle: (s) => _toggleSet(w, w.exercises[i], s),
          onEdit: (s) => _editSet(w, w.exercises[i], s),
          onMenu: () => _menu(w, w.exercises[i], i),
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
          // Height animates between rest bar / up-next; content crossfades.
          child: AnimatedSize(
            duration: AppMotion.base,
            curve: AppMotion.baseCurve,
            alignment: Alignment.bottomCenter,
            child: AnimatedSwitcher(
              duration: AppMotion.base,
              switchInCurve: AppMotion.baseCurve,
              child: _resting
                  ? AnimatedBuilder(
                      key: const ValueKey('rest'),
                      animation: _rest,
                      builder: (context, _) {
                        final total = _rest.duration ?? Duration.zero;
                        final remaining = total * (1 - _rest.value);
                        return RestTimerBar(
                          remaining: Duration(
                            seconds: (remaining.inMilliseconds / 1000).ceil(),
                          ),
                          total: total,
                          label: l10n.rest,
                          skipLabel: l10n.skipRest,
                          addLabel: l10n.addTime,
                          onSkip: _skipRest,
                          onAdd: _addRest,
                        );
                      },
                    )
                  : nextIndex == -1
                  ? const SizedBox(
                      key: ValueKey('none'),
                      width: double.infinity,
                    )
                  : _UpNext(
                      key: ValueKey('next$nextIndex'),
                      exerciseId: w.exercises[nextIndex].exerciseId,
                      onTap: () => _goTo(nextIndex),
                    ),
            ),
          ),
        ),
      ),
    );
  }
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

class _UpNext extends ConsumerWidget {
  const new({required this.exerciseId, required this.onTap, super.key});

  final String exerciseId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercise = ref.watch(catalogProvider).byId(exerciseId);
    final c = context.colors;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          ExerciseThumb(exercise: exercise, size: 40),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.upNext,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: c.textSecondary),
                ),
                Text(
                  exercise.name,
                  style: Theme.of(context).textTheme.labelLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: c.textSecondary),
        ],
      ),
    );
  }
}

class _ExercisePage extends ConsumerWidget {
  const new({
    required this.workout,
    required this.entry,
    required this.index,
    required this.onToggle,
    required this.onEdit,
    required this.onMenu,
    super.key,
  });

  final WorkoutView workout;
  final WorkoutExerciseView entry;
  final int index;
  final ValueChanged<WorkoutSetView> onToggle;
  final ValueChanged<WorkoutSetView> onEdit;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final exercise = ref.watch(catalogProvider).byId(entry.exerciseId);
    final units = ref.watch(unitsProvider);

    String setLabel(WorkoutSetView s) => Fmt.set(
      kg: s.weightKg,
      reps: s.reps,
      timed: exercise.isTimed,
      units: units,
      l10n: l10n,
    );

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.exerciseOf(index + 1, workout.exercises.length),
                    style: text.bodySmall?.copyWith(color: c.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  GestureDetector(
                    onTap: () => context.push('/exercise/${exercise.id}'),
                    child: Text(exercise.name, style: text.titleLarge),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    exercise.isTimed
                        ? '${l10n.targetRange(entry.repMin, entry.repMax)} '
                              '${l10n.seconds}'
                        : '${l10n.targetRange(entry.repMin, entry.repMax)} '
                              '${l10n.reps}',
                    style: text.bodyMedium?.copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => context.push('/exercise/${exercise.id}'),
              child: ExerciseThumb(exercise: exercise, size: 64),
            ),
            IconButton(
              tooltip: MaterialLocalizations.of(context).showMenuTooltip,
              onPressed: onMenu,
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        if (entry.firstTime && exercise.isWeighted && !entry.skipped) ...[
          const SizedBox(height: AppSpacing.md),
          _Hint(icon: Icons.tune, text: l10n.findYourWeight(entry.repMax)),
        ] else if (entry.last != null) ...[
          const SizedBox(height: AppSpacing.md),
          _Hint(
            icon: Icons.history,
            text: l10n.lastTime(
              _lastSummary(entry.last!, exercise, units, l10n),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        if (entry.skipped)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Center(
              child: Text(
                l10n.skipped,
                style: text.headlineSmall?.copyWith(color: c.textSecondary),
              ),
            ),
          )
        else
          for (final s in entry.sets)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: SetRow(
                setNumber: s.index + 1,
                load: setLabel(s),
                done: s.done,
                onToggle: () => onToggle(s),
                onTap: () => onEdit(s),
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
