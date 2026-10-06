import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/insights/achievements.dart';
import 'package:ripped/features/progress/presentation/achievement_tile.dart';
import 'package:ripped/l10n/l10n.dart';

/// Every badge: earned first within each group, hidden ones as mysteries.
class AchievementsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final stats = ref.watch(achievementStatsProvider);
    final earned = Achievements.earned(stats).length;

    String groupTitle(AchievementGroup g) => switch (g) {
      AchievementGroup.workouts => l10n.achGroupWorkouts,
      AchievementGroup.streak => l10n.achGroupStreak,
      AchievementGroup.records => l10n.achGroupRecords,
      AchievementGroup.volume => l10n.achGroupVolume,
      AchievementGroup.level => l10n.achGroupLevel,
      AchievementGroup.variety => l10n.achGroupVariety,
      AchievementGroup.secret => l10n.achGroupSecret,
    };

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
          Text(l10n.achievementsTitle, style: text.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.achievementsCount(earned, Achievements.all.length),
            style: text.bodyLarge?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          for (final group in AchievementGroup.values) ...[
            SectionHeader(groupTitle(group)),
            for (final a in Achievements.all.where((a) => a.group == group))
              AchievementTile(achievement: a, stats: stats),
          ],
        ],
      ),
    );
  }
}
