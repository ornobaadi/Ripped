import 'package:flutter/material.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/l10n/l10n.dart';

/// Selectable option used in onboarding (goal, equipment, experience...).
/// Selection is shown by border, check icon and semantics, not color alone.
class ChoiceCard extends StatelessWidget {
  const new({
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.icon,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      selected: selected,
      label: subtitle == null ? title : '$title. $subtitle',
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: selected ? c.surfaceRaised : c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(
            color: selected ? c.accent : c.border,
            width: selected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppTapTargets.workout),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: c.textPrimary),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: text.labelLarge),
                        if (subtitle != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            subtitle!,
                            style: text.bodyMedium?.copyWith(
                              color: c.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Icon(
                    selected ? Icons.check_circle : Icons.circle_outlined,
                    color: selected ? c.accent : c.border,
                    semanticLabel: selected ? context.l10n.selected : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
