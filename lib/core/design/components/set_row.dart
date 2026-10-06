import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/core/haptics/haptics.dart';
import 'package:ripped/l10n/l10n.dart';

/// One row in the active workout: `Set 2   60 kg × 8   [✓]`.
/// Tapping the check logs the set (one-tap logging, PRD 7.4).
class SetRow extends StatelessWidget {
  const new({
    required this.setNumber,
    required this.load,
    required this.done,
    required this.onToggle,
    this.previous,
    this.onTap,
    super.key,
  });

  final int setNumber;

  /// Preformatted: "60 kg × 8", "12 reps" or "45 s".
  final String load;
  final bool done;

  /// Last session's result, e.g. "57.5 kg × 8".
  final String? previous;
  final VoidCallback onToggle;

  /// Opens the edit sheet for weight/reps.
  final VoidCallback? onTap;

  void _toggle() {
    Haptics.play(HapticCue.tap);
    onToggle();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Material(
      color: done ? c.surface : c.surfaceRaised,
      borderRadius: BorderRadius.circular(AppRadii.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppTapTargets.workout),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.setLabel(setNumber),
                        style: text.bodySmall?.copyWith(color: c.textSecondary),
                      ),
                      Text(load, style: text.headlineSmall),
                      if (previous != null)
                        Text(
                          previous!,
                          style: text.bodySmall?.copyWith(
                            color: c.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Semantics(
                  container: true,
                  button: true,
                  checked: done,
                  label: done
                      ? l10n.setDone(setNumber)
                      : l10n.markSetDone(setNumber),
                  excludeSemantics: true,
                  onTap: _toggle,
                  child: IconButton(
                    onPressed: _toggle,
                    icon: Icon(
                      done ? Symbols.check_rounded : Symbols.check_rounded,
                    ),
                    iconSize: 28,
                    style: IconButton.styleFrom(
                      minimumSize: const Size.square(AppTapTargets.workout),
                      backgroundColor: done ? c.success : c.surface,
                      foregroundColor: done ? c.onAccent : c.textSecondary,
                      side: done ? null : BorderSide(color: c.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.card),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
