import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/domain/progression/progression_engine.dart';
import 'package:ripped/domain/records/personal_records.dart';

List<SetResult> s(double kg, List<int> reps) => [
  for (final r in reps) SetResult(weightKg: kg, reps: r),
];

void main() {
  group('e1RM', () {
    test('Epley for 2-12 reps, raw weight for singles', () {
      expect(Records.e1rm(100, 1), 100);
      expect(Records.e1rm(100, 10), closeTo(133.33, 0.01));
      expect(Records.e1rm(100, 13), isNull);
      expect(Records.e1rm(0, 5), isNull);
      expect(Records.e1rm(100, 0), isNull);
    });
  });

  group('detect', () {
    List<PersonalRecord> run(List<List<SetResult>> prev, List<SetResult> now) =>
        Records.detect(
          exerciseId: 'bench',
          previousSessions: prev,
          session: now,
        );

    test('first session is a baseline, not a PR', () {
      expect(run(const [], s(60, [8, 8, 8])), isEmpty);
    });

    test('heavier at the same reps is an e1RM and volume PR', () {
      final prs = run([
        s(60, [8, 8, 8]),
      ], s(62.5, [8, 8, 8]));
      final types = prs.map((p) => p.type).toSet();
      expect(types, {PrType.e1rm, PrType.volume});
      final e = prs.firstWhere((p) => p.type == PrType.e1rm);
      expect(e.weightKg, 62.5);
      expect(e.reps, 8);
      expect(e.value, greaterThan(e.previous));
    });

    test('more reps at the same weight is a rep PR', () {
      final prs = run([
        s(60, [8, 8]),
      ], s(60, [10, 7]));
      final rep = prs.firstWhere((p) => p.type == PrType.reps);
      expect(rep.value, 10);
      expect(rep.previous, 8);
    });

    test('reps at a weight never lifted before are not a rep PR', () {
      final prs = run([
        s(60, [8]),
      ], s(70, [5]));
      expect(prs.where((p) => p.type == PrType.reps), isEmpty);
    });

    test('the heaviest qualifying set wins the rep PR', () {
      final prs = run(
        [
          s(50, [10]),
          s(60, [6]),
        ],
        [
          ...s(50, [12]),
          ...s(60, [8]),
        ],
      );
      final rep = prs.singleWhere((p) => p.type == PrType.reps);
      expect(rep.weightKg, 60);
    });

    test('a weaker session sets no records', () {
      expect(
        run([
          s(60, [8, 8, 8]),
        ], s(60, [6, 6])),
        isEmpty,
      );
    });

    test('bodyweight sets are ignored', () {
      expect(
        run(
          [
            const [SetResult(reps: 10)],
          ],
          const [SetResult(reps: 15)],
        ),
        isEmpty,
      );
    });

    test('value semantics', () {
      const a = PersonalRecord(
        exerciseId: 'x',
        type: PrType.e1rm,
        value: 2,
        previous: 1,
        weightKg: 1,
        reps: 1,
      );
      expect(
        a,
        const PersonalRecord(
          exerciseId: 'x',
          type: PrType.e1rm,
          value: 2,
          previous: 1,
          weightKg: 1,
          reps: 1,
        ),
      );
      expect(a.hashCode, isNot(0));
      expect(a.toString(), contains('e1rm'));
    });
  });

  group('volume guard', () {
    test('flags a >30% jump over the recent average', () {
      expect(
        VolumeGuard.isSpike(thisWeekKg: 14000, previousWeeksKg: [10000, 10000]),
        isTrue,
      );
      expect(
        VolumeGuard.isSpike(thisWeekKg: 12000, previousWeeksKg: [10000, 10000]),
        isFalse,
      );
    });

    test('needs two weeks of history', () {
      expect(
        VolumeGuard.isSpike(thisWeekKg: 50000, previousWeeksKg: [10000, 0]),
        isFalse,
      );
    });
  });
}
