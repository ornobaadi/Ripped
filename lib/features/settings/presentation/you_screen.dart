import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/analytics/analytics.dart';
import 'package:ripped/core/db/settings_repository.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/core/haptics/haptics.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/features/settings/presentation/account_card.dart';
import 'package:ripped/features/settings/presentation/data_privacy_tiles.dart';
import 'package:ripped/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final theme =
        ref.watch(themeProvider).value ?? ref.watch(initialThemeProvider);

    return Scaffold(
      // Scrolls behind the floating nav bar; the bottom inset clears it.
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg + MediaQuery.paddingOf(context).bottom,
          ),
          children: [
            Text(l10n.youTitle, style: text.titleLarge),
            const AccountCard(),
            SectionHeader(l10n.sectionTraining),
            AppListTile(
              icon: Symbols.calendar_view_week_rounded,
              title: l10n.viewPlan,
              onTap: () => context.push('/plan'),
            ),
            AppListTile(
              icon: Symbols.tune_rounded,
              title: l10n.editPlan,
              subtitle: l10n.editPlanSub,
              onTap: () => context.push('/onboarding'),
            ),
            SectionHeader(l10n.sectionPreferences),
            AppListTile(
              icon: Symbols.straighten_rounded,
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
            AppListTile(
              icon: Symbols.contrast_rounded,
              title: l10n.appearance,
              subtitle: switch (theme) {
                'system' => l10n.themeSystem,
                'light' => l10n.themeLight,
                _ => l10n.themeDark,
              },
              trailing: Icon(
                Symbols.chevron_right_rounded,
                color: context.colors.textSecondary,
              ),
              onTap: () => showAppSheet<void>(
                context,
                builder: (context) => const _ThemeSheet(),
              ),
            ),
            AppListTile(
              icon: Symbols.vibration_rounded,
              title: l10n.hapticsTitle,
              subtitle: l10n.hapticsSub,
              trailing: Switch(
                value: ref.watch(hapticsEnabledProvider).value ?? true,
                onChanged: (on) {
                  unawaited(
                    ref
                        .read(settingsRepositoryProvider)
                        .saveHapticsEnabled(enabled: on),
                  );
                  // Let them feel what they just turned on.
                  Haptics.enabled = on;
                  Haptics.play(HapticCue.setDone);
                },
              ),
            ),
            SectionHeader(l10n.sectionReminders),
            const _RemindersTiles(),
            SectionHeader(l10n.sectionDataPrivacy),
            const DataPrivacyTiles(),
            SectionHeader(l10n.sectionAbout),
            if (ref.watch(appConfigProvider).supportEmail.isNotEmpty)
              AppListTile(
                icon: Symbols.mail_outline_rounded,
                title: l10n.sendFeedback,
                subtitle: l10n.sendFeedbackSub,
                onTap: () => launchUrl(
                  Uri(
                    scheme: 'mailto',
                    path: ref.read(appConfigProvider).supportEmail,
                    query:
                        'subject=${Uri.encodeComponent(l10n.feedbackSubject)}',
                  ),
                ),
              ),
            AppListTile(
              icon: Symbols.health_and_safety_rounded,
              title: l10n.healthDisclaimer,
              onTap: () =>
                  _showText(context, l10n.disclaimerTitle, l10n.disclaimerBody),
            ),
            AppListTile(
              icon: Symbols.favorite_rounded,
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

/// System / Light / Dark. Applies immediately; the sheet stays open so the
/// change can be seen.
class _ThemeSheet extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final current =
        ref.watch(themeProvider).value ?? ref.watch(initialThemeProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.appearance, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.lg),
        for (final (value, title, subtitle) in [
          ('system', l10n.themeSystem, l10n.themeSystemSub),
          ('light', l10n.themeLight, null),
          ('dark', l10n.themeDark, null),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: ChoiceCard(
              title: title,
              subtitle: subtitle,
              selected: current == value,
              onTap: () => unawaited(
                ref.read(settingsRepositoryProvider).saveTheme(value),
              ),
            ),
          ),
      ],
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
    final ok = await applyReminders(ref, next);
    if (ok && next.enabled) {
      ref.read(analyticsProvider).track(AnalyticsEvent.remindersEnabled);
    }
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
          icon: Symbols.notifications_rounded,
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
            icon: Symbols.schedule_rounded,
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
