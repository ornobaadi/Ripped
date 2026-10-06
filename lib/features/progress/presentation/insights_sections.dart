import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/core/utils/format.dart';
import 'package:ripped/domain/insights/achievements.dart';
import 'package:ripped/domain/insights/muscle_balance.dart';
import 'package:ripped/features/progress/presentation/achievement_tile.dart';
import 'package:ripped/features/progress/presentation/share_card.dart';
import 'package:ripped/l10n/l10n.dart';

/// This week in numbers, with a share button. Totals only, so the shared
/// card never reveals anything personal.
class WeekRecapSection extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final recap = ref.watch(weeklyRecapProvider);
    final units = ref.watch(unitsProvider);
    final streak = ref.watch(streakProvider);
    final volume = Fmt.volume(recap.volumeKg, units, l10n);
    final change = recap.volumeChange;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          l10n.thisWeekTitle,
          trailing: recap.isEmpty
              ? null
              : IconButton(
                  tooltip: l10n.shareWeek,
                  icon: const Icon(Symbols.ios_share_rounded),
                  onPressed: () => unawaited(
                    showShareCardSheet(
                      context,
                      text: l10n.shareWeekText(
                        recap.workouts,
                        recap.sets,
                        volume,
                      ),
                      data: ShareCardData(
                        weekStart: recap.weekStart,
                        volume: volume,
                        workouts: recap.workouts,
                        sets: recap.sets,
                        minutes: recap.minutes,
                        trainedWeekdays: {
                          for (final s in recap.sessions) s.startedAt.weekday,
                        },
                        streakWeeks: streak.weeks,
                        topMuscle: switch (MuscleBalance.top(
                          ref.watch(muscleBalanceProvider),
                        )) {
                          MuscleGroup.chest => l10n.muscleChest,
                          MuscleGroup.back => l10n.muscleBack,
                          MuscleGroup.shoulders => l10n.muscleShoulders,
                          MuscleGroup.arms => l10n.muscleArms,
                          MuscleGroup.core => l10n.muscleCore,
                          MuscleGroup.legs => l10n.muscleLegs,
                          null => null,
                        },
                        changePercent: change == null
                            ? null
                            : (change * 100).round(),
                      ),
                    ),
                  ),
                ),
        ),
        SizedBox(
          child: AppCard(
            child: recap.isEmpty
                ? Text(
                    l10n.thisWeekEmpty,
                    style: text.bodyLarge?.copyWith(color: c.textSecondary),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: StatTile(
                              value: '${recap.workouts}',
                              label: l10n.recapWorkouts,
                            ),
                          ),
                          Expanded(
                            child: StatTile(
                              value: '${recap.sets}',
                              label: l10n.recapSets,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: StatTile(
                              value: volume,
                              label: l10n.recapVolume,
                            ),
                          ),
                          Expanded(
                            child: StatTile(
                              value: l10n.minutesShort(recap.minutes),
                              label: l10n.recapTime,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        [
                          if (change != null && change >= 0)
                            l10n.recapUp((change * 100).round()),
                          if (change != null && change < 0)
                            l10n.recapDown((-change * 100).round()),
                          if (streak.weeks > 0) l10n.streakWeeks(streak.weeks),
                          l10n.appTitle,
                        ].join(' · '),
                        style: text.bodyMedium?.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

/// Sets per muscle group this week, as plain bars. Neutral colours: it
/// informs, it doesn't grade.
class MuscleBalanceSection extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final sets = ref.watch(muscleBalanceProvider);
    final most = sets.values.fold(0, (a, b) => a > b ? a : b);
    if (most == 0) return const SizedBox.shrink();

    String name(MuscleGroup g) => switch (g) {
      MuscleGroup.chest => l10n.muscleChest,
      MuscleGroup.back => l10n.muscleBack,
      MuscleGroup.shoulders => l10n.muscleShoulders,
      MuscleGroup.arms => l10n.muscleArms,
      MuscleGroup.core => l10n.muscleCore,
      MuscleGroup.legs => l10n.muscleLegs,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(l10n.muscleBalanceTitle),
        AppCard(
          child: Column(
            children: [
              for (final MapEntry(key: group, value: count) in sets.entries)
                Semantics(
                  label: l10n.muscleSets(name(group), count),
                  excludeSemantics: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(name(group), style: text.bodyLarge),
                        ),
                        Expanded(
                          flex: 5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadii.chip),
                            child: LinearProgressIndicator(
                              value: count / most,
                              minHeight: 8,
                              backgroundColor: c.surfaceRaised,
                              color: count == 0
                                  ? c.surfaceRaised
                                  : c.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: Text(
                            '$count',
                            textAlign: TextAlign.end,
                            style: text.bodyLarge?.copyWith(
                              color: c.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The next badge within reach, and a way into the full list.
class AchievementsPreview extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final stats = ref.watch(achievementStatsProvider);
    final next = Achievements.next(stats);
    final earned = Achievements.earned(stats).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(l10n.achievementsTitle),
        AppCard(
          onTap: () => context.push('/achievements'),
          semanticLabel: l10n.achievementsSeeAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.achievementsCount(earned, Achievements.all.length),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Icon(
                    Symbols.chevron_right_rounded,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
              if (next != null) ...[
                const SizedBox(height: AppSpacing.sm),
                AchievementTile(achievement: next, stats: stats),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
