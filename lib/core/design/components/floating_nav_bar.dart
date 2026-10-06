import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/core/haptics/haptics.dart';

class FloatingNavDestination {
  const new({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Floating pill toolbar (M3 Expressive): the selected tab expands into a
/// labelled pill, the others collapse to their icon. Springs between states;
/// jumps when Reduce Motion is on.
class FloatingNavBar extends StatelessWidget {
  const new({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<FloatingNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// Height of the pill; screens scroll behind it.
  static const height = 64.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Center(
          heightFactor: 1,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: c.surfaceRaised,
              shape: StadiumBorder(side: BorderSide(color: c.border)),
              shadows: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: SizedBox(
              height: height,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final (i, d) in destinations.indexed)
                      _NavItem(
                        destination: d,
                        selected: i == selectedIndex,
                        onTap: () {
                          if (i != selectedIndex) {
                            Haptics.play(HapticCue.tap);
                          }
                          onSelected(i);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const new({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final FloatingNavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  // Expressive "fast spatial" spring: quick, with a hint of overshoot.
  static final _spring = SpringDescription.withDampingRatio(
    mass: 1,
    stiffness: 700,
    ratio: 0.75,
  );

  late final AnimationController _t = AnimationController.unbounded(
    vsync: this,
    value: widget.selected ? 1 : 0,
  );

  @override
  void didUpdateWidget(_NavItem old) {
    super.didUpdateWidget(old);
    if (old.selected == widget.selected) return;
    final target = widget.selected ? 1.0 : 0.0;
    if (MediaQuery.disableAnimationsOf(context)) {
      _t.value = target;
    } else {
      _t.animateWith(SpringSimulation(_spring, _t.value, target, _t.velocity));
    }
  }

  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final label = Theme.of(context).textTheme.labelLarge;
    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.destination.label,
      onTap: widget.onTap,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _t,
          builder: (context, _) {
            final t = _t.value;
            final tc = t.clamp(0.0, 1.0);
            final fg = Color.lerp(c.textSecondary, c.bg, tc);
            return Container(
              height: FloatingNavBar.height - 2 * AppSpacing.sm,
              constraints: const BoxConstraints(minWidth: 56),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: ShapeDecoration(
                // Inverse pill: the one high-contrast element in the bar.
                color: c.textPrimary.withValues(alpha: tc),
                shape: const StadiumBorder(),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.destination.icon,
                    color: fg,
                    fill: tc,
                    weight: 500,
                    size: 24,
                  ),
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      // Overshoot is allowed: the pill bounces a little.
                      widthFactor: t.clamp(0.0, 1.15),
                      child: Opacity(
                        opacity: tc,
                        child: Padding(
                          padding: const EdgeInsets.only(left: AppSpacing.sm),
                          child: Text(
                            widget.destination.label,
                            maxLines: 1,
                            softWrap: false,
                            // Keeps the bar on one line at 200% text.
                            textScaler: MediaQuery.textScalerOf(context)
                                .clamp(maxScaleFactor: 1.3),
                            style: label?.copyWith(color: fg),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
