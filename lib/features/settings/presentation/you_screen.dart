import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/l10n/l10n.dart';

class YouScreen extends ConsumerWidget {
  const new({super.key});

  Future<void> _showText(BuildContext context, String title, String body) =>
      showAppSheet<void>(
        context,
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.md),
            Text(body, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final units = ref.watch(unitsProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(l10n.youTitle, style: text.titleLarge),
            SectionHeader(l10n.sectionTraining),
            AppListTile(
              icon: Icons.calendar_view_week_outlined,
              title: l10n.viewPlan,
              onTap: () => context.push('/plan'),
            ),
            AppListTile(
              icon: Icons.tune,
              title: l10n.editPlan,
              subtitle: l10n.editPlanSub,
              onTap: () => context.push('/onboarding'),
            ),
            SectionHeader(l10n.sectionPreferences),
            AppListTile(
              icon: Icons.straighten,
              title: l10n.units,
              trailing: SegmentedButton<Units>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(value: Units.kg, label: Text(l10n.unitKg)),
                  ButtonSegment(value: Units.lb, label: Text(l10n.unitLb)),
                ],
                selected: {units},
                onSelectionChanged: (s) => unawaited(
                  ref.read(programRepositoryProvider).setUnits(s.first),
                ),
              ),
            ),
            SectionHeader(l10n.sectionAbout),
            AppListTile(
              icon: Icons.health_and_safety_outlined,
              title: l10n.healthDisclaimer,
              onTap: () =>
                  _showText(context, l10n.disclaimerTitle, l10n.disclaimerBody),
            ),
            AppListTile(
              icon: Icons.favorite_outline,
              title: l10n.credits,
              onTap: () => _showText(context, l10n.credits, l10n.creditsBody),
            ),
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: Text(
                l10n.version('1.0.0'),
                style: text.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
