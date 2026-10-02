import 'package:meta/meta.dart';
import 'package:ripped/domain/progression/progression_engine.dart';

enum PrType {
  /// Best estimated one-rep max.
  e1rm,

  /// Most reps at a given (or heavier) weight.
  reps,

  /// Most total weight x reps in one session.
  volume,
}

@immutable
class PersonalRecord {
  const new({
    required this.exerciseId,
    required this.type,
    required this.value,
    required this.previous,
    required this.weightKg,
    required this.reps,
  });

  final String exerciseId;
  final PrType type;

  /// e1RM kg, reps, or volume kg.
  final double value;
  final double previous;

  /// The set that set the record (volume PRs: the heaviest set).
  final double weightKg;
  final int reps;

  @override
  bool operator ==(Object other) =>
      other is PersonalRecord &&
      other.exerciseId == exerciseId &&
      other.type == type &&
      other.value == value &&
      other.previous == previous;

  @override
  int get hashCode => Object.hash(exerciseId, type, value, previous);

  @override
  String toString() => 'PR(${type.name} $exerciseId: $previous -> $value)';
}

/// PR detection (architecture.md 6.5). Only loaded sets count; the first
/// session with an exercise is a baseline, not a wall of PRs.
abstract final class Records {
  /// Epley, trusted up to 12 reps.
  static double? e1rm(double weightKg, int reps) {
    if (reps <= 0 || reps > 12 || weightKg <= 0) return null;
    if (reps == 1) return weightKg;
    return weightKg * (1 + reps / 30);
  }

  static List<PersonalRecord> detect({
    required String exerciseId,
    required List<List<SetResult>> previousSessions,
    required List<SetResult> session,
  }) {
    final prior = [
      for (final s in previousSessions)
        s.where((x) => (x.weightKg ?? 0) > 0 && x.reps > 0).toList(),
    ].where((s) => s.isNotEmpty).toList();
    final now = session
        .where((x) => (x.weightKg ?? 0) > 0 && x.reps > 0)
        .toList();
    if (prior.isEmpty || now.isEmpty) return const [];

    final records = <PersonalRecord>[];
    final allPrior = prior.expand((s) => s).toList();

    // e1RM
    double best(Iterable<SetResult> sets) => sets
        .map((s) => e1rm(s.weightKg!, s.reps) ?? 0)
        .fold(0, (a, b) => b > a ? b : a);
    final oldE1rm = best(allPrior);
    final top = now.reduce(
      (a, b) =>
          (e1rm(b.weightKg!, b.reps) ?? 0) > (e1rm(a.weightKg!, a.reps) ?? 0)
          ? b
          : a,
    );
    final newE1rm = e1rm(top.weightKg!, top.reps) ?? 0;
    if (oldE1rm > 0 && newE1rm > oldE1rm + 0.01) {
      records.add(
        PersonalRecord(
          exerciseId: exerciseId,
          type: PrType.e1rm,
          value: _round(newE1rm),
          previous: _round(oldE1rm),
          weightKg: top.weightKg!,
          reps: top.reps,
        ),
      );
    }

    // Rep PR: more reps than ever at this weight or heavier.
    PersonalRecord? repPr;
    for (final s in now) {
      final comparable = allPrior.where((p) => p.weightKg! >= s.weightKg!);
      if (comparable.isEmpty) continue;
      final previousBest = comparable
          .map((p) => p.reps)
          .reduce((a, b) => a > b ? a : b);
      if (s.reps > previousBest &&
          (repPr == null || s.weightKg! > repPr.weightKg)) {
        repPr = PersonalRecord(
          exerciseId: exerciseId,
          type: PrType.reps,
          value: s.reps.toDouble(),
          previous: previousBest.toDouble(),
          weightKg: s.weightKg!,
          reps: s.reps,
        );
      }
    }
    if (repPr != null) records.add(repPr);

    // Volume PR.
    double volume(List<SetResult> sets) =>
        sets.fold(0, (v, s) => v + s.weightKg! * s.reps);
    final oldVolume = prior.map(volume).reduce((a, b) => a > b ? a : b);
    final newVolume = volume(now);
    if (newVolume > oldVolume) {
      final heaviest = now.reduce((a, b) => b.weightKg! > a.weightKg! ? b : a);
      records.add(
        PersonalRecord(
          exerciseId: exerciseId,
          type: PrType.volume,
          value: _round(newVolume),
          previous: _round(oldVolume),
          weightKg: heaviest.weightKg!,
          reps: heaviest.reps,
        ),
      );
    }
    return records;
  }

  static double _round(double v) => (v * 10).round() / 10;
}

/// Flags a weekly volume jump big enough to risk recovery (architecture.md
/// 6.3 safety). Needs at least two previous weeks of data to judge.
abstract final class VolumeGuard {
  static const threshold = 1.3;

  static bool isSpike({
    required double thisWeekKg,
    required List<double> previousWeeksKg,
  }) {
    final prior = previousWeeksKg.where((v) => v > 0).toList();
    if (prior.length < 2) return false;
    final avg = prior.reduce((a, b) => a + b) / prior.length;
    return thisWeekKg > avg * threshold;
  }
}
