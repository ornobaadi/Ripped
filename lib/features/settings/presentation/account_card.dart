import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/analytics/analytics.dart';
import 'package:ripped/core/auth/auth_service.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/core/sync/sync_controller.dart';
import 'package:ripped/l10n/l10n.dart';

/// Optional account (PRD 7.10). Hidden when no backend is configured.
class AccountCard extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends ConsumerState<AccountCard> {
  bool _busy = false;

  Future<void> _signIn() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final result = await ref.read(authServiceProvider).signInWithGoogle();
    if (!mounted) return;
    setState(() => _busy = false);
    if (result == SignInResult.success) {
      ref.read(analyticsProvider).track(AnalyticsEvent.signedIn);
    }
    if (result == SignInResult.failed) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.signInFailed)));
    }
  }

  Future<void> _signOut() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.signOutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await ref.read(authServiceProvider).signOut();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authServiceProvider);
    if (!auth.isAvailable) return const SizedBox.shrink();
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final c = context.colors;
    final user = ref.watch(currentUserProvider).value;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: AppCard(
        child: user == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.backupTitle, style: text.headlineSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.backupMessage,
                    style: text.bodyMedium?.copyWith(color: c.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: _busy ? l10n.signingIn : l10n.continueWithGoogle,
                    variant: AppButtonVariant.secondary,
                    onPressed: _busy ? null : _signIn,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: c.surfaceRaised,
                        foregroundImage: user.photoUrl == null
                            ? null
                            : NetworkImage(user.photoUrl!),
                        child: Text(
                          (user.name ?? user.email ?? '?').characters.first
                              .toUpperCase(),
                          style: text.labelLarge,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name ?? l10n.signedIn,
                              style: text.labelLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (user.email != null)
                              Text(
                                user.email!,
                                style: text.bodySmall?.copyWith(
                                  color: c.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _signOut,
                        style: TextButton.styleFrom(
                          foregroundColor: c.textSecondary,
                        ),
                        child: Text(l10n.signOut),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const _SyncLine(),
                ],
              ),
      ),
    );
  }
}

/// "Backed up 2 min ago" + manual trigger.
class _SyncLine extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final sync = ref.watch(syncControllerProvider);
    final (icon, label) = switch (sync.status) {
      SyncStatus.syncing => (Symbols.sync_rounded, l10n.syncing),
      SyncStatus.failed => (Symbols.cloud_off_rounded, l10n.syncFailed),
      SyncStatus.otherAccount => (Symbols.info_rounded, l10n.syncOtherAccount),
      SyncStatus.idle when sync.lastSyncedAt != null => (
        Symbols.cloud_done_rounded,
        l10n.syncedAgo(_ago(l10n, sync.lastSyncedAt!)),
      ),
      SyncStatus.idle => (Symbols.cloud_rounded, l10n.syncFailed),
    };
    return Row(
      children: [
        Icon(icon, size: 18, color: c.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: c.textSecondary),
          ),
        ),
        if (sync.status != SyncStatus.syncing &&
            sync.status != SyncStatus.otherAccount)
          TextButton(
            onPressed: () =>
                ref.read(syncControllerProvider.notifier).requestSync(),
            child: Text(l10n.syncNow),
          ),
      ],
    );
  }

  static String _ago(AppLocalizations l10n, DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return l10n.agoJustNow;
    if (d.inHours < 1) return l10n.agoMinutes(d.inMinutes);
    if (d.inDays < 1) return l10n.agoHours(d.inHours);
    return l10n.agoDays(d.inDays);
  }
}
