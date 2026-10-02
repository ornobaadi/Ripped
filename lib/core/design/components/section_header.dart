import 'package:flutter/material.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';

class SectionHeader extends StatelessWidget {
  const new(this.title, {this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
