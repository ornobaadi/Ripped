import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/insights/recovery_advisor.dart';
import 'package:ripped/domain/plan/schedule.dart';
import 'package:ripped/l10n/l10n.dart';

/// Gentle coaching on Today: at most one card at a time, always optional.
/// Order: a running easy week, then an easy-week offer, then a plan refresh.
class CoachCards extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.read(settingsRepositoryProvider);

    if (ref.watch(easyWeekActiveProvider)) {
      return _CoachCard(
        icon: Symbols.spa_rounded,
        title: l10n.easyWeekActiveTitle,
        message: l10n.easyWeekActiveMessage,
        secondaryLabel: l10n.easyWeekEnd,
        onSecondary: () => unawaited(settings.endEasyWeek(DateTime.now())),
      );
    }

    final reason = ref.watch(easyWeekSuggestionProvider);
    if (reason != null) {
      return _CoachCard(
        icon: Symbols.spa_rounded,
        title: l10n.easyWeekOfferTitle,
        message: switch (reason) {
          EasyWeekReason.fatigue => l10n.easyWeekOfferFatigue,
          EasyWeekReason.longRun => l10n.easyWeekOfferLongRun,
        },
        primaryLabel: l10n.easyWeekAccept,
        onPrimary: () {
          final now = DateTime.now();
          unawaited(
            settings.startEasyWeek(
              now: now,
              until: Schedule.addDays(Schedule.weekStart(now), 7),
            ),
          );
        },
        secondaryLabel: l10n.notNow,
        onSecondary: () => unawaited(settings.dismissEasyWeek(DateTime.now())),
      );
    }

    if (ref.watch(planRefreshSuggestionProvider)) {
      return _CoachCard(
        icon: Symbols.autorenew_rounded,
        title: l10n.planRefreshTitle,
        message: l10n.planRefreshMessage,
        primaryLabel: l10n.planRefreshAccept,
        onPrimary: () => context.push('/onboarding'),
        secondaryLabel: l10n.notNow,
        onSecondary: () =>
            unawaited(settings.dismissPlanRefresh(DateTime.now())),
      );
    }
    return const SizedBox.shrink();
  }
}

class _CoachCard extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.message,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: c.textSecondary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(title, style: text.headlineSmall)),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: text.bodyLarge?.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                if (primaryLabel != null)
                  FilledButton.tonal(
                    onPressed: onPrimary,
                    child: Text(primaryLabel!),
                  ),
                if (secondaryLabel != null)
                  TextButton(
                    onPressed: onSecondary,
                    child: Text(secondaryLabel!),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
