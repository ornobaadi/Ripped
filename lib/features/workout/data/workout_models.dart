import 'package:ripped/core/db/tables.dart';
import 'package:ripped/domain/gamification/xp.dart';
import 'package:ripped/domain/progression/progression_engine.dart';
import 'package:ripped/domain/records/personal_records.dart';

class WorkoutSetView {
  const new({
    required this.id,
    required this.index,
    required this.reps,
    required this.targetReps,
    this.weightKg,
    this.completedAt,
  });

  final String id;
  final int index;
  final double? weightKg;
  final int reps;
  final int targetReps;
  final DateTime? completedAt;

  bool get done => completedAt != null;
}

class LastPerformance {
  const new({required this.date, required this.sets});

  final DateTime date;
  final List<SetResult> sets;
}

class WorkoutExerciseView {
  const new({
    required this.id,
    required this.exerciseId,
    required this.order,
    required this.repMin,
    required this.repMax,
    required this.restSeconds,
    required this.skipped,
    required this.sets,
    required this.firstTime,
    this.last,
  });

  final String id;
  final String exerciseId;
  final int order;
  final int repMin;
  final int repMax;
  final int restSeconds;
  final bool skipped;
  final List<WorkoutSetView> sets;

  /// No progression history yet: show the "find your weight" hint.
  final bool firstTime;

  /// Previous session with this exercise, for "last time" hints.
  final LastPerformance? last;

  bool get complete => skipped || sets.every((s) => s.done);
  int get doneSets => sets.where((s) => s.done).length;
}

class WorkoutView {
  const new({
    required this.id,
    required this.name,
    required this.status,
    required this.startedAt,
    required this.exercises,
    this.dayIndex,
    this.finishedAt,
    this.feeling,
  });

  final String id;
  final String name;
  final WorkoutStatus status;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final int? dayIndex;
  final Feeling? feeling;
  final List<WorkoutExerciseView> exercises;

  Iterable<WorkoutSetView> get _activeSets =>
      exercises.where((e) => !e.skipped).expand((e) => e.sets);

  int get totalSets => _activeSets.length;
  int get doneSets => _activeSets.where((s) => s.done).length;

  /// Sum of weight x reps over logged sets, kg.
  double get volumeKg => _activeSets
      .where((s) => s.done && s.weightKg != null)
      .fold(0, (v, s) => v + s.weightKg! * s.reps);

  Duration get duration => (finishedAt ?? DateTime.now()).difference(startedAt);

  /// Index of the first exercise with work left, else the last one.
  int get currentExerciseIndex {
    final i = exercises.indexWhere((e) => !e.complete);
    return i == -1 ? exercises.length - 1 : i;
  }
}

/// What changed for one exercise after a finished workout.
class ProgressionResult {
  const new({
    required this.exerciseId,
    required this.decision,
    required this.next,
  });

  final String exerciseId;
  final ProgressionDecision decision;
  final ExerciseProgress next;
}

class HistoryEntry {
  const new({
    required this.id,
    required this.name,
    required this.startedAt,
    required this.duration,
    required this.sets,
    required this.volumeKg,
  });

  final String id;
  final String name;
  final DateTime startedAt;
  final Duration duration;
  final int sets;
  final double volumeKg;
}

/// Everything that happened when a workout was finished, for the
/// celebration sequence (design.md 3.4).
class WorkoutOutcome {
  const new({
    required this.progression,
    required this.records,
    required this.xp,
    required this.levelBefore,
    required this.levelAfter,
    required this.streakBefore,
    required this.streakAfter,
    this.weekCompleted = false,
    this.comeback = false,
    this.volumeSpike = false,
  });

  static final empty = WorkoutOutcome(
    progression: const [],
    records: const [],
    xp: const [],
    levelBefore: Levels.fromTotal(0),
    levelAfter: Levels.fromTotal(0),
    streakBefore: 0,
    streakAfter: 0,
  );

  final List<ProgressionResult> progression;
  final List<PersonalRecord> records;
  final List<XpAward> xp;
  final LevelInfo levelBefore;
  final LevelInfo levelAfter;
  final int streakBefore;
  final int streakAfter;

  /// This workout hit the weekly target.
  final bool weekCompleted;

  /// First workout after two or more weeks away.
  final bool comeback;

  /// Weekly volume jumped more than 30%: suggest recovery.
  final bool volumeSpike;

  int get xpEarned => xp.fold(0, (s, a) => s + a.amount);
  bool get leveledUp => levelAfter.level > levelBefore.level;
}

/// One session of one exercise, for charts.
class ExerciseSession {
  const new({
    required this.date,
    required this.topWeightKg,
    required this.bestE1rm,
  });

  final DateTime date;
  final double topWeightKg;
  final double? bestE1rm;
}
