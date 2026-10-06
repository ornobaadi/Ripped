import 'package:ripped/domain/catalog/exercise.dart';
import 'package:ripped/domain/plan/plan.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/domain/plan/training_style.dart';

/// One position in a day template: a movement pattern, optionally narrowed
/// to a primary muscle (e.g. arm isolation for triceps).
class Slot {
  const new(this.pattern, [this.muscle]);

  final MovementPattern pattern;
  final String? muscle;
}

class _DayTemplate {
  const new(this.name, this.slots);

  final String name;

  /// Ordered by importance; short sessions keep the first N.
  final List<Slot> slots;
}

/// Deterministic, rules-based plan builder (architecture.md 6.1).
/// Same catalog + profile always produces the same plan.
class PlanGenerator {
  new(List<Exercise> catalog) : _catalog = List.unmodifiable(catalog);

  /// Bump when rules change so existing plans are not silently altered.
  static const version = 1;

  final List<Exercise> _catalog;

  static const _fullBodyA = _DayTemplate('Full Body A', [
    Slot(MovementPattern.squat),
    Slot(MovementPattern.horizontalPush),
    Slot(MovementPattern.horizontalPull),
    Slot(MovementPattern.hinge),
    Slot(MovementPattern.verticalPush),
    Slot(MovementPattern.coreAntiExtension),
    Slot(MovementPattern.isolationArm, 'biceps'),
    Slot(MovementPattern.calf),
  ]);

  static const _fullBodyB = _DayTemplate('Full Body B', [
    Slot(MovementPattern.hinge),
    Slot(MovementPattern.verticalPush),
    Slot(MovementPattern.verticalPull),
    Slot(MovementPattern.lunge),
    Slot(MovementPattern.horizontalPush),
    Slot(MovementPattern.coreRotation),
    Slot(MovementPattern.isolationArm, 'triceps'),
    Slot(MovementPattern.isolationLeg, 'hamstrings'),
  ]);

  static const _fullBodyC = _DayTemplate('Full Body C', [
    Slot(MovementPattern.lunge),
    Slot(MovementPattern.horizontalPush),
    Slot(MovementPattern.horizontalPull),
    Slot(MovementPattern.squat),
    Slot(MovementPattern.verticalPull),
    Slot(MovementPattern.coreAntiExtension),
    Slot(MovementPattern.isolationArm, 'shoulders'),
    Slot(MovementPattern.calf),
  ]);

  static const _upperSlots = [
    Slot(MovementPattern.horizontalPush),
    Slot(MovementPattern.horizontalPull),
    Slot(MovementPattern.verticalPush),
    Slot(MovementPattern.verticalPull),
    Slot(MovementPattern.isolationArm, 'biceps'),
    Slot(MovementPattern.isolationArm, 'triceps'),
    Slot(MovementPattern.isolationArm, 'shoulders'),
  ];

  static const _lowerSlots = [
    Slot(MovementPattern.squat),
    Slot(MovementPattern.hinge),
    Slot(MovementPattern.lunge),
    Slot(MovementPattern.isolationLeg, 'hamstrings'),
    Slot(MovementPattern.calf),
    Slot(MovementPattern.coreAntiExtension),
    Slot(MovementPattern.coreRotation),
  ];

  static const _push = _DayTemplate('Push', [
    Slot(MovementPattern.horizontalPush),
    Slot(MovementPattern.verticalPush),
    Slot(MovementPattern.horizontalPush),
    Slot(MovementPattern.isolationArm, 'shoulders'),
    Slot(MovementPattern.isolationArm, 'triceps'),
    Slot(MovementPattern.coreAntiExtension),
    Slot(MovementPattern.isolationArm, 'triceps'),
  ]);

  static const _pull = _DayTemplate('Pull', [
    Slot(MovementPattern.verticalPull),
    Slot(MovementPattern.horizontalPull),
    Slot(MovementPattern.horizontalPull),
    Slot(MovementPattern.isolationArm, 'biceps'),
    Slot(MovementPattern.horizontalPull, 'shoulders'),
    Slot(MovementPattern.coreRotation),
    Slot(MovementPattern.isolationArm, 'biceps'),
  ]);

  static const _legs = _DayTemplate('Legs', [
    Slot(MovementPattern.squat),
    Slot(MovementPattern.hinge),
    Slot(MovementPattern.lunge),
    Slot(MovementPattern.isolationLeg, 'quadriceps'),
    Slot(MovementPattern.isolationLeg, 'hamstrings'),
    Slot(MovementPattern.calf),
    Slot(MovementPattern.coreAntiExtension),
  ]);

  /// [style] `auto` keeps the coach's default for the number of days.
  GeneratedPlan generate(
    TrainingProfile profile, {
    TrainingStyle style = TrainingStyle.auto,
  }) {
    final (split, templates) = _templatesForStyle(style, profile.daysPerWeek);
    final slotCount = slotsForMinutes(profile.sessionMinutes);
    final usedThisWeek = <String>{};

    final days = [
      for (final t in templates)
        PlanDay(
          name: t.name,
          exercises: _fillDay(
            _slotsFor(t, slotCount, profile.goal),
            [...t.slots.skip(slotCount), ..._backfill],
            slotCount,
            profile,
            usedThisWeek,
          ),
        ),
    ];

    return GeneratedPlan(
      name: _planName(split, profile.daysPerWeek),
      split: split,
      days: days,
      generatorVersion: version,
    );
  }

  /// Exercises that can replace [exerciseId] for this profile: same
  /// pattern, available equipment, allowed level, no avoided joints.
  /// Curated substitutes first, then by priority.
  List<Exercise> swapOptions(String exerciseId, TrainingProfile profile) {
    final current = _catalog.firstWhere((e) => e.id == exerciseId);
    final options = _catalog
        .where(
          (e) =>
              e.id != current.id &&
              e.pattern == current.pattern &&
              _allowed(e, profile),
        )
        .toList();
    int rank(Exercise e) {
      final i = current.substitutes.indexOf(e.id);
      return i == -1 ? 1000 - e.priority : i;
    }

    return options..sort((a, b) {
      final byRank = rank(a).compareTo(rank(b));
      return byRank != 0 ? byRank : a.id.compareTo(b.id);
    });
  }

  /// The day names a style produces, for previews ("Chest", "Back", ...).
  static List<String> dayNames(TrainingStyle style, int days) => [
    for (final t in _templatesForStyle(style, days).$2) t.name,
  ];

  /// Styles to offer for [days] a week: the coach's pick (`auto`) first,
  /// then every other style that fits and gives a different week.
  static List<TrainingStyle> styleOptions(int days) {
    final pick = dayNames(TrainingStyle.auto, days).join('|');
    return [
      TrainingStyle.auto,
      for (final s in TrainingStyle.values)
        if (s != TrainingStyle.auto &&
            s.fits(days) &&
            dayNames(s, days).join('|') != pick)
          s,
    ];
  }

  /// One day built around the chosen body parts, e.g. chest + shoulders.
  /// [avoid] holds exercises already used on other days, so the week stays
  /// varied where the catalog allows.
  PlanDay buildDay(
    Set<BodyPart> parts,
    TrainingProfile profile, {
    Set<String> avoid = const {},
  }) {
    final ordered = [
      for (final p in BodyPart.values)
        if (parts.contains(p)) p,
    ];
    final template = _partsDay(ordered.isEmpty ? BodyPart.values : ordered);
    final slotCount = slotsForMinutes(profile.sessionMinutes);
    return PlanDay(
      name: template.name,
      exercises: _fillDay(
        _slotsFor(template, slotCount, profile.goal),
        [...template.slots.skip(slotCount), ..._backfill],
        slotCount,
        profile,
        {...avoid},
      ),
    );
  }

  static String partName(BodyPart p) => switch (p) {
    BodyPart.chest => 'Chest',
    BodyPart.back => 'Back',
    BodyPart.shoulders => 'Shoulders',
    BodyPart.arms => 'Arms',
    BodyPart.legs => 'Legs',
    BodyPart.core => 'Core',
  };

  /// Each part's work in order of importance, with a short tail of
  /// supporting work so a single-part day is still a full session.
  static List<Slot> _partSlots(BodyPart p) => switch (p) {
    BodyPart.chest => const [
      Slot(MovementPattern.horizontalPush),
      Slot(MovementPattern.horizontalPush),
      Slot(MovementPattern.horizontalPush),
      Slot(MovementPattern.isolationArm, 'triceps'),
      Slot(MovementPattern.horizontalPush),
      Slot(MovementPattern.coreAntiExtension),
      Slot(MovementPattern.isolationArm, 'triceps'),
    ],
    BodyPart.back => const [
      Slot(MovementPattern.verticalPull),
      Slot(MovementPattern.horizontalPull),
      Slot(MovementPattern.verticalPull),
      Slot(MovementPattern.horizontalPull),
      Slot(MovementPattern.isolationArm, 'biceps'),
      Slot(MovementPattern.coreRotation),
      Slot(MovementPattern.isolationArm, 'biceps'),
    ],
    BodyPart.shoulders => const [
      Slot(MovementPattern.verticalPush),
      Slot(MovementPattern.isolationArm, 'shoulders'),
      Slot(MovementPattern.horizontalPull, 'shoulders'),
      Slot(MovementPattern.verticalPush),
      Slot(MovementPattern.isolationArm, 'shoulders'),
      Slot(MovementPattern.coreAntiExtension),
      Slot(MovementPattern.isolationArm, 'triceps'),
    ],
    BodyPart.arms => const [
      Slot(MovementPattern.isolationArm, 'biceps'),
      Slot(MovementPattern.isolationArm, 'triceps'),
      Slot(MovementPattern.isolationArm, 'biceps'),
      Slot(MovementPattern.isolationArm, 'triceps'),
      Slot(MovementPattern.isolationArm, 'forearms'),
      Slot(MovementPattern.isolationArm, 'biceps'),
      Slot(MovementPattern.isolationArm, 'triceps'),
    ],
    BodyPart.legs => _legs.slots,
    BodyPart.core => const [
      Slot(MovementPattern.coreAntiExtension),
      Slot(MovementPattern.coreRotation),
      Slot(MovementPattern.coreAntiExtension),
      Slot(MovementPattern.coreRotation),
      Slot(MovementPattern.carry),
      Slot(MovementPattern.coreAntiExtension),
      Slot(MovementPattern.coreRotation),
    ],
  };

  /// Takes turns between the parts so each gets its key lifts first.
  static _DayTemplate _partsDay(List<BodyPart> parts, [String? name]) {
    final lists = [for (final p in parts) _partSlots(p)];
    final slots = <Slot>[];
    for (var i = 0; i < 7; i++) {
      for (final l in lists) {
        if (i < l.length) slots.add(l[i]);
      }
    }
    return _DayTemplate(name ?? parts.map(partName).join(' & '), slots);
  }

  static const BodyPart _c = BodyPart.chest;
  static const BodyPart _b = BodyPart.back;
  static const BodyPart _s = BodyPart.shoulders;
  static const BodyPart _a = BodyPart.arms;
  static const BodyPart _l = BodyPart.legs;
  static const BodyPart _k = BodyPart.core;

  static (SplitType, List<_DayTemplate>) _templatesForStyle(
    TrainingStyle style,
    int days,
  ) {
    final d = days.clamp(2, 6);
    // A style that doesn't fit the day count falls back to the default.
    final s = style.fits(d) ? style : TrainingStyle.auto;
    switch (s) {
      case TrainingStyle.auto:
        return _templatesFor(d);
      case TrainingStyle.fullBody:
        const cycle = [_fullBodyA, _fullBodyB, _fullBodyC];
        return (
          SplitType.fullBody,
          [
            for (var i = 0; i < d; i++)
              if (i < 3)
                cycle[i]
              else
                _DayTemplate('Full Body ${'ABCDEF'[i]}', cycle[i % 3].slots),
          ],
        );
      case TrainingStyle.upperLower:
        const letters = 'ABC';
        final uppers = (d / 2).ceil();
        final lowers = d ~/ 2;
        return (
          SplitType.upperLower,
          [
            for (var i = 0; i < d; i++)
              if (i.isEven)
                _DayTemplate(
                  uppers == 1 ? 'Upper' : 'Upper ${letters[i ~/ 2]}',
                  _upperSlots,
                )
              else
                _DayTemplate(
                  lowers == 1 ? 'Lower' : 'Lower ${letters[i ~/ 2]}',
                  _lowerSlots,
                ),
          ],
        );
      case TrainingStyle.pushPullLegs:
        return (
          SplitType.pushPullLegs,
          switch (d) {
            3 => const [_push, _pull, _legs],
            4 => const [
              _push,
              _pull,
              _legs,
              _DayTemplate('Upper', _upperSlots),
            ],
            5 => const [
              _push,
              _pull,
              _legs,
              _DayTemplate('Upper', _upperSlots),
              _DayTemplate('Lower', _lowerSlots),
            ],
            _ => _templatesFor(6).$2,
          },
        );
      case TrainingStyle.bodyPart:
        return (
          SplitType.bodyPart,
          switch (d) {
            3 => [
              _partsDay(const [_c, _b]),
              _partsDay(const [_l, _k]),
              _partsDay(const [_s, _a]),
            ],
            4 => [
              _partsDay(const [_c, _s]),
              _partsDay(const [_b]),
              _partsDay(const [_l]),
              _partsDay(const [_a, _k]),
            ],
            5 => [
              _partsDay(const [_c]),
              _partsDay(const [_b]),
              _partsDay(const [_l]),
              _partsDay(const [_s]),
              _partsDay(const [_a]),
            ],
            _ => [
              _partsDay(const [_c]),
              _partsDay(const [_b]),
              _partsDay(const [_l]),
              _partsDay(const [_s]),
              _partsDay(const [_a]),
              _partsDay(const [_l, _k], 'Legs & Core B'),
            ],
          },
        );
    }
  }

  static int slotsForMinutes(int minutes) => switch (minutes) {
    <= 20 => 4,
    <= 30 => 5,
    <= 45 => 6,
    _ => 7,
  };

  static (SplitType, List<_DayTemplate>) _templatesFor(int days) =>
      switch (days) {
        2 => (SplitType.fullBody, [_fullBodyA, _fullBodyB]),
        3 => (SplitType.fullBody, [_fullBodyA, _fullBodyB, _fullBodyC]),
        4 => (
          SplitType.upperLower,
          const [
            _DayTemplate('Upper A', _upperSlots),
            _DayTemplate('Lower A', _lowerSlots),
            _DayTemplate('Upper B', _upperSlots),
            _DayTemplate('Lower B', _lowerSlots),
          ],
        ),
        5 => (
          SplitType.upperLowerPpl,
          const [
            _DayTemplate('Upper', _upperSlots),
            _DayTemplate('Lower', _lowerSlots),
            _push,
            _pull,
            _legs,
          ],
        ),
        _ => (
          SplitType.pushPullLegs,
          const [
            _push,
            _pull,
            _legs,
            _DayTemplate('Push B', _pushSlotsB),
            _DayTemplate('Pull B', _pullSlotsB),
            _DayTemplate('Legs B', _legsSlotsB),
          ],
        ),
      };

  static const _pushSlotsB = [
    Slot(MovementPattern.verticalPush),
    Slot(MovementPattern.horizontalPush),
    Slot(MovementPattern.horizontalPush),
    Slot(MovementPattern.isolationArm, 'triceps'),
    Slot(MovementPattern.isolationArm, 'shoulders'),
    Slot(MovementPattern.coreRotation),
    Slot(MovementPattern.isolationArm, 'triceps'),
  ];

  static const _pullSlotsB = [
    Slot(MovementPattern.horizontalPull),
    Slot(MovementPattern.verticalPull),
    Slot(MovementPattern.verticalPull),
    Slot(MovementPattern.isolationArm, 'biceps'),
    Slot(MovementPattern.horizontalPull, 'shoulders'),
    Slot(MovementPattern.coreAntiExtension),
    Slot(MovementPattern.isolationArm, 'forearms'),
  ];

  static const _legsSlotsB = [
    Slot(MovementPattern.hinge),
    Slot(MovementPattern.squat),
    Slot(MovementPattern.lunge),
    Slot(MovementPattern.isolationLeg, 'hamstrings'),
    Slot(MovementPattern.isolationLeg, 'glutes'),
    Slot(MovementPattern.calf),
    Slot(MovementPattern.coreRotation),
  ];

  List<Slot> _slotsFor(_DayTemplate t, int count, Goal goal) {
    final slots = t.slots.take(count).toList();
    switch (goal) {
      case Goal.fitness || Goal.fatLoss:
        // Finish with conditioning instead of the least important slot.
        slots[slots.length - 1] = const Slot(MovementPattern.conditioning);
      case Goal.mobility:
        // Open with a mobility drill.
        slots
          ..removeLast()
          ..insert(0, const Slot(MovementPattern.mobility));
      case Goal.strength || Goal.muscle:
        break;
    }
    return slots;
  }

  /// Used when equipment limits leave a day short (e.g. bodyweight-only
  /// upper days): work that needs no kit and fits any session.
  static const _backfill = [
    Slot(MovementPattern.coreAntiExtension),
    Slot(MovementPattern.coreRotation),
    Slot(MovementPattern.lunge),
    Slot(MovementPattern.carry),
    Slot(MovementPattern.conditioning),
    Slot(MovementPattern.mobility),
  ];

  List<PlannedExercise> _fillDay(
    List<Slot> slots,
    List<Slot> extras,
    int target,
    TrainingProfile profile,
    Set<String> usedThisWeek,
  ) {
    final usedToday = <String>{};
    final result = <PlannedExercise>[];
    final queue = [...slots, ...extras];
    for (final (i, slot) in queue.indexed) {
      // Extras only fill gaps left by the planned slots.
      if (i >= slots.length && result.length >= target) break;
      final pick =
          _pick(slot, profile, usedToday, usedThisWeek, matchMuscle: true) ??
          _pick(slot, profile, usedToday, usedThisWeek, matchMuscle: false);
      if (pick == null) continue;
      usedToday.add(pick.id);
      usedThisWeek.add(pick.id);
      result.add(
        PlannedExercise(
          exerciseId: pick.id,
          prescription: prescribe(pick, profile),
          reason: _reason(pick, profile),
        ),
      );
    }
    // Long rests (strength) can blow the time budget: drop the least
    // important exercises until the day fits, keeping at least 3.
    final budget = profile.sessionMinutes * 1.15;
    while (result.length > 3 &&
        PlanDay(name: '', exercises: result).estimatedMinutes > budget) {
      usedThisWeek.remove(result.removeLast().exerciseId);
    }
    return result;
  }

  Exercise? _pick(
    Slot slot,
    TrainingProfile profile,
    Set<String> usedToday,
    Set<String> usedThisWeek, {
    required bool matchMuscle,
  }) {
    final candidates = _catalog.where((e) {
      if (e.pattern != slot.pattern) return false;
      if (usedToday.contains(e.id)) return false;
      if (matchMuscle &&
          slot.muscle != null &&
          !e.primaryMuscles.contains(slot.muscle)) {
        return false;
      }
      return _allowed(e, profile);
    }).toList();
    if (candidates.isEmpty) return null;

    int score(Exercise e) =>
        e.priority -
        (usedThisWeek.contains(e.id) ? 1000 : 0) -
        _experiencePenalty(e, profile.experience);

    candidates.sort((a, b) {
      final byScore = score(b).compareTo(score(a));
      return byScore != 0 ? byScore : a.id.compareTo(b.id);
    });
    return candidates.first;
  }

  /// Beginners get simpler lifts first; advanced lifters aren't penalised.
  int _experiencePenalty(Exercise e, Experience experience) =>
      switch (experience) {
        Experience.beginner => e.level == Level.beginner ? 0 : 15,
        _ => 0,
      };

  bool _allowed(Exercise e, TrainingProfile profile) =>
      hasAccess(profile.equipment, e.equipment) &&
      e.level.index <= profile.experience.maxLevel.index &&
      e.jointStress.intersection(profile.avoid).isEmpty;

  /// Goal x experience x exercise type (architecture.md 6.1 step 5).
  static Prescription prescribe(Exercise e, TrainingProfile profile) {
    final exp = profile.experience;
    final beginner = exp == Experience.beginner;

    if (e.isTimed) {
      return switch (e.pattern) {
        MovementPattern.conditioning => const Prescription(
          sets: 1,
          repMin: 300,
          repMax: 600,
          restSeconds: 0,
        ),
        MovementPattern.mobility => const Prescription(
          sets: 2,
          repMin: 30,
          repMax: 45,
          restSeconds: 15,
        ),
        MovementPattern.carry => const Prescription(
          sets: 3,
          repMin: 30,
          repMax: 45,
          restSeconds: 90,
        ),
        _ => Prescription(
          sets: 3,
          repMin: beginner ? 20 : 30,
          repMax: beginner ? 40 : 60,
          restSeconds: 60,
        ),
      };
    }

    if (e.pattern == MovementPattern.coreAntiExtension ||
        e.pattern == MovementPattern.coreRotation) {
      return const Prescription(
        sets: 3,
        repMin: 10,
        repMax: 15,
        restSeconds: 60,
      );
    }
    if (e.pattern == MovementPattern.mobility) {
      return const Prescription(
        sets: 2,
        repMin: 8,
        repMax: 12,
        restSeconds: 15,
      );
    }
    if (e.pattern == MovementPattern.conditioning) {
      return const Prescription(
        sets: 3,
        repMin: 8,
        repMax: 12,
        restSeconds: 60,
      );
    }

    final compound = e.pattern.isCompound;
    return switch (profile.goal) {
      Goal.strength when compound => Prescription(
        sets: switch (exp) {
          Experience.beginner => 3,
          Experience.intermediate => 4,
          Experience.advanced => 5,
        },
        repMin: beginner ? 5 : 4,
        repMax: beginner ? 8 : 6,
        restSeconds: beginner ? 150 : 180,
      ),
      Goal.strength => const Prescription(
        sets: 3,
        repMin: 8,
        repMax: 12,
        restSeconds: 90,
      ),
      Goal.muscle when compound => Prescription(
        sets: exp == Experience.advanced ? 4 : 3,
        repMin: 8,
        repMax: 12,
        restSeconds: 120,
      ),
      Goal.muscle => const Prescription(
        sets: 3,
        repMin: 10,
        repMax: 15,
        restSeconds: 75,
      ),
      Goal.fitness ||
      Goal.fatLoss ||
      Goal.mobility when compound => Prescription(
        sets: beginner ? 2 : 3,
        repMin: 10,
        repMax: 15,
        restSeconds: 75,
      ),
      Goal.fitness || Goal.fatLoss || Goal.mobility => const Prescription(
        sets: 2,
        repMin: 12,
        repMax: 15,
        restSeconds: 60,
      ),
    };
  }

  String _reason(Exercise e, TrainingProfile profile) {
    final pattern = _patternLabel(e.pattern);
    final equipment = e.isBodyweight ? 'no equipment' : e.equipmentLabel;
    final level = switch (e.level) {
      Level.beginner => 'beginner-friendly',
      Level.intermediate => 'intermediate',
      Level.expert => 'advanced',
    };
    final parts = ['$pattern, $equipment, $level'];
    if (profile.avoid.isNotEmpty) parts.add('easy on the joints you flagged');
    return parts.join(' · ');
  }

  static String _patternLabel(MovementPattern p) => switch (p) {
    MovementPattern.squat => 'Squat pattern',
    MovementPattern.hinge => 'Hip hinge',
    MovementPattern.lunge => 'Single-leg work',
    MovementPattern.horizontalPush => 'Horizontal push',
    MovementPattern.verticalPush => 'Overhead push',
    MovementPattern.horizontalPull => 'Horizontal pull',
    MovementPattern.verticalPull => 'Vertical pull',
    MovementPattern.carry => 'Loaded carry',
    MovementPattern.coreAntiExtension => 'Core stability',
    MovementPattern.coreRotation => 'Rotational core',
    MovementPattern.calf => 'Calves',
    MovementPattern.isolationArm => 'Arm and shoulder accessory',
    MovementPattern.isolationLeg => 'Leg accessory',
    MovementPattern.conditioning => 'Conditioning finisher',
    MovementPattern.mobility => 'Mobility',
  };

  static String _planName(SplitType split, int days) => switch (split) {
    SplitType.fullBody => 'Full Body · $days days',
    SplitType.upperLower => 'Upper / Lower · $days days',
    SplitType.upperLowerPpl => 'Upper / Lower + PPL · $days days',
    SplitType.pushPullLegs => 'Push / Pull / Legs · $days days',
    SplitType.bodyPart => 'Body Part Split · $days days',
  };
}
