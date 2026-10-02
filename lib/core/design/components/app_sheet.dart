import 'package:flutter/material.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';

/// Bottom sheet with the app's shape and spacing. The one place a subtle
/// shadow is allowed (design.md 5.3).
Future<T?> showAppSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool scrollable = false,
}) {
  final c = context.colors;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: c.surface,
    elevation: 8,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: scrollable
          ? builder(context)
          : SingleChildScrollView(child: builder(context)),
    ),
  );
}

/// One tappable row inside a sheet or settings list.
class AppListTile extends StatelessWidget {
  const new({
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.chip),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppTapTargets.workout),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: c.textSecondary),
                const SizedBox(width: AppSpacing.lg),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text.bodyLarge),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: text.bodyMedium?.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
