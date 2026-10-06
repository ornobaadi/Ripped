import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/core/design/theme.dart';

/// A Lottie animation from `assets/anim/<name>.json`. Until that file is
/// added (or if it fails to load) a drawn animation plays instead, so the
/// screen never has a hole. Still when Reduce Motion is on.
class PlanAnimation extends StatelessWidget {
  const new({
    required this.name,
    this.size = 160,
    this.repeat = true,
    super.key,
  });

  final String name;
  final double size;
  final bool repeat;

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.disableAnimationsOf(context);
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: Lottie.asset(
          'assets/anim/$name.json',
          animate: !still,
          repeat: repeat,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => _DrawnPulse(still: still),
        ),
      ),
    );
  }
}

/// Fallback: a ring that sweeps around a gently pulsing dumbbell.
class _DrawnPulse extends StatefulWidget {
  const new({required this.still});

  final bool still;

  @override
  State<_DrawnPulse> createState() => _DrawnPulseState();
}

class _DrawnPulseState extends State<_DrawnPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _t = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void initState() {
    super.initState();
    if (!widget.still) _t.repeat();
  }

  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AnimatedBuilder(
      animation: _t,
      builder: (context, _) {
        final pulse = 1 + 0.06 * math.sin(_t.value * 2 * math.pi);
        return CustomPaint(
          painter: _RingPainter(
            progress: widget.still ? 1 : _t.value,
            track: c.surfaceRaised,
            color: c.accent,
          ),
          child: Center(
            child: Transform.scale(
              scale: pulse,
              child: Icon(
                Symbols.exercise_rounded,
                size: 56,
                color: c.textPrimary,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  const new({required this.progress, required this.track, required this.color});

  final double progress;
  final Color track;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(8);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..color = track;
    canvas
      ..drawArc(rect, 0, 2 * math.pi, false, paint)
      ..drawArc(
        rect,
        -math.pi / 2 + progress * 2 * math.pi,
        math.pi * 0.6,
        false,
        paint..color = color,
      );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color || old.track != track;
}
