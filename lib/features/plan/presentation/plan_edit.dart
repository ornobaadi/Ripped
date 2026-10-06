import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/plan/plan.dart';
import 'package:ripped/domain/plan/plan_generator.dart';
import 'package:ripped/domain/plan/training_style.dart';
import 'package:ripped/features/plan/data/program_repository.dart';
import 'package:ripped/features/workout/presentation/add_exercise_sheet.dart';
import 'package:ripped/l10n/l10n.dart';

/// One day in edit mode: drag to reorder, change sets/reps/rest, remove,
/// add. Every change saves at once.
class EditableDay extends ConsumerWidget {
  const new({required this.day, super.key});

  final ProgramDayView day;

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final id = await showAddExerciseSheet(context, ref);
    if (id == null) return;
    final exercise = ref.read(catalogProvider).byId(id);
    final added = await ref
        .read(programRepositoryProvider)
        .addExercise(
          day.id,
          id,
          PlanGenerator.prescribe(exercise, ref.read(profileProvider)),
        );
    if (!added) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.planDayFull)));
    }
  }

  /// Pick body parts; the coach fills the day, avoiding what the other
  /// days already use.
  Future<void> _rebuild(BuildContext context, WidgetRef ref) async {
    final parts = await showAppSheet<Set<BodyPart>>(
      context,
      builder: (_) => const _BodyPartSheet(),
    );
    if (parts == null || parts.isEmpty) return;
    final program = ref.read(activeProgramProvider).value;
    final others = {
      for (final d in program?.days ?? const <ProgramDayView>[])
        if (d.id != day.id)
          for (final e in d.exercises) e.exerciseId,
    };
    final built = ref
        .read(planGeneratorProvider)
        .buildDay(parts, ref.read(profileProvider), avoid: others);
    if (built.exercises.isEmpty) return;
    await ref.read(programRepositoryProvider).replaceDay(day.id, built);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final repo = ref.read(programRepositoryProvider);
    return Column(
      children: [
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          // Already adjusted for the item being lifted out.
          onReorderItem: (from, to) =>
              unawaited(repo.moveExercise(day.id, from, to)),
          children: [
            for (final (i, e) in day.exercises.indexed)
              _EditableRow(
                key: ValueKey(e.id),
                entry: e,
                index: i,
                canRemove: day.exercises.length > 1,
              ),
          ],
        ),
        AppListTile(
          icon: Symbols.add_rounded,
          title: l10n.addExercise,
          onTap: () => _add(context, ref),
        ),
        AppListTile(
          icon: Symbols.autorenew_rounded,
          title: l10n.planRebuildDay,
          subtitle: l10n.planRebuildDaySub,
          onTap: () => _rebuild(context, ref),
        ),
      ],
    );
  }
}

class _EditableRow extends ConsumerWidget {
  const new({
    required this.entry,
    required this.index,
    required this.canRemove,
    super.key,
  });

  final ProgramExerciseView entry;
  final int index;
  final bool canRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final exercise = ref.watch(catalogProvider).byId(entry.exerciseId);
    final p = entry.prescription;
    final repo = ref.read(programRepositoryProvider);
    final line = exercise.isTimed
        ? l10n.setsSeconds(p.sets, p.repMin, p.repMax)
        : l10n.setsReps(p.sets, p.repMin, p.repMax);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: index,
            child: Semantics(
              label: l10n.planReorder(exercise.name),
              child: SizedBox.square(
                dimension: AppTapTargets.min,
                child: Icon(
                  Symbols.drag_indicator_rounded,
                  color: c.textSecondary,
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadii.chip),
              onTap: () async {
                final edited = await showAppSheet<Prescription>(
                  context,
                  builder: (_) => _PrescriptionSheet(
                    title: exercise.name,
                    initial: p,
                    timed: exercise.isTimed,
                  ),
                );
                if (edited != null) {
                  await repo.updatePrescription(entry.id, edited);
                }
              },
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: AppTapTargets.min),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(exercise.name, style: text.bodyLarge),
                    Text(
                      l10n.planRestLine(line, p.restSeconds),
                      style: text.labelLarge?.copyWith(color: c.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.planRemove(exercise.name),
            onPressed: canRemove
                ? () => unawaited(repo.removeExercise(entry.id))
                : null,
            icon: const Icon(Symbols.delete_outline_rounded),
          ),
        ],
      ),
    );
  }
}

class _BodyPartSheet extends StatefulWidget {
  const new();

  @override
  State<_BodyPartSheet> createState() => _BodyPartSheetState();
}

class _BodyPartSheetState extends State<_BodyPartSheet> {
  final Set<BodyPart> _parts = {};

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.planRebuildTitle, style: text.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.planRebuildHint,
          style: text.bodyLarge?.copyWith(color: context.colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final part in BodyPart.values)
              FilterChip(
                label: Text(PlanGenerator.partName(part)),
                selected: _parts.contains(part),
                onSelected: (on) =>
                    setState(() => on ? _parts.add(part) : _parts.remove(part)),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          label: l10n.planRebuildAction,
          onPressed: _parts.isEmpty
              ? null
              : () => Navigator.pop(context, _parts),
        ),
      ],
    );
  }
}

/// Sets, rep range and rest for one planned exercise.
class _PrescriptionSheet extends StatefulWidget {
  const new({required this.title, required this.initial, required this.timed});

  final String title;
  final Prescription initial;
  final bool timed;

  @override
  State<_PrescriptionSheet> createState() => _PrescriptionSheetState();
}

class _PrescriptionSheetState extends State<_PrescriptionSheet> {
  late Prescription _p = widget.initial;

  void _set({int? sets, int? repMin, int? repMax, int? rest}) {
    var lo = repMin ?? _p.repMin;
    var hi = repMax ?? _p.repMax;
    // Moving one end past the other drags the other along.
    if (repMin != null && lo > hi) hi = lo;
    if (repMax != null && hi < lo) lo = hi;
    setState(() {
      _p = PlanLimits.clamp(
        Prescription(
          sets: sets ?? _p.sets,
          repMin: lo,
          repMax: hi,
          restSeconds: rest ?? _p.restSeconds,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final unit = widget.timed ? l10n.seconds : null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.lg),
        ValueStepper(
          label: l10n.planSets,
          value: _p.sets.toDouble(),
          min: PlanLimits.minSets.toDouble(),
          max: PlanLimits.maxSets.toDouble(),
          onChanged: (v) => _set(sets: v.round()),
        ),
        const SizedBox(height: AppSpacing.md),
        ValueStepper(
          label: widget.timed ? l10n.planTimeFrom : l10n.planRepsFrom,
          value: _p.repMin.toDouble(),
          min: PlanLimits.minReps.toDouble(),
          max: PlanLimits.maxReps.toDouble(),
          unit: unit,
          onChanged: (v) => _set(repMin: v.round()),
        ),
        const SizedBox(height: AppSpacing.md),
        ValueStepper(
          label: widget.timed ? l10n.planTimeTo : l10n.planRepsTo,
          value: _p.repMax.toDouble(),
          min: PlanLimits.minReps.toDouble(),
          max: PlanLimits.maxReps.toDouble(),
          unit: unit,
          onChanged: (v) => _set(repMax: v.round()),
        ),
        const SizedBox(height: AppSpacing.md),
        ValueStepper(
          label: l10n.planRest,
          value: _p.restSeconds.toDouble(),
          step: PlanLimits.restStep.toDouble(),
          min: PlanLimits.minRest.toDouble(),
          max: PlanLimits.maxRest.toDouble(),
          unit: l10n.seconds,
          onChanged: (v) => _set(rest: v.round()),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          label: l10n.save,
          onPressed: () => Navigator.pop(context, _p),
        ),
      ],
    );
  }
}

/// Asks for a new day name; null when cancelled.
Future<String?> showRenameDayDialog(BuildContext context, String current) {
  final controller = TextEditingController(text: current);
  final l10n = context.l10n;
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.planRenameDay),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLength: PlanLimits.maxDayNameLength,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: l10n.planDayName),
        onSubmitted: (v) => Navigator.pop(context, v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: Text(l10n.save),
        ),
      ],
    ),
  );
}
