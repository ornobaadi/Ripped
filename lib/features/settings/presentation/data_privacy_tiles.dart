import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/analytics/analytics.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/sync/sync_controller.dart';
import 'package:ripped/features/settings/data/export_service.dart';
import 'package:ripped/l10n/l10n.dart';

/// Export, policies, and account deletion (Play account-deletion rules).
class DataPrivacyTiles extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<DataPrivacyTiles> createState() => _DataPrivacyTilesState();
}

class _DataPrivacyTilesState extends ConsumerState<DataPrivacyTiles> {
  bool _busy = false;

  Future<void> _export() async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    setState(() => _busy = true);
    try {
      await ExportService(
        ref.read(databaseProvider),
        ref.read(catalogProvider),
      ).share();
      ref.read(analyticsProvider).track(AnalyticsEvent.dataExported);
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l10n.exportFailed)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccountTitle),
        content: Text(l10n.deleteAccountBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.deleteAccountConfirm),
          ),
        ],
      ),
    );
    if (!(confirmed ?? false)) return;

    setState(() => _busy = true);
    try {
      await ref.read(authServiceProvider).deleteAccount();
      await ref.read(syncServiceProvider)?.reset();
      await ref.read(reminderSchedulerProvider).cancelAll();
      // Clears this phone; the router returns to onboarding by itself.
      await ref.read(databaseProvider).wipeAll();
      ref.read(analyticsProvider).track(AnalyticsEvent.accountDeleted);
      messenger.showSnackBar(SnackBar(content: Text(l10n.accountDeleted)));
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l10n.deleteAccountFailed)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final signedIn = ref.watch(currentUserProvider).value != null;
    return Column(
      children: [
        AppListTile(
          icon: Icons.download_outlined,
          title: l10n.exportData,
          subtitle: l10n.exportDataSub,
          onTap: _busy ? null : _export,
        ),
        AppListTile(
          icon: Icons.privacy_tip_outlined,
          title: l10n.privacyPolicy,
          onTap: () => context.push('/legal/privacy'),
        ),
        AppListTile(
          icon: Icons.gavel_outlined,
          title: l10n.terms,
          onTap: () => context.push('/legal/terms'),
        ),
        if (signedIn)
          AppListTile(
            icon: Icons.delete_outline,
            title: l10n.deleteAccount,
            subtitle: l10n.deleteAccountSub,
            onTap: _busy ? null : _delete,
          ),
      ],
    );
  }
}
