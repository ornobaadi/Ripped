import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/insights/achievements.dart';
import 'package:ripped/l10n/l10n.dart';

IconData achievementIcon(AchievementGroup group) => switch (group) {
  AchievementGroup.workouts => Symbols.exercise_rounded,
  AchievementGroup.streak => Symbols.local_fire_department_rounded,
  AchievementGroup.records => Symbols.emoji_events_rounded,
  AchievementGroup.volume => Symbols.weight_rounded,
  AchievementGroup.level => Symbols.military_tech_rounded,
  AchievementGroup.variety => Symbols.explore_rounded,
  AchievementGroup.secret => Symbols.auto_awesome_rounded,
};

/// One badge row: icon medallion, title, what it takes, and a progress bar
/// until it's earned. Hidden badges stay a mystery until then.
class AchievementTile extends StatelessWidget {
  const new({required this.achievement, required this.stats, super.key});

  final Achievement achievement;
  final AchievementStats stats;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final earned = achievement.earned(stats);
    final secret = achievement.hidden && !earned;
    final title = secret ? l10n.achievementHiddenTitle : achievement.title;
    final description = secret
        ? l10n.achievementHiddenSub
        : achievement.description;
    final progress = achievement.progress(stats);

    return Semantics(
      label: earned ? l10n.achievementEarned(title) : title,
      value: earned || secret
          ? description
          : l10n.percent((progress * 100).round()),
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: earned ? c.accent : c.surfaceRaised,
                shape: BoxShape.circle,
              ),
              child: Icon(
                secret
                    ? Symbols.lock_rounded
                    : achievementIcon(achievement.group),
                fill: earned ? 1 : 0,
                color: earned ? c.onAccent : c.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: text.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: earned ? c.textPrimary : c.textSecondary,
                    ),
                  ),
                  Text(
                    description,
                    style: text.bodyMedium?.copyWith(color: c.textSecondary),
                  ),
                  if (!earned && !secret) ...[
                    const SizedBox(height: AppSpacing.xs),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadii.chip),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 4,
                        backgroundColor: c.surfaceRaised,
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (earned) ...[
              const SizedBox(width: AppSpacing.sm),
              Icon(Symbols.check_rounded, color: c.success),
            ],
          ],
        ),
      ),
    );
  }
}
