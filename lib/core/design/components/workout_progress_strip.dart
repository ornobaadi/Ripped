import 'package:flutter/material.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';

/// The whole workout at a glance: one segment per exercise, each filling as
/// its sets are logged. The current exercise is the bright one.
class WorkoutProgressStrip extends StatelessWidget {
  const new({
    required this.segments,
    required this.current,
    required this.label,
    super.key,
  });

  /// (sets done, sets total) per exercise, in order.
  final List<(int, int)> segments;
  final int current;

  /// e.g. "5 of 18 sets done", for screen readers.
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: SizedBox(
        height: 6,
        child: Row(
          children: [
            for (final (i, (done, total)) in segments.indexed) ...[
              if (i > 0) const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(end: total == 0 ? 0 : done / total),
                    duration: AppMotion.base,
                    curve: AppMotion.baseCurve,
                    builder: (_, value, _) => LinearProgressIndicator(
                      value: value,
                      minHeight: 6,
                      backgroundColor: i == current
                          ? c.border
                          : c.surfaceRaised,
                      color: i == current ? c.textPrimary : c.success,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
