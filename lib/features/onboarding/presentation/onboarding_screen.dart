import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/analytics/analytics.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/catalog/exercise.dart';
import 'package:ripped/domain/plan/plan_generator.dart';
import 'package:ripped/domain/plan/plan_summary.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/domain/plan/training_style.dart';
import 'package:ripped/features/onboarding/presentation/plan_building_view.dart';
import 'package:ripped/features/plan/presentation/plan_labels.dart';
import 'package:ripped/l10n/l10n.dart';

/// Six questions, one per screen, every one skippable (design.md 3.1),
/// then the health disclaimer and plan generation.
class OnboardingScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _questionCount = 7;
  final _pages = PageController();
  int _page = 0;

  /// Set while the plan is being built and saved.
  PlanSummary? _building;
  late TrainingProfile _draft;
  TrainingStyle _style = TrainingStyle.auto;

  @override
  void initState() {
    super.initState();
    // Re-running onboarding from settings starts from current answers.
    _draft = ref.read(profileRowProvider).value == null
        ? const TrainingProfile()
        : ref.read(profileProvider);
    unawaited(_loadStyle());
  }

  /// Rebuilding a plan starts from the style chosen last time.
  Future<void> _loadStyle() async {
    final saved = await ref.read(settingsRepositoryProvider).planStyle();
    if (mounted && saved != null) {
      setState(() => _style = TrainingStyle.parse(saved));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ref.read(profileRowProvider).value == null) {
      final country = Localizations.localeOf(context).countryCode;
      final imperial = const {'US', 'LR', 'MM'}.contains(country);
      _draft = _draft.copyWith(units: imperial ? Units.lb : Units.kg);
    }
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _update(TrainingProfile p) => setState(() => _draft = p);

  Future<void> _next() async {
    if (_page < _questionCount) {
      await _pages.nextPage(
        duration: AppMotion.base,
        curve: AppMotion.baseCurve,
      );
    } else {
      await _finish();
    }
  }

  Future<void> _back() async {
    if (_page == 0) return;
    await _pages.previousPage(
      duration: AppMotion.base,
      curve: AppMotion.baseCurve,
    );
  }

  /// Skip jumps straight to the disclaimer with defaults for the rest.
  Future<void> _skip() => _pages.animateToPage(
    _questionCount,
    duration: AppMotion.base,
    curve: AppMotion.baseCurve,
  );

  Future<void> _finish() async {
    final repo = ref.read(programRepositoryProvider);
    final plan = ref
        .read(planGeneratorProvider)
        .generate(_draft, style: _style);
    final summary = PlanSummary.of(_draft, plan);
    final pace = ref.read(planBuildPaceProvider);
    final wait = PlanBuildingView.duration(
      summary.buildSteps(context.l10n).length,
      pace,
      still: MediaQuery.disableAnimationsOf(context),
    );
    setState(() => _building = summary);
    // The work is real; the view just gives the moment room to register.
    await Future.wait([
      repo.saveProfile(_draft, onboardingDone: true, disclaimerAccepted: true),
      repo.saveProgram(plan),
      ref.read(settingsRepositoryProvider).savePlanStyle(_style.name),
      Future<void>.delayed(wait),
    ]);
    ref.read(analyticsProvider).track(AnalyticsEvent.onboardingCompleted, {
      'goal': _draft.goal.name,
      'experience': _draft.experience.name,
      'days_per_week': _draft.daysPerWeek,
      'session_minutes': _draft.sessionMinutes,
    });
    // Training days may have changed: move reminders with them.
    await refreshNotifications(ref.container);
    if (mounted) context.go('/plan?onboarding=1');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (_building case final summary?) {
      return PlanBuildingView(summary: summary);
    }

    final steps = <Widget>[
      _GoalStep(_draft, _update),
      _ExperienceStep(_draft, _update),
      _EquipmentStep(_draft, _update),
      _DaysStep(_draft, _update),
      _SplitStep(_draft, _style, (s) => setState(() => _style = s)),
      _LengthStep(_draft, _update),
      _AvoidStep(_draft, _update),
      const _DisclaimerStep(),
    ];
    final onDisclaimer = _page == _questionCount;

    return PopScope(
      canPop: _page == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_back());
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: AppTapTargets.workout,
                child: Row(
                  children: [
                    if (_page > 0)
                      IconButton(
                        onPressed: _back,
                        tooltip: l10n.back,
                        icon: const Icon(Symbols.arrow_back_rounded),
                      )
                    else
                      const SizedBox(width: AppTapTargets.min),
                    Expanded(
                      child: _ProgressDots(
                        count: _questionCount + 1,
                        index: _page,
                      ),
                    ),
                    if (!onDisclaimer)
                      TextButton(onPressed: _skip, child: Text(l10n.skip))
                    else
                      const SizedBox(width: AppTapTargets.min),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pages,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (i) => setState(() => _page = i),
                  children: [
                    for (final s in steps)
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: s,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: onDisclaimer ? l10n.disclaimerAccept : l10n.next,
                    onPressed: _next,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const new({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ExcludeSemantics(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < count; i++)
            AnimatedContainer(
              duration: AppMotion.base,
              curve: AppMotion.baseCurve,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == index ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i <= index ? c.textPrimary : c.border,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
        ],
      ),
    );
  }
}

class _StepTitle extends StatelessWidget {
  const new(this.title, [this.hint]);

  final String title;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(header: true, child: Text(title, style: text.titleLarge)),
          if (hint != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              hint!,
              style: text.bodyLarge?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

typedef _Update = void Function(TrainingProfile);

class _Choices extends StatelessWidget {
  const new({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final (i, c) in children.indexed) ...[
        if (i > 0) const SizedBox(height: AppSpacing.md),
        c,
      ],
    ],
  );
}

class _GoalStep extends StatelessWidget {
  const new(this.p, this.update);

  final TrainingProfile p;
  final _Update update;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final options = [
      (
        Goal.strength,
        l.goalStrength,
        l.goalStrengthSub,
        Symbols.trending_up_rounded,
      ),
      (
        Goal.muscle,
        l.goalMuscle,
        l.goalMuscleSub,
        Symbols.fitness_center_rounded,
      ),
      (Goal.fitness, l.goalFitness, l.goalFitnessSub, Symbols.favorite_rounded),
      (
        Goal.fatLoss,
        l.goalFatLoss,
        l.goalFatLossSub,
        Symbols.local_fire_department_rounded,
      ),
      (
        Goal.mobility,
        l.goalMobility,
        l.goalMobilitySub,
        Symbols.self_improvement_rounded,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepTitle(l.onbGoalTitle),
        _Choices(
          children: [
            for (final (goal, title, sub, icon) in options)
              ChoiceCard(
                title: title,
                subtitle: sub,
                icon: icon,
                selected: p.goal == goal,
                onTap: () => update(p.copyWith(goal: goal)),
              ),
          ],
        ),
      ],
    );
  }
}

class _ExperienceStep extends StatelessWidget {
  const new(this.p, this.update);

  final TrainingProfile p;
  final _Update update;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final options = [
      (Experience.beginner, l.expBeginner, l.expBeginnerSub),
      (Experience.intermediate, l.expIntermediate, l.expIntermediateSub),
      (Experience.advanced, l.expAdvanced, l.expAdvancedSub),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepTitle(l.onbExperienceTitle),
        _Choices(
          children: [
            for (final (exp, title, sub) in options)
              ChoiceCard(
                title: title,
                subtitle: sub,
                selected: p.experience == exp,
                onTap: () => update(p.copyWith(experience: exp)),
              ),
          ],
        ),
      ],
    );
  }
}

class _EquipmentStep extends StatelessWidget {
  const new(this.p, this.update);

  final TrainingProfile p;
  final _Update update;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final gym = p.equipment.contains(Equipment.gym);
    final home = [
      (Equipment.dumbbells, l.eqDumbbells),
      (Equipment.kettlebells, l.eqKettlebells),
      (Equipment.bands, l.eqBands),
      (Equipment.pullUpBar, l.eqPullUpBar),
    ];
    final bodyweightOnly =
        p.equipment.isEmpty ||
        p.equipment.every((e) => e == Equipment.bodyweight);

    void toggle(Equipment e) {
      final next = {...p.equipment}
        ..remove(Equipment.gym)
        ..remove(Equipment.bodyweight);
      next.contains(e) ? next.remove(e) : next.add(e);
      update(
        p.copyWith(equipment: next.isEmpty ? {Equipment.bodyweight} : next),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepTitle(l.onbEquipmentTitle, l.onbEquipmentHint),
        _Choices(
          children: [
            ChoiceCard(
              title: l.eqGym,
              subtitle: l.eqGymSub,
              icon: Symbols.fitness_center_rounded,
              selected: gym,
              onTap: () => update(p.copyWith(equipment: {Equipment.gym})),
            ),
            ChoiceCard(
              title: l.eqBodyweight,
              subtitle: l.eqBodyweightSub,
              icon: Symbols.accessibility_new_rounded,
              selected: !gym && bodyweightOnly,
              onTap: () =>
                  update(p.copyWith(equipment: {Equipment.bodyweight})),
            ),
            for (final (e, title) in home)
              ChoiceCard(
                title: title,
                selected: !gym && p.equipment.contains(e),
                onTap: () => toggle(e),
              ),
          ],
        ),
      ],
    );
  }
}

class _DaysStep extends StatelessWidget {
  const new(this.p, this.update);

  final TrainingProfile p;
  final _Update update;

  static const _dayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final text = Theme.of(context).textTheme;
    final c = context.colors;
    final shown = p.trainingDays.toSet();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepTitle(l.onbDaysTitle, l.onbDaysHint),
        _Choices(
          children: [
            for (var d = 2; d <= 6; d++)
              ChoiceCard(
                title: l.daysPerWeek(d),
                selected: p.daysPerWeek == d,
                onTap: () =>
                    update(p.copyWith(daysPerWeek: d, preferredDays: {})),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(l.pickDays, style: text.labelLarge),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (var day = 1; day <= 7; day++)
              FilterChip(
                label: Text(_dayLetters[day - 1]),
                selected: shown.contains(day),
                showCheckmark: false,
                selectedColor: c.surfaceRaised,
                side: BorderSide(
                  color: shown.contains(day) ? c.accent : c.border,
                ),
                onSelected: (_) {
                  final picked = {...p.preferredDays};
                  picked.contains(day) ? picked.remove(day) : picked.add(day);
                  update(
                    p.copyWith(
                      preferredDays: picked,
                      daysPerWeek: picked.length.clamp(2, 6),
                    ),
                  );
                },
              ),
          ],
        ),
      ],
    );
  }
}

/// How the week is divided. The coach's pick comes first; every option
/// shows the week it would produce, so no gym vocabulary is needed.
class _SplitStep extends StatelessWidget {
  const new(this.p, this.style, this.onStyle);

  final TrainingProfile p;
  final TrainingStyle style;
  final ValueChanged<TrainingStyle> onStyle;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final options = PlanGenerator.styleOptions(p.daysPerWeek);
    // A style that no longer fits the day count shows as the coach's pick.
    final selected = options.contains(style) ? style : TrainingStyle.auto;
    final weekdays = p.trainingDays;

    // 1 January 2024 was a Monday.
    String weekday(int day) => DateFormat.E().format(DateTime(2024, 1, day));

    String week(TrainingStyle s) {
      final names = PlanGenerator.dayNames(s, p.daysPerWeek);
      return [
        for (final (i, name) in names.indexed)
          [weekday(weekdays[i % weekdays.length]), name].join(' '),
      ].join(' · ');
    }

    (String, String) words(TrainingStyle s) => switch (s) {
      TrainingStyle.auto => (l.styleAuto, l.styleAutoSub),
      TrainingStyle.fullBody => (l.styleFullBody, l.styleFullBodySub),
      TrainingStyle.upperLower => (l.styleUpperLower, l.styleUpperLowerSub),
      TrainingStyle.pushPullLegs => (l.stylePpl, l.stylePplSub),
      TrainingStyle.bodyPart => (l.styleBodyPart, l.styleBodyPartSub),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepTitle(l.onbSplitTitle, l.onbSplitHint),
        _Choices(
          children: [
            for (final s in options)
              ChoiceCard(
                title: words(s).$1,
                subtitle: '${words(s).$2}\n${week(s)}',
                selected: s == selected,
                onTap: () => onStyle(s),
              ),
          ],
        ),
      ],
    );
  }
}

class _LengthStep extends StatelessWidget {
  const new(this.p, this.update);

  final TrainingProfile p;
  final _Update update;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepTitle(l.onbLengthTitle),
        _Choices(
          children: [
            for (final m in const [20, 30, 45, 60])
              ChoiceCard(
                title: l.minutes(m),
                selected: p.sessionMinutes == m,
                onTap: () => update(p.copyWith(sessionMinutes: m)),
              ),
          ],
        ),
      ],
    );
  }
}

class _AvoidStep extends StatelessWidget {
  const new(this.p, this.update);

  final TrainingProfile p;
  final _Update update;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final options = [
      (Joint.knee, l.jointKnee),
      (Joint.lowerBack, l.jointLowerBack),
      (Joint.shoulder, l.jointShoulder),
      (Joint.wrist, l.jointWrist),
      (Joint.elbow, l.jointElbow),
      (Joint.hip, l.jointHip),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepTitle(l.onbAvoidTitle, l.onbAvoidHint),
        _Choices(
          children: [
            ChoiceCard(
              title: l.nothingToAvoid,
              selected: p.avoid.isEmpty,
              onTap: () => update(p.copyWith(avoid: {})),
            ),
            for (final (j, title) in options)
              ChoiceCard(
                title: title,
                selected: p.avoid.contains(j),
                onTap: () {
                  final next = {...p.avoid};
                  next.contains(j) ? next.remove(j) : next.add(j);
                  update(p.copyWith(avoid: next));
                },
              ),
          ],
        ),
      ],
    );
  }
}

class _DisclaimerStep extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepTitle(l.disclaimerTitle),
        AppCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Symbols.health_and_safety_rounded,
                color: context.colors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  l.disclaimerBody,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
