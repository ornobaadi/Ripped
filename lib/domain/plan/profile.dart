import 'package:ripped/domain/catalog/exercise.dart';

enum Goal { strength, muscle, fitness, fatLoss, mobility }

enum Experience {
  beginner,
  intermediate,
  advanced;

  /// Highest catalog level this experience may be given.
  Level get maxLevel => switch (this) {
    beginner => Level.beginner,
    intermediate => Level.intermediate,
    advanced => Level.expert,
  };
}

enum Units { kg, lb }

/// Answers from onboarding (PRD 7.1). Every field has a sensible default
/// so any step can be skipped.
class TrainingProfile {
  const new({
    this.goal = Goal.muscle,
    this.experience = Experience.beginner,
    this.equipment = const {Equipment.gym},
    this.daysPerWeek = 3,
    this.preferredDays = const {},
    this.sessionMinutes = 45,
    this.avoid = const {},
    this.units = Units.kg,
  }) : assert(daysPerWeek >= 2 && daysPerWeek <= 6, 'days per week 2-6');

  final Goal goal;
  final Experience experience;
  final Set<Equipment> equipment;
  final int daysPerWeek;

  /// ISO weekdays (1 = Monday). Empty = use the default spread.
  final Set<int> preferredDays;
  final int sessionMinutes;
  final Set<Joint> avoid;
  final Units units;

  /// Training weekdays: preferred days if they match the count, else a
  /// spread that leaves recovery gaps.
  List<int> get trainingDays {
    if (preferredDays.length == daysPerWeek) {
      return preferredDays.toList()..sort();
    }
    return switch (daysPerWeek) {
      2 => const [1, 4],
      3 => const [1, 3, 5],
      4 => const [1, 2, 4, 5],
      5 => const [1, 2, 3, 5, 6],
      _ => const [1, 2, 3, 4, 5, 6],
    };
  }

  TrainingProfile copyWith({
    Goal? goal,
    Experience? experience,
    Set<Equipment>? equipment,
    int? daysPerWeek,
    Set<int>? preferredDays,
    int? sessionMinutes,
    Set<Joint>? avoid,
    Units? units,
  }) => TrainingProfile(
    goal: goal ?? this.goal,
    experience: experience ?? this.experience,
    equipment: equipment ?? this.equipment,
    daysPerWeek: daysPerWeek ?? this.daysPerWeek,
    preferredDays: preferredDays ?? this.preferredDays,
    sessionMinutes: sessionMinutes ?? this.sessionMinutes,
    avoid: avoid ?? this.avoid,
    units: units ?? this.units,
  );
}
