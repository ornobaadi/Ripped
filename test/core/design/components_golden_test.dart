import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/catalog/exercise.dart';
import 'package:ripped/domain/plan/schedule.dart';

import '../../helpers/golden.dart';

void main() {
  goldenTest(
    'app_button',
    () => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(label: 'Start workout', onPressed: () {}),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'Swap exercise',
          onPressed: () {},
          variant: AppButtonVariant.secondary,
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'Skip',
          onPressed: () {},
          variant: AppButtonVariant.ghost,
        ),
        const SizedBox(height: AppSpacing.md),
        const AppButton(label: 'Disabled', onPressed: null),
      ],
    ),
    size: const Size(400, 500),
  );

  goldenTest(
    'app_card',
    () => AppCard(
      onTap: () {},
      child: const Text('Upper body A · 5 exercises · 45 min'),
    ),
    size: const Size(400, 200),
  );

  goldenTest(
    'choice_card',
    () => Column(
      children: [
        ChoiceCard(
          title: 'Build muscle',
          subtitle: '3 × 8–12, steady progress',
          icon: Icons.fitness_center,
          selected: true,
          onTap: () {},
        ),
        const SizedBox(height: AppSpacing.md),
        ChoiceCard(
          title: 'Get stronger',
          subtitle: 'Heavier, fewer reps',
          icon: Icons.trending_up,
          selected: false,
          onTap: () {},
        ),
      ],
    ),
  );

  goldenTest(
    'value_stepper',
    () => Column(
      children: [
        ValueStepper(
          label: 'Weight',
          value: 62.5,
          step: 2.5,
          unit: 'kg',
          fractionDigits: 1,
          onChanged: (_) {},
        ),
        const SizedBox(height: AppSpacing.lg),
        ValueStepper(label: 'Reps', value: 0, onChanged: (_) {}),
      ],
    ),
  );

  goldenTest(
    'set_row',
    () => Column(
      children: [
        SetRow(setNumber: 1, load: '60 kg × 8', done: true, onToggle: () {}),
        const SizedBox(height: AppSpacing.sm),
        SetRow(
          setNumber: 2,
          load: '60 kg × 8',
          previous: '57.5 kg × 8',
          done: false,
          onToggle: () {},
        ),
        const SizedBox(height: AppSpacing.sm),
        SetRow(setNumber: 3, load: '12 reps', done: false, onToggle: () {}),
      ],
    ),
    size: const Size(400, 500),
  );

  goldenTest(
    'empty_state',
    () => EmptyState(
      icon: Icons.self_improvement,
      title: 'Rest day',
      message: 'Recovery is part of the plan.',
      actionLabel: 'Do a light stretch',
      onAction: () {},
    ),
    size: const Size(400, 500),
  );

  goldenTest(
    'weekly_strip',
    () => const WeeklyStrip(
      days: [
        WeekDayState.done,
        WeekDayState.rest,
        WeekDayState.today,
        WeekDayState.rest,
        WeekDayState.planned,
        WeekDayState.rest,
        WeekDayState.rest,
      ],
      label: '1 of 3 this week',
    ),
    size: const Size(400, 160),
  );

  goldenTest(
    'rest_timer_bar',
    () => RestTimerBar(
      remaining: const Duration(seconds: 74),
      total: const Duration(seconds: 120),
      label: 'Rest',
      skipLabel: 'Skip',
      addLabel: '+15 s',
      onSkip: () {},
      onAdd: () {},
    ),
    size: const Size(400, 180),
  );

  goldenTest(
    'section_header_stat_tile',
    () => const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader('Next time'),
        Row(
          children: [
            Expanded(
              child: StatTile(value: '42:10', label: 'Duration'),
            ),
            Expanded(
              child: StatTile(value: '18', label: 'Sets'),
            ),
          ],
        ),
      ],
    ),
    size: const Size(400, 220),
  );

  goldenTest(
    'exercise_thumb_placeholder',
    () => const ExerciseThumb(
      exercise: Exercise(
        id: 'x',
        name: 'Squat',
        pattern: MovementPattern.squat,
        equipment: Equipment.gym,
        equipmentLabel: 'barbell',
        level: Level.beginner,
        priority: 1,
      ),
    ),
    size: const Size(400, 120),
  );

  goldenTest(
    'gamification',
    () => const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: LevelBadge(level: 4, title: 'Beginner')),
            StreakFlame(weeks: 3, label: '3-week streak'),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        XpBar(value: 0.6, label: '480 / 800 XP'),
        SizedBox(height: AppSpacing.md),
        StreakFlame(weeks: 0, label: 'No streak yet'),
        SizedBox(height: AppSpacing.md),
        PrCard(
          exerciseName: 'Bench press',
          headline: 'Estimated max 82.5 kg',
          detail: 'was 80 kg',
          badge: 'New best',
        ),
      ],
    ),
    size: const Size(400, 420),
  );

  goldenTest(
    'trend_chart',
    () => const TrendChart(
      values: [60, 62.5, 62.5, 65, 67.5],
      semanticLabel: 'Estimated max 60 to 67.5 kg',
    ),
    size: const Size(400, 220),
  );

  goldenTest(
    'floating_nav_bar',
    () => Align(
      alignment: Alignment.bottomCenter,
      child: FloatingNavBar(
        selectedIndex: 1,
        onSelected: (_) {},
        destinations: const [
          FloatingNavDestination(
            icon: Symbols.exercise_rounded,
            label: 'Today',
          ),
          FloatingNavDestination(
            icon: Symbols.monitoring_rounded,
            label: 'Progress',
          ),
          FloatingNavDestination(icon: Symbols.person_rounded, label: 'You'),
        ],
      ),
    ),
    size: const Size(400, 120),
  );
}
