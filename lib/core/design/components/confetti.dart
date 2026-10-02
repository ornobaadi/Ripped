import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ripped/core/design/theme.dart';

/// Short, one-shot confetti burst for PRs and level-ups (design.md 4).
/// Draws nothing when the system asks for reduced motion.
class ConfettiBurst extends StatefulWidget {
  const new({this.play = true, super.key});

  final bool play;

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );
  late final List<_Piece> _pieces = _spawn();

  static List<_Piece> _spawn() {
    final r = math.Random(7);
    return [
      for (var i = 0; i < 48; i++)
        _Piece(
          angle: -math.pi / 2 + (r.nextDouble() - 0.5) * math.pi * 0.9,
          speed: 0.55 + r.nextDouble() * 0.6,
          spin: (r.nextDouble() - 0.5) * 10,
          size: 5 + r.nextDouble() * 5,
          tone: i % 3,
        ),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.play &&
        !MediaQuery.disableAnimationsOf(context) &&
        !_c.isAnimating &&
        _c.value == 0) {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final colors = [c.accent, c.success, c.textPrimary];
    return IgnorePointer(
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) => _c.value == 0 || _c.isCompleted
              ? const SizedBox.expand()
              : CustomPaint(
                  size: Size.infinite,
                  painter: _ConfettiPainter(_pieces, _c.value, colors),
                ),
        ),
      ),
    );
  }
}

class _Piece {
  const new({
    required this.angle,
    required this.speed,
    required this.spin,
    required this.size,
    required this.tone,
  });

  final double angle;
  final double speed;
  final double spin;
  final double size;
  final int tone;
}

class _ConfettiPainter extends CustomPainter {
  new(this.pieces, this.t, this.colors);

  final List<_Piece> pieces;
  final double t;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(size.width / 2, size.height * 0.3);
    final reach = size.shortestSide * 0.6;
    final paint = Paint();
    for (final p in pieces) {
      final d = p.speed * reach * Curves.easeOutCubic.transform(t);
      final gravity = 0.5 * reach * 0.9 * t * t;
      final pos =
          origin +
          Offset(math.cos(p.angle) * d, math.sin(p.angle) * d + gravity);
      paint.color = colors[p.tone].withValues(alpha: 1 - t);
      canvas
        ..save()
        ..translate(pos.dx, pos.dy)
        ..rotate(p.spin * t)
        ..drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.5,
          ),
          paint,
        )
        ..restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
