import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';

/// Minimal line chart: one series, first/last labels, no grid noise.
/// Values are already in display units.
class TrendChart extends StatelessWidget {
  const new({
    required this.values,
    required this.semanticLabel,
    this.height = 140,
    this.format,
    super.key,
  });

  final List<double> values;
  final String semanticLabel;
  final double height;
  final String Function(double)? format;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final fmt = format ?? (v) => v.toStringAsFixed(0);
    return Semantics(
      label: semanticLabel,
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: height,
            child: CustomPaint(
              painter: _TrendPainter(
                values: values,
                line: c.accent,
                fill: c.accent.withValues(alpha: 0.12),
                dot: c.textPrimary,
              ),
            ),
          ),
          if (values.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Text(
                  fmt(values.first),
                  style: text.bodySmall?.copyWith(color: c.textSecondary),
                ),
                const Spacer(),
                Text(fmt(values.last), style: text.labelLarge),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  new({
    required this.values,
    required this.line,
    required this.fill,
    required this.dot,
  });

  final List<double> values;
  final Color line;
  final Color fill;
  final Color dot;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final lo = values.reduce(math.min);
    final hi = values.reduce(math.max);
    final span = hi - lo == 0 ? 1.0 : hi - lo;
    const pad = 8.0;
    Offset at(int i) => Offset(
      values.length == 1
          ? size.width / 2
          : pad + (size.width - 2 * pad) * i / (values.length - 1),
      pad + (size.height - 2 * pad) * (1 - (values[i] - lo) / span),
    );

    final path = Path()..moveTo(at(0).dx, at(0).dy);
    for (var i = 1; i < values.length; i++) {
      path.lineTo(at(i).dx, at(i).dy);
    }
    final area = Path.from(path)
      ..lineTo(at(values.length - 1).dx, size.height)
      ..lineTo(at(0).dx, size.height)
      ..close();
    canvas
      ..drawPath(area, Paint()..color = fill)
      ..drawPath(
        path,
        Paint()
          ..color = line
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round,
      )
      ..drawCircle(at(values.length - 1), 4, Paint()..color = dot);
  }

  @override
  bool shouldRepaint(_TrendPainter old) =>
      old.values != values || old.line != line;
}
