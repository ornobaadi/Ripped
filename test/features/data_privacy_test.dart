import 'dart:convert';

import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/catalog/catalog_repository.dart';
import 'package:ripped/core/db/app_database.dart';
import 'package:ripped/core/notifications/reminder_service.dart';
import 'package:ripped/domain/plan/plan_generator.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/features/plan/data/program_repository.dart';
import 'package:ripped/features/settings/data/export_service.dart';
import 'package:ripped/features/settings/presentation/data_privacy_tiles.dart';
import 'package:ripped/features/workout/data/workout_repository.dart';

import '../helpers/catalog.dart';
import '../helpers/golden.dart';
import 'account_card_test.dart' show FakeAuth;

class FakeReminders implements ReminderScheduler {
  int cancels = 0;

  @override
  Future<void> cancelAll() async => cancels++;

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> replace(List<PlannedNotification> notifications) async {}
}

void main() {
  late AppDatabase db;
  final catalog = CatalogRepository(realCatalog());

  setUp(() => db = AppDatabase(DatabaseConnection(NativeDatabase.memory())));
  tearDown(() => db.close());

  Future<void> seedOneWorkout() async {
    final programs = ProgramRepository(db);
    final workouts = WorkoutRepository(db, catalog);
    await programs.saveProfile(const TrainingProfile(), onboardingDone: true);
    await programs.saveProgram(
      PlanGenerator(catalog.all).generate(const TrainingProfile()),
    );
    final day = (await programs.activeProgram())!.days.first;
    final id = await workouts.startWorkout(day);
    final w = (await workouts.workout(id))!;
    for (final s in w.exercises.first.sets) {
      await workouts.editSet(s.id, weightKg: 60, reps: 8, log: true);
    }
    await workouts.finishWorkout(id, units: Units.kg);
  }

  group('export', () {
    test('JSON has every synced table and UTC timestamps', () async {
      await seedOneWorkout();
      final json = await ExportService(db, catalog).buildJson();
      final tables = json['tables']! as Map<String, Object?>;
      expect(tables.keys, containsAll(AppDatabase.syncedTables));
      final workout = (tables['workouts']! as List).single as Map;
      expect(workout['started_at'], endsWith('Z'));
      expect(workout.containsKey('user_id'), isFalse);
      // Round-trips as valid JSON.
      expect(() => jsonEncode(json), returnsNormally);
    });

    test('CSV lists each logged set with the exercise name', () async {
      await seedOneWorkout();
      final csv = await ExportService(db, catalog).buildSetsCsv();
      final lines = csv.trim().split('\n');
      expect(lines.first, 'date,workout,exercise,set,weight_kg,reps');
      expect(lines.length, greaterThan(1));
      expect(lines[1], contains('Barbell back squat'));
      expect(lines[1], endsWith('60.0,8'));
    });
  });

  test('wipeAll clears every table and the outbox', () async {
    await seedOneWorkout();
    expect(await db.select(db.syncOutbox).get(), isNotEmpty);
    await db.wipeAll();
    for (final t in AppDatabase.syncedTables) {
      final n = await db
          .customSelect('SELECT COUNT(*) AS n FROM $t')
          .getSingle();
      expect(n.read<int>('n'), 0, reason: t);
    }
    expect(await db.select(db.syncOutbox).get(), isEmpty);
  });

  testWidgets('delete account: confirm, server delete, local wipe', (
    tester,
  ) async {
    final auth = FakeAuth();
    final reminders = FakeReminders();
    await tester.runAsync(() async {
      await seedOneWorkout();
      await auth.signInWithGoogle();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            catalogProvider.overrideWithValue(catalog),
            authServiceProvider.overrideWithValue(auth),
            reminderSchedulerProvider.overrideWithValue(reminders),
          ],
          child: wrapForTest(const DataPrivacyTiles()),
        ),
      );
      await _settle(tester);

      await tester.tap(find.text('Delete account'));
      await _settle(tester);
      expect(find.text('Delete your account?'), findsOneWidget);
      await tester.tap(find.text('Delete forever'));
      await _settle(tester, frames: 20);

      expect(auth.deletions, 1);
      expect(reminders.cancels, 1);
      expect(await db.select(db.workouts).get(), isEmpty);
      expect(await db.select(db.profiles).get(), isEmpty);
      await tester.pumpWidget(const SizedBox());
      await _settle(tester, frames: 3);
    });
  });

  testWidgets('delete is hidden when signed out', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          catalogProvider.overrideWithValue(catalog),
          authServiceProvider.overrideWithValue(FakeAuth()),
        ],
        child: wrapForTest(const DataPrivacyTiles()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Export my data'), findsOneWidget);
    expect(find.text('Delete account'), findsNothing);
  });
}

Future<void> _settle(WidgetTester tester, {int frames = 10}) async {
  for (var i = 0; i < frames; i++) {
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await tester.pump(const Duration(milliseconds: 50));
  }
}
