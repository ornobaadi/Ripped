import 'package:flutter/material.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/progression/progression_engine.dart';
import 'package:ripped/l10n/l10n.dart';

class FinishOutcome {
  const new({this.feeling, this.discard = false});

  final Feeling? feeling;
  final bool discard;
}

/// Confirms finishing, with an optional one-tap "How did it feel?" that
/// feeds progression (a "Tough" session never adds weight).
Future<FinishOutcome?> showFinishSheet(
  BuildContext context, {
  required int unlogged,
}) => showAppSheet<FinishOutcome>(
  context,
  builder: (_) => _FinishSheet(unlogged: unlogged),
);

class _FinishSheet extends StatefulWidget {
  const new({required this.unlogged});

  final int unlogged;

  @override
  State<_FinishSheet> createState() => _FinishSheetState();
}

class _FinishSheetState extends State<_FinishSheet> {
  Feeling? _feeling;

  Future<void> _discard() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.discardConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.discard),
          ),
        ],
      ),
    );
    if ((confirmed ?? false) && mounted) {
      Navigator.pop(context, const FinishOutcome(discard: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final c = context.colors;
    final feelings = [
      (Feeling.easy, l10n.feelingEasy),
      (Feeling.justRight, l10n.feelingJustRight),
      (Feeling.tough, l10n.feelingTough),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.finishWorkoutTitle, style: text.headlineSmall),
        if (widget.unlogged > 0) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.finishUnfinished(widget.unlogged),
            style: text.bodyLarge?.copyWith(color: c.textSecondary),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        Text(l10n.howDidItFeel, style: text.labelLarge),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            for (final (i, (f, label)) in feelings.indexed) ...[
              if (i > 0) const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ChoiceChip(
                  label: SizedBox(
                    width: double.infinity,
                    child: Text(label, textAlign: TextAlign.center),
                  ),
                  selected: _feeling == f,
                  showCheckmark: false,
                  selectedColor: c.surfaceRaised,
                  side: BorderSide(color: _feeling == f ? c.accent : c.border),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  onSelected: (on) => setState(() => _feeling = on ? f : null),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        AppButton(
          label: l10n.finishAction,
          onPressed: () =>
              Navigator.pop(context, FinishOutcome(feeling: _feeling)),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: l10n.keepGoing,
          variant: AppButtonVariant.secondary,
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: l10n.discardWorkout,
          variant: AppButtonVariant.ghost,
          onPressed: _discard,
        ),
      ],
    );
  }
}
