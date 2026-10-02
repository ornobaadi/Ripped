import 'package:flutter/material.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/plan/schedule.dart';

/// Seven dots for the current week (design.md 3.2). Done days are filled,
/// planned days outlined, rest days faint. Missed days stay neutral.
class WeeklyStrip extends StatelessWidget {
  const new({required this.days, required this.label, super.key});

  final List<WeekDayState> days;

  /// e.g. "2 of 4 this week", also used as the semantics label.
  final String label;

  static const _letters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Row(
        children: [
          for (final (i, state) in days.indexed) ...[
            if (i > 0) const SizedBox(width: AppSpacing.sm),
            Column(
              children: [
                Text(
                  _letters[i],
                  style: text.bodySmall?.copyWith(color: c.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xs),
                _Dot(state: state),
              ],
            ),
          ],
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Text(
              label,
              style: text.labelLarge?.copyWith(color: c.textSecondary),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const new({required this.state});

  final WeekDayState state;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    const size = 14.0;
    return AnimatedContainer(
      duration: AppMotion.base,
      curve: AppMotion.baseCurve,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: switch (state) {
          WeekDayState.done => c.success,
          _ => Colors.transparent,
        },
        border: Border.all(
          width: 2,
          color: switch (state) {
            WeekDayState.done => c.success,
            WeekDayState.today => c.textPrimary,
            WeekDayState.planned => c.textSecondary,
            WeekDayState.rest => c.border,
          },
        ),
      ),
    );
  }
}
