import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/l10n/l10n.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  const new({required this.exerciseId, super.key});

  final String exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final c = context.colors;
    final exercise = ref.watch(catalogProvider).maybe(exerciseId);
    if (exercise == null) return const Scaffold(body: SizedBox.shrink());
    final alternatives = ref
        .watch(planGeneratorProvider)
        .swapOptions(exercise.id, ref.watch(profileProvider))
        .take(5)
        .toList();
    String capitalize(String s) =>
        s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          Text(exercise.name, style: text.titleLarge),
          const SizedBox(height: AppSpacing.lg),
          ExerciseMotion(exercise: exercise),
          SectionHeader(l10n.instructions),
          for (final (i, step) in exercise.instructions.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 28,
                    child: Text(
                      '${i + 1}',
                      style: text.headlineSmall?.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(child: Text(step, style: text.bodyLarge)),
                ],
              ),
            ),
          SectionHeader(l10n.primaryMuscles),
          Text(
            exercise.primaryMuscles.map(capitalize).join(', '),
            style: text.bodyLarge,
          ),
          if (exercise.secondaryMuscles.isNotEmpty) ...[
            SectionHeader(l10n.secondaryMuscles),
            Text(
              exercise.secondaryMuscles.map(capitalize).join(', '),
              style: text.bodyLarge,
            ),
          ],
          SectionHeader(l10n.equipment),
          Text(capitalize(exercise.equipmentLabel), style: text.bodyLarge),
          if (alternatives.isNotEmpty) ...[
            SectionHeader(l10n.swapFor),
            for (final alt in alternatives)
              InkWell(
                onTap: () => context.pushReplacement('/exercise/${alt.id}'),
                borderRadius: BorderRadius.circular(AppRadii.chip),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Row(
                    children: [
                      ExerciseThumb(exercise: alt, size: 44),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: Text(alt.name, style: text.bodyLarge)),
                      Icon(
                        Symbols.chevron_right_rounded,
                        color: c.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
