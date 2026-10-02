import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/db/settings_repository.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/features/settings/presentation/account_card.dart';
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
            const AccountCard(),
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
            SectionHeader(l10n.sectionReminders),
            const _RemindersTiles(),
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

class _RemindersTiles extends ConsumerWidget {
  const new();

  Future<void> _apply(
    BuildContext context,
    WidgetRef ref,
    ReminderSettings next,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await applyReminders(
      ref,
      next,
      title: l10n.reminderTitle,
      body: l10n.reminderBody,
    );
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.notificationsDenied)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final r = ref.watch(remindersProvider).value ?? const ReminderSettings();
    final time = TimeOfDay(hour: r.hour, minute: r.minute);
    return Column(
      children: [
        AppListTile(
          icon: Icons.notifications_none,
          title: l10n.remindersToggle,
          subtitle: l10n.remindersSub,
          onTap: () => _apply(context, ref, r.copyWith(enabled: !r.enabled)),
          trailing: Switch(
            value: r.enabled,
            onChanged: (on) => _apply(context, ref, r.copyWith(enabled: on)),
          ),
        ),
        if (r.enabled)
          AppListTile(
            icon: Icons.schedule,
            title: l10n.reminderTime,
            trailing: Text(
              time.format(context),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: time,
              );
              if (picked == null || !context.mounted) return;
              await _apply(
                context,
                ref,
                r.copyWith(hour: picked.hour, minute: picked.minute),
              );
            },
          ),
      ],
    );
  }
}
