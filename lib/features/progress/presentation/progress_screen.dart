import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/db/app_database.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/core/utils/format.dart';
import 'package:ripped/core/utils/labels.dart';
import 'package:ripped/domain/gamification/streak.dart';
import 'package:ripped/domain/records/personal_records.dart';
import 'package:ripped/features/progress/presentation/insights_sections.dart';
import 'package:ripped/features/workout/data/workout_models.dart';
import 'package:ripped/l10n/l10n.dart';

/// Level, streak calendar, records, strength trend, history (design.md 3.5).
class ProgressScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final level = ref.watch(levelProvider);
    final streak = ref.watch(streakProvider);
    final history = ref.watch(historyProvider).value;

    return Scaffold(
      // Scrolls behind the floating nav bar; the bottom inset clears it.
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverList.list(
                children: [
                  Text(l10n.tabProgress, style: text.titleLarge),
                  const SizedBox(height: AppSpacing.lg),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: LevelBadge(
                                level: level.level,
                                title: l10n.levelTitle(level.title),
                              ),
                            ),
                            StreakFlame(
                              weeks: streak.weeks,
                              label: l10n.streakWeeks(streak.weeks),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        XpBar(
                          value: level.progress,
                          label: l10n.xpProgress(
                            level.xpIntoLevel,
                            level.xpForNext,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.xpProgress(level.xpIntoLevel, level.xpForNext),
                          style: text.bodySmall?.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const WeekRecapSection(),
                  const MuscleBalanceSection(),
                  SectionHeader(l10n.streakTitle),
                  _StreakCalendar(streak: streak),
                  const AchievementsPreview(),
                  const _RecordsSection(),
                  const _TrendSection(),
                  SectionHeader(l10n.historyTitle),
                  if (history != null && history.isEmpty)
                    EmptyState(
                      icon: Symbols.history_rounded,
                      title: l10n.historyEmptyTitle,
                      message: l10n.historyEmptyMessage,
                    ),
                ],
              ),
            ),
            if (history != null && history.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                sliver: SliverList.separated(
                  itemCount: history.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) => _HistoryCard(entry: history[i]),
                ),
              ),
            SliverToBoxAdapter(
              child: SizedBox(height: MediaQuery.paddingOf(context).bottom),
            ),
          ],
        ),
      ),
    );
  }
}

/// Last 12 weeks as pills: filled = target hit, shield = protected,
/// outline = current week. Missed weeks are neutral, never red.
class _StreakCalendar extends StatelessWidget {
  const new({required this.streak});

  final StreakInfo streak;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final weeks = streak.history.length > 12
        ? streak.history.sublist(streak.history.length - 12)
        : streak.history;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: l10n.streakWeeks(streak.weeks),
            excludeSemantics: true,
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final w in weeks)
                  Tooltip(
                    message:
                        '${l10n.weekOf(DateFormat.MMMd().format(w.start))}: '
                        '${l10n.weekDoneOfTarget(w.done, streak.target)}',
                    child: Container(
                      width: 22,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: switch (w.status) {
                          WeekStatus.hit => c.success,
                          WeekStatus.shielded => c.surfaceRaised,
                          _ => Colors.transparent,
                        },
                        border: Border.all(
                          width: 2,
                          color: switch (w.status) {
                            WeekStatus.hit => c.success,
                            WeekStatus.current => c.textPrimary,
                            WeekStatus.shielded => c.textSecondary,
                            WeekStatus.missed => c.border,
                          },
                        ),
                      ),
                      child: w.status == WeekStatus.shielded
                          ? Icon(
                              Symbols.shield_rounded,
                              fill: 1,
                              size: 12,
                              color: c.textSecondary,
                            )
                          : null,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(
                Symbols.shield_rounded,
                fill: streak.shieldAvailable ? 1 : 0,
                size: 16,
                color: c.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  streak.shieldAvailable
                      ? l10n.shieldAvailable
                      : l10n.shieldUsed,
                  style: text.bodySmall?.copyWith(color: c.textSecondary),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l10n.weekDoneOfTarget(streak.currentWeekDone, streak.target),
                style: text.labelLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecordsSection extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final units = ref.watch(unitsProvider);
    final catalog = ref.watch(catalogProvider);
    final records = ref.watch(recordsProvider).value ?? const [];
    // One card per exercise: its latest record.
    final latest = <String, PersonalRecordRow>{};
    for (final r in records) {
      latest.putIfAbsent(r.exerciseId, () => r);
    }
    final shown = latest.values.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(l10n.recordsTitle),
        if (shown.isEmpty)
          Text(
            l10n.recordsEmpty,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: context.colors.textSecondary),
          ),
        for (final r in shown)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: () {
              final (headline, detail) = l10n.prText(
                PrType.values.byName(r.type),
                value: r.value,
                previous: r.previous,
                weightKg: r.weightKg,
                reps: r.reps,
                units: units,
              );
              return PrCard(
                exerciseName: catalog.maybe(r.exerciseId)?.name ?? '',
                headline: headline,
                detail: '$detail · ${DateFormat.MMMd().format(r.achievedAt)}',
                badge: l10n.newBest,
              );
            }(),
          ),
      ],
    );
  }
}

final _trainedProvider = FutureProvider<List<String>>((ref) {
  ref.watch(historyProvider);
  return ref.watch(workoutRepositoryProvider).trainedExerciseIds();
});

// Riverpod does not export the family type, so it cannot be annotated.
// ignore: specify_nonobvious_property_types
final _sessionsProvider = FutureProvider.family<List<ExerciseSession>, String>((
  ref,
  id,
) {
  ref.watch(historyProvider);
  return ref.watch(workoutRepositoryProvider).exerciseHistory(id);
});

class _TrendSection extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_TrendSection> createState() => _TrendSectionState();
}

class _TrendSectionState extends ConsumerState<_TrendSection> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final units = ref.watch(unitsProvider);
    final catalog = ref.watch(catalogProvider);
    final trained = ref.watch(_trainedProvider).value ?? const [];
    final id = trained.contains(_selected) ? _selected : trained.firstOrNull;
    final sessions = id == null
        ? const <ExerciseSession>[]
        : ref.watch(_sessionsProvider(id)).value ?? const [];
    final points = [
      for (final s in sessions)
        if (s.bestE1rm != null) Fmt.toDisplay(s.bestE1rm!, units),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(l10n.chartTitle),
        if (trained.isEmpty)
          Text(
            l10n.chartEmpty,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: c.textSecondary),
          )
        else ...[
          SizedBox(
            height: AppTapTargets.min,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: trained.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, i) {
                final e = trained[i];
                return ChoiceChip(
                  label: Text(catalog.maybe(e)?.name ?? e),
                  selected: e == id,
                  showCheckmark: false,
                  selectedColor: c.surfaceRaised,
                  side: BorderSide(color: e == id ? c.accent : c.border),
                  onSelected: (_) => setState(() => _selected = e),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: points.length < 2
                ? Text(
                    l10n.chartEmpty,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: c.textSecondary),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.chartEstimatedMax,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: c.textSecondary),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TrendChart(
                        values: points,
                        semanticLabel:
                            '${l10n.chartEstimatedMax}: '
                            '${Fmt.number(points.first)} → '
                            '${Fmt.number(points.last)} '
                            '${Fmt.unit(units, l10n)}',
                        format: (v) =>
                            '${Fmt.number(v)} ${Fmt.unit(units, l10n)}',
                      ),
                    ],
                  ),
          ),
        ],
      ],
    );
  }
}

class _HistoryCard extends ConsumerWidget {
  const new({required this.entry});

  final HistoryEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final c = context.colors;
    final units = ref.watch(unitsProvider);
    final h = entry;
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
                  style: text.bodySmall?.copyWith(color: c.textSecondary),
                ),
                Text(h.name, style: text.headlineSmall),
                Text(
                  l10n.historySummary(
                    h.sets,
                    Fmt.volume(h.volumeKg, units, l10n),
                  ),
                  style: text.bodyMedium?.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),
          Text(Fmt.clock(h.duration), style: text.labelLarge),
        ],
      ),
    );
  }
}
