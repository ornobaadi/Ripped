import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/core/haptics/haptics.dart';
import 'package:ripped/l10n/l10n.dart';

/// Big-number stepper for weight and reps: `[-]  60 kg  [+]`.
class ValueStepper extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.onChanged,
    this.step = 1,
    this.min = 0,
    this.max = 9999,
    this.unit,
    this.fractionDigits = 0,
    super.key,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final double step;
  final double min;
  final double max;
  final String? unit;
  final int fractionDigits;

  String get _formatted {
    final number = value.toStringAsFixed(fractionDigits);
    return unit == null ? number : '$number $unit';
  }

  void _change(double delta) {
    final next = (value + delta).clamp(min, max);
    if (next != value) {
      Haptics.play(HapticCue.tap);
      onChanged(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final l10n = context.l10n;
    return Semantics(
      container: true,
      label: label,
      value: _formatted,
      increasedValue: (value + step)
          .clamp(min, max)
          .toStringAsFixed(fractionDigits),
      decreasedValue: (value - step)
          .clamp(min, max)
          .toStringAsFixed(fractionDigits),
      onIncrease: value < max ? () => _change(step) : null,
      onDecrease: value > min ? () => _change(-step) : null,
      child: Row(
        children: [
          _StepButton(
            icon: Symbols.remove_rounded,
            tooltip: l10n.decrease(label),
            onPressed: value > min ? () => _change(-step) : null,
          ),
          Expanded(
            child: ExcludeSemantics(
              child: Column(
                children: [
                  Text(
                    label,
                    style: text.bodySmall?.copyWith(color: c.textSecondary),
                  ),
                  Text(
                    _formatted,
                    style: text.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          _StepButton(
            icon: Symbols.add_rounded,
            tooltip: l10n.increase(label),
            onPressed: value < max ? () => _change(step) : null,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const new({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      onPressed: onPressed,
      iconSize: 28,
      style: IconButton.styleFrom(
        minimumSize: const Size.square(AppTapTargets.workout),
        backgroundColor: c.surfaceRaised,
        foregroundColor: c.textPrimary,
        disabledForegroundColor: c.border,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),
    );
  }
}
