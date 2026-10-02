import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/catalog/exercise.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/l10n/l10n.dart';

/// Six questions, one per screen, every one skippable (design.md 3.1),
/// then the health disclaimer and plan generation.
class OnboardingScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _questionCount = 6;
  final _pages = PageController();
  int _page = 0;
  bool _building = false;
  late TrainingProfile _draft;

  @override
  void initState() {
    super.initState();
    // Re-running onboarding from settings starts from current answers.
    _draft = ref.read(profileRowProvider).value == null
        ? const TrainingProfile()
        : ref.read(profileProvider);
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
    setState(() => _building = true);
    final repo = ref.read(programRepositoryProvider);
    final plan = ref.read(planGeneratorProvider).generate(_draft);
    // Short, honest pause so the moment registers; the work is real.
    await Future.wait([
      repo.saveProfile(_draft, onboardingDone: true, disclaimerAccepted: true),
      repo.saveProgram(plan),
      Future<void>.delayed(const Duration(milliseconds: 900)),
    ]);
    // Training days may have changed: move reminders with them.
    final reminders = ref.read(remindersProvider).value;
    if (mounted && (reminders?.enabled ?? false)) {
      final l10n = context.l10n;
      await applyReminders(
        ref,
        reminders!,
        title: l10n.reminderTitle,
        body: l10n.reminderBody,
      );
    }
    if (mounted) context.go('/plan?onboarding=1');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (_building) return const _BuildingPlan();

    final steps = <Widget>[
      _GoalStep(_draft, _update),
      _ExperienceStep(_draft, _update),
      _EquipmentStep(_draft, _update),
      _DaysStep(_draft, _update),
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
                        icon: const Icon(Icons.arrow_back),
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
      (Goal.strength, l.goalStrength, l.goalStrengthSub, Icons.trending_up),
      (Goal.muscle, l.goalMuscle, l.goalMuscleSub, Icons.fitness_center),
      (Goal.fitness, l.goalFitness, l.goalFitnessSub, Icons.favorite_outline),
      (
        Goal.fatLoss,
        l.goalFatLoss,
        l.goalFatLossSub,
        Icons.local_fire_department_outlined,
      ),
      (
        Goal.mobility,
        l.goalMobility,
        l.goalMobilitySub,
        Icons.self_improvement,
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
              icon: Icons.fitness_center,
              selected: gym,
              onTap: () => update(p.copyWith(equipment: {Equipment.gym})),
            ),
            ChoiceCard(
              title: l.eqBodyweight,
              subtitle: l.eqBodyweightSub,
              icon: Icons.accessibility_new,
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
                Icons.health_and_safety_outlined,
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

class _BuildingPlan extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: 40,
              child: CircularProgressIndicator(strokeWidth: 3, color: c.accent),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              context.l10n.buildingPlan,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
