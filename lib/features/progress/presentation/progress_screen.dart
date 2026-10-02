import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/core/utils/format.dart';
import 'package:ripped/l10n/l10n.dart';

/// Phase 1: workout history. Streaks, PRs and charts arrive in Phase 2.
class ProgressScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final c = context.colors;
    final units = ref.watch(unitsProvider);
    final history = ref.watch(historyProvider).value;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverToBoxAdapter(
                child: Text(l10n.historyTitle, style: text.titleLarge),
              ),
            ),
            if (history != null && history.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: EmptyState(
                    icon: Icons.history,
                    title: l10n.historyEmptyTitle,
                    message: l10n.historyEmptyMessage,
                  ),
                ),
              )
            else if (history != null)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                sliver: SliverList.separated(
                  itemCount: history.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) {
                    final h = history[i];
                    return AppCard(
                      onTap: () => context.push('/history/${h.id}'),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat.MMMEd().format(h.startedAt),
                                  style: text.bodySmall?.copyWith(
                                    color: c.textSecondary,
                                  ),
                                ),
                                Text(h.name, style: text.headlineSmall),
                                Text(
                                  l10n.historySummary(
                                    h.sets,
                                    Fmt.volume(h.volumeKg, units, l10n),
                                  ),
                                  style: text.bodyMedium?.copyWith(
                                    color: c.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(Fmt.clock(h.duration), style: text.labelLarge),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
