import 'package:flutter/material.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/core/utils/format.dart';

/// Full-width rest countdown shown after a set is logged (design.md 3.3).
/// Purely presentational: the owner drives [remaining].
class RestTimerBar extends StatelessWidget {
  const new({
    required this.remaining,
    required this.total,
    required this.label,
    required this.skipLabel,
    required this.addLabel,
    required this.onSkip,
    required this.onAdd,
    super.key,
  });

  final Duration remaining;
  final Duration total;
  final String label;
  final String skipLabel;
  final String addLabel;
  final VoidCallback onSkip;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final fraction = total.inMilliseconds == 0
        ? 0.0
        : (remaining.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);
    final stacked = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    final countdown = ExcludeSemantics(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: text.bodySmall?.copyWith(color: c.textSecondary)),
          Text(Fmt.clock(remaining), style: text.titleLarge),
        ],
      ),
    );
    final buttonStyle = TextButton.styleFrom(
      foregroundColor: c.textPrimary,
      minimumSize: const Size(AppTapTargets.workout, AppTapTargets.workout),
    );
    final buttons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(onPressed: onAdd, style: buttonStyle, child: Text(addLabel)),
        TextButton(
          onPressed: onSkip,
          style: buttonStyle,
          child: Text(skipLabel),
        ),
      ],
    );
    return Semantics(
      liveRegion: true,
      label: '$label ${Fmt.clock(remaining)}',
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: c.surfaceRaised,
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(color: c.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: fraction,
                  child: ColoredBox(color: c.accent.withValues(alpha: 0.14)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              // One row normally; stacked when large text needs the room.
              child: stacked
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [countdown, buttons],
                    )
                  : Row(children: [countdown, const Spacer(), buttons]),
            ),
          ],
        ),
      ),
    );
  }
}
