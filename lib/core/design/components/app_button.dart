import 'package:flutter/material.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';

enum AppButtonVariant { primary, secondary, ghost }

class AppButton extends StatelessWidget {
  const new({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (bg, fg, side) = switch (variant) {
      AppButtonVariant.primary => (c.accent, c.onAccent, BorderSide.none),
      AppButtonVariant.secondary => (
        c.surfaceRaised,
        c.textPrimary,
        BorderSide(color: c.border),
      ),
      AppButtonVariant.ghost => (
        Colors.transparent,
        c.textPrimary,
        BorderSide.none,
      ),
    };
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        minimumSize: const Size(64, 56),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.sheet),
          side: side,
        ),
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(label),
    );
  }
}
