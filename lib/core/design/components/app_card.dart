import 'package:flutter/material.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';

/// Flat surface card. Elevation comes from surface color, not shadow.
class AppCard extends StatelessWidget {
  const new({
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(AppRadii.card);
    return Semantics(
      container: true,
      button: onTap != null,
      label: semanticLabel,
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: c.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
