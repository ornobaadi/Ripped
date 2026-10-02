import 'package:flutter/material.dart';
import 'package:ripped/core/design/components/app_button.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';

/// Centered icon + message + optional action. Copy should be shame-free.
class EmptyState extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: Icon(icon, size: AppSpacing.xxxl, color: c.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Semantics(
            header: true,
            child: Text(
              title,
              style: text.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              message!,
              style: text.bodyLarge?.copyWith(color: c.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: actionLabel!,
              onPressed: onAction,
              variant: AppButtonVariant.secondary,
            ),
          ],
        ],
      ),
    );
  }
}
