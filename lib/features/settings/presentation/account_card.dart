import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/auth/auth_service.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
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
            : Row(
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
      ),
    );
  }
}
