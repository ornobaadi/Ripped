import 'package:ripped/domain/progression/progression_engine.dart';

/// One logged set of a completed workout.
class SetLog {
  const new({required this.exerciseId, required this.reps, this.weightKg});

  final String exerciseId;
  final int reps;
  final double? weightKg;

  double get volumeKg => (weightKg ?? 0) * reps;
}

/// A completed workout with everything that was logged in it. The single
/// input for achievements, recaps, muscle balance and recovery advice.
class SessionLog {
  const new({
    required this.id,
    required this.startedAt,
    required this.sets,
    this.duration = Duration.zero,
    this.feeling,
  });

  final String id;
  final DateTime startedAt;
  final Duration duration;
  final Feeling? feeling;
  final List<SetLog> sets;

  double get volumeKg => sets.fold(0, (sum, s) => sum + s.volumeKg);
  int get reps => sets.fold(0, (sum, s) => sum + s.reps);
}
