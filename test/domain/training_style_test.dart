import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/domain/catalog/exercise.dart';
import 'package:ripped/domain/plan/plan.dart';
import 'package:ripped/domain/plan/plan_generator.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/domain/plan/training_style.dart';

import '../helpers/catalog.dart';

void main() {
  final catalog = realCatalog();
  final byId = {for (final e in catalog) e.id: e};
  final generator = PlanGenerator(catalog);
  // The default profile trains in a full gym.
  const gym = TrainingProfile(
    daysPerWeek: 5,
    sessionMinutes: 60,
    experience: Experience.intermediate,
  );

  group('choosing a style', () {
    test("options start with the coach's pick, fit, and all differ", () {
      for (var days = 2; days <= 6; days++) {
        final options = PlanGenerator.styleOptions(days);
        expect(options.first, TrainingStyle.auto);
        expect(options.every((s) => s.fits(days)), isTrue);
        final weeks = {
          for (final s in options) PlanGenerator.dayNames(s, days).join('|'),
        };
        expect(weeks.length, options.length, reason: '$days days');
      }
      expect(
        PlanGenerator.styleOptions(2),
        isNot(contains(TrainingStyle.bodyPart)),
      );
      expect(PlanGenerator.styleOptions(5), contains(TrainingStyle.bodyPart));
    });

    test('unknown stored values mean auto', () {
      expect(TrainingStyle.parse('bodyPart'), TrainingStyle.bodyPart);
      expect(TrainingStyle.parse('nonsense'), TrainingStyle.auto);
      expect(TrainingStyle.parse(null), TrainingStyle.auto);
    });
  });

  group('day names', () {
    test('body-part week is the classic five', () {
      expect(PlanGenerator.dayNames(TrainingStyle.bodyPart, 5), [
        'Chest',
        'Back',
        'Legs',
        'Shoulders',
        'Arms',
      ]);
      expect(PlanGenerator.dayNames(TrainingStyle.bodyPart, 3), [
        'Chest & Back',
        'Legs & Core',
        'Shoulders & Arms',
      ]);
    });

    test('upper / lower alternates', () {
      expect(PlanGenerator.dayNames(TrainingStyle.upperLower, 4), [
        'Upper A',
        'Lower A',
        'Upper B',
        'Lower B',
      ]);
      expect(PlanGenerator.dayNames(TrainingStyle.upperLower, 2), [
        'Upper',
        'Lower',
      ]);
    });

    test('push pull legs', () {
      expect(PlanGenerator.dayNames(TrainingStyle.pushPullLegs, 3), [
        'Push',
        'Pull',
        'Legs',
      ]);
    });

    test('auto matches the default plan', () {
      for (var days = 2; days <= 6; days++) {
        expect(
          PlanGenerator.dayNames(TrainingStyle.auto, days),
          generator
              .generate(gym.copyWith(daysPerWeek: days))
              .days
              .map((d) => d.name),
        );
      }
    });
  });

  group('generated plans', () {
    test('every style and day count gives full, valid days', () {
      for (final style in TrainingStyle.values) {
        for (var days = 2; days <= 6; days++) {
          final plan = generator.generate(
            gym.copyWith(daysPerWeek: days),
            style: style,
          );
          expect(plan.days, hasLength(days), reason: '$style $days');
          for (final day in plan.days) {
            expect(
              day.exercises.length,
              greaterThanOrEqualTo(3),
              reason: '$style $days ${day.name}',
            );
            final ids = day.exercises.map((e) => e.exerciseId);
            expect(ids.toSet().length, ids.length, reason: day.name);
          }
        }
      }
    });

    test('a style that does not fit falls back to the default', () {
      final plan = generator.generate(
        gym.copyWith(daysPerWeek: 2),
        style: TrainingStyle.bodyPart,
      );
      expect(plan.split, SplitType.fullBody);
    });

    test('chest day is mostly chest; leg day has no pressing', () {
      final plan = generator.generate(gym, style: TrainingStyle.bodyPart);
      expect(plan.split, SplitType.bodyPart);
      final chest = plan.days.first.exercises
          .map((e) => byId[e.exerciseId]!)
          .toList();
      expect(
        chest.where((e) => e.pattern == MovementPattern.horizontalPush).length,
        greaterThanOrEqualTo(3),
      );
      final legs = plan.days[2].exercises.map((e) => byId[e.exerciseId]!);
      expect(
        legs.where(
          (e) =>
              e.pattern == MovementPattern.horizontalPush ||
              e.pattern == MovementPattern.verticalPush,
        ),
        isEmpty,
      );
    });

    test('still respects equipment and joints', () {
      const home = TrainingProfile(
        equipment: {Equipment.bodyweight, Equipment.dumbbells},
        daysPerWeek: 4,
        avoid: {Joint.knee},
      );
      final plan = generator.generate(home, style: TrainingStyle.bodyPart);
      for (final e in plan.days.expand((d) => d.exercises)) {
        final ex = byId[e.exerciseId]!;
        expect(hasAccess(home.equipment, ex.equipment), isTrue);
        expect(ex.jointStress, isNot(contains(Joint.knee)));
      }
    });
  });

  group('building one day from body parts', () {
    test('chest and shoulders share the day', () {
      final day = generator.buildDay({BodyPart.shoulders, BodyPart.chest}, gym);
      expect(day.name, 'Chest & Shoulders');
      final patterns = day.exercises
          .map((e) => byId[e.exerciseId]!.pattern)
          .toSet();
      expect(patterns, contains(MovementPattern.horizontalPush));
      expect(patterns, contains(MovementPattern.verticalPush));
    });

    test('avoids exercises used on other days when it can', () {
      final first = generator.buildDay({BodyPart.back}, gym);
      final used = first.exercises.map((e) => e.exerciseId).toSet();
      final second = generator.buildDay({BodyPart.back}, gym, avoid: used);
      final overlap = second.exercises
          .map((e) => e.exerciseId)
          .where(used.contains);
      expect(overlap.length, lessThan(first.exercises.length));
    });

    test('is deterministic and never empty', () {
      for (final part in BodyPart.values) {
        final a = generator.buildDay({part}, gym);
        final b = generator.buildDay({part}, gym);
        expect(
          a.exercises.map((e) => e.exerciseId),
          b.exercises.map((e) => e.exerciseId),
        );
        expect(a.exercises, isNotEmpty);
        expect(a.name, PlanGenerator.partName(part));
      }
      expect(generator.buildDay({}, gym).exercises, isNotEmpty);
    });
  });
}
