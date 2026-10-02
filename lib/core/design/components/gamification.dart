import 'package:flutter/material.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';

/// Flame + weeks (design.md 4). Quiet gray at zero: never a "loss" state.
class StreakFlame extends StatelessWidget {
  const new({required this.weeks, required this.label, super.key});

  final int weeks;

  /// e.g. "3-week streak", for screen readers.
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final active = weeks > 0;
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            active
                ? Icons.local_fire_department
                : Icons.local_fire_department_outlined,
            color: active ? c.warning : c.textSecondary,
            size: 22,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$weeks',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(color: active ? c.textPrimary : c.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Thin XP bar that animates from [from] to [value] (0..1).
class XpBar extends StatelessWidget {
  const new({
    required this.value,
    required this.label,
    this.from,
    this.duration = AppMotion.celebrate,
    super.key,
  });

  final double value;
  final double? from;
  final String label;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final reduce = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: from ?? value, end: value),
        duration: reduce ? Duration.zero : duration,
        curve: Curves.easeOutCubic,
        builder: (context, v, _) => ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.chip),
          child: LinearProgressIndicator(
            value: v.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: c.border,
            color: c.accent,
          ),
        ),
      ),
    );
  }
}

/// Level number in a ring + title.
class LevelBadge extends StatelessWidget {
  const new({required this.level, required this.title, super.key});

  final int level;
  final String title;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Semantics(
      label: '$title, level $level',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.surfaceRaised,
              border: Border.all(color: c.border, width: 2),
            ),
            child: Text('$level', style: text.headlineSmall),
          ),
          const SizedBox(width: AppSpacing.md),
          Flexible(
            child: Text(
              title,
              style: text.headlineSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// "New best" card: exercise + what improved, old -> new (design.md 4).
class PrCard extends StatelessWidget {
  const new({
    required this.exerciseName,
    required this.headline,
    required this.detail,
    required this.badge,
    super.key,
  });

  final String exerciseName;

  /// e.g. "Estimated max 82.5 kg".
  final String headline;

  /// e.g. "was 80 kg".
  final String detail;

  /// e.g. "New best".
  final String badge;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Semantics(
      label: '$badge: $exerciseName. $headline, $detail',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(color: c.success.withValues(alpha: 0.6)),
        ),
        child: Row(
          children: [
            Icon(Icons.emoji_events_outlined, color: c.success),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    badge.toUpperCase(),
                    style: text.bodySmall?.copyWith(
                      color: c.success,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(exerciseName, style: text.labelLarge),
                  Text(headline, style: text.headlineSmall),
                  Text(
                    detail,
                    style: text.bodyMedium?.copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
