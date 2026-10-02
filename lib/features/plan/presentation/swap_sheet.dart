import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/l10n/l10n.dart';

/// Lets the user pick an equivalent exercise. Returns the chosen id.
Future<String?> showSwapSheet(
  BuildContext context,
  WidgetRef ref,
  String exerciseId,
) {
  final options = ref
      .read(planGeneratorProvider)
      .swapOptions(exerciseId, ref.read(profileProvider));
  final l10n = context.l10n;
  return showAppSheet<String>(
    context,
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.swapFor, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        if (options.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Text(
              l10n.noSwaps,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: context.colors.textSecondary),
            ),
          ),
        for (final e in options.take(12))
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: InkWell(
              onTap: () => Navigator.pop(context, e.id),
              borderRadius: BorderRadius.circular(AppRadii.chip),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  children: [
                    ExerciseThumb(exercise: e, size: 48),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            e.equipmentLabel,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: context.colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
