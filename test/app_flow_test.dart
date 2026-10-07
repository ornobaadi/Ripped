import 'package:drift/drift.dart' show DatabaseConnection, Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/app/app.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/app/router.dart';
import 'package:ripped/core/catalog/catalog_repository.dart';
import 'package:ripped/core/db/app_database.dart';
import 'package:ripped/core/db/settings_repository.dart';
import 'package:ripped/core/design/brand.dart';
import 'package:ripped/core/design/components/components.dart';
import 'package:ripped/features/onboarding/presentation/plan_building_view.dart';
import 'package:ripped/features/plan/data/program_repository.dart';

import 'helpers/catalog.dart';

/// The core loop end to end, offline, against a real (in-memory) database:
/// onboarding -> plan -> today -> workout -> finish -> summary -> today.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(DatabaseConnection(NativeDatabase.memory()));
  });

  tearDown(() => db.close());

  Future<void> pumpApp(WidgetTester tester, {bool onboarded = false}) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          catalogProvider.overrideWithValue(CatalogRepository(realCatalog())),
          initialOnboardedProvider.overrideWithValue(onboarded),
          planBuildPaceProvider.overrideWithValue(Duration.zero),
        ],
        child: const RippedApp(),
      ),
    );
    await settle(tester);
  }

  testWidgets('first run: onboarding, plan, workout, summary', (tester) async {
    await tester.runAsync(() async {
      await pumpApp(tester);

      // Onboarding: pick a goal, skip the rest, accept the disclaimer.
      expect(find.text("What's your main goal?"), findsOneWidget);
      await tester.tap(find.text('Get stronger'));
      await tester.tap(find.text('Skip'));
      await settle(tester);
      expect(find.text('Before you start'), findsOneWidget);
      await tester.tap(find.text('I understand'));
      await settle(tester, frames: 40);

      // Plan preview.
      expect(find.text('Your plan is ready'), findsOneWidget);
      await tester.tap(find.text('Looks good'));
      await settle(tester);

      // Today: workout or rest day depending on the weekday.
      final start = find.text('Start workout');
      if (start.evaluate().isEmpty) {
        await tester.tap(find.text('Train anyway'));
      } else {
        await tester.tap(start);
      }
      await settle(tester, frames: 30);

      // Active workout: log the first set with one tap.
      // Focus view: one set, one big button.
      expect(find.text('SET 1 OF 3'), findsOneWidget);
      expect(find.text('First set. Start steady.'), findsOneWidget);
      await tester.tap(find.text('Set 1 done'));
      await settle(tester);
      expect(find.text('REST'), findsOneWidget);
      expect(find.textContaining('Next: Set 2 of 3'), findsOneWidget);

      // Skipping rest brings up the next set.
      await tester.tap(find.text('Skip rest'));
      await settle(tester);
      expect(find.text('SET 2 OF 3'), findsOneWidget);
      expect(find.text('Set 2 done'), findsOneWidget);

      // Every set stays reachable: undo the first one from the sheet.
      await tester.tap(find.text('All sets'));
      await settle(tester);
      expect(find.byType(SetRow), findsNWidgets(3));
      await tester.tap(
        find.descendant(
          of: find.byType(SetRow).first,
          matching: find.byType(IconButton),
        ),
      );
      await settle(tester);
      await tester.tapAt(const Offset(180, 40));
      await settle(tester);
      expect(find.text('Set 1 done'), findsOneWidget);
      await tester.tap(find.text('Set 1 done'));
      await settle(tester);

      // Finish.
      await tester.tap(find.text('Finish'));
      await settle(tester);
      await tester.tap(find.text('Just right'));
      await tester.tap(find.text('Finish workout'));
      await settle(tester, frames: 40);

      expect(find.text('Workout complete'), findsOneWidget);
      // Badges earned depend on the time of day (night owl, early bird),
      // so scroll rather than assume what fits on screen.
      expect(find.textContaining('XP'), findsWidgets);
      await tester.drag(find.byType(ListView).first, const Offset(0, -600));
      await settle(tester);
      expect(find.text('NEXT TIME'), findsOneWidget);
      await tester.tap(find.text('Done'));
      await settle(tester);

      expect(find.text('Done for today'), findsOneWidget);
      await unmount(tester);
    });
  });

  testWidgets('every main screen passes accessibility guidelines', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    // Drift needs real async (runAsync); the contrast check uses runAsync
    // internally too, so each step runs on its own and audits run between.
    Future<void> step(Future<void> Function() body) => tester.runAsync(body);
    Future<void> audit(String screen) async {
      for (final g in [
        androidTapTargetGuideline,
        labeledTapTargetGuideline,
        textContrastGuideline,
      ]) {
        final result = await g.evaluate(tester);
        expect(result.passed, isTrue, reason: '$screen: ${result.reason}');
      }
    }

    await step(() => pumpApp(tester));
    await audit('onboarding');
    await step(() async {
      await tester.tap(find.text('Skip'));
      await settle(tester);
    });
    await audit('disclaimer');
    await step(() async {
      await tester.tap(find.text('I understand'));
      await settle(tester, frames: 40);
    });
    await audit('plan preview');
    await step(() async {
      await tester.tap(find.text('Looks good'));
      await settle(tester);
    });
    await audit('today');
    await step(() async {
      final start = find.text('Start workout');
      await tester.tap(
        start.evaluate().isEmpty ? find.text('Train anyway') : start,
      );
      await settle(tester, frames: 30);
    });
    await audit('active workout');
    await step(() async {
      await tester.tap(find.text('Set 1 done'));
      await settle(tester);
    });
    await audit('active workout resting');
    await step(() async {
      await tester.tap(find.text('Finish'));
      await settle(tester);
    });
    await audit('finish sheet');
    await step(() async {
      await tester.tap(find.text('Finish workout'));
      await settle(tester, frames: 60);
    });
    await audit('summary');
    await step(() async {
      await tester.tap(find.text('Done'));
      await settle(tester);
    });
    for (final tab in ['Progress', 'You']) {
      await step(() async {
        await tester.tap(navTab(tab));
        await settle(tester);
      });
      await audit(tab);
    }
    await step(() => unmount(tester));
    handle.dispose();
  });

  testWidgets('every tab reflows at 200% text', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.runAsync(() async {
      await pumpApp(tester);
      await tester.tap(find.text('Skip'));
      await settle(tester);
      await tester.tap(find.text('I understand'));
      await settle(tester, frames: 40);
      await tester.tap(find.text('Looks good'));
      await settle(tester);
      for (final tab in ['Progress', 'You', 'Today']) {
        await tester.tap(navTab(tab));
        await settle(tester);
      }
      // Any RenderFlex overflow above fails the test.
      await unmount(tester);
    });
  });

  testWidgets('theme and logo choices apply at once and are remembered', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await pumpApp(tester);
      await tester.tap(find.text('Skip'));
      await settle(tester);
      await tester.tap(find.text('I understand'));
      await settle(tester, frames: 40);
      await tester.tap(find.text('Looks good'));
      await settle(tester);
      await tester.tap(navTab('You'));
      await settle(tester);

      Brightness brightness() =>
          Theme.of(tester.element(find.text('Appearance').first)).brightness;
      expect(brightness(), Brightness.dark);

      await tester.tap(find.text('Appearance'));
      await settle(tester);
      await tester.tap(find.text('Light'));
      await settle(tester);
      expect(brightness(), Brightness.light);
      expect(await SettingsRepository(db).theme(), 'light');

      // Close the theme sheet. The logo colourway: saved, and shown at once.
      await tester.tapAt(const Offset(10, 10));
      await settle(tester);
      await tester.ensureVisible(find.text('Logo'));
      await tester.tap(find.text('Logo'));
      await settle(tester);
      await tester.tap(find.text('Chalk'));
      await settle(tester);
      expect(await SettingsRepository(db).watchLogo().first, BrandLogo.chalk);
      expect(
        tester.widgetList<BrandMark>(find.byType(BrandMark)).map((m) => m.logo),
        contains(BrandLogo.chalk),
      );
      await unmount(tester);
    });
  });

  testWidgets('the plan can be edited before accepting it', (tester) async {
    await tester.runAsync(() async {
      await pumpApp(tester);
      await tester.tap(find.text('Skip'));
      await settle(tester);
      await tester.tap(find.text('I understand'));
      await settle(tester, frames: 40);

      // Personal header from the answers.
      expect(find.text('BUILT FOR YOU'), findsOneWidget);
      expect(find.textContaining('days a week'), findsOneWidget);

      final before = (await ProgramRepository(db).activeProgram())!.days.first;
      await tester.tap(find.byTooltip('Edit plan'));
      await settle(tester);
      expect(find.text('Add exercise'), findsWidgets);

      // Remove the first exercise of the first day.
      final firstName = CatalogRepository(realCatalog())
          .byId(before.exercises.first.exerciseId)
          .name;
      final remove = find.byTooltip('Remove $firstName').first;
      await tester.ensureVisible(remove);
      await settle(tester);
      await tester.tap(remove);
      await settle(tester);
      final after = (await ProgramRepository(db).activeProgram())!.days.first;
      expect(after.exercises, hasLength(before.exercises.length - 1));

      // Change sets on what is now the first exercise.
      final nextName = CatalogRepository(realCatalog())
          .byId(after.exercises.first.exerciseId)
          .name;
      await tester.ensureVisible(find.text(nextName).first);
      await settle(tester);
      await tester.tap(find.text(nextName).first);
      await settle(tester);
      expect(find.text('Rest between sets'), findsOneWidget);
      await tester.tap(find.text('Save'));
      await settle(tester);

      await tester.tap(find.byTooltip('Done editing'));
      await settle(tester);
      expect(find.text('Looks good'), findsOneWidget);
      await unmount(tester);
    });
  });

  testWidgets('a missed workout can be skipped or another one picked', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await pumpApp(tester);
      await tester.tap(find.text('Skip'));
      await settle(tester);
      await tester.tap(find.text('I understand'));
      await settle(tester, frames: 40);
      await tester.tap(find.text('Looks good'));
      await settle(tester);

      // A brand-new plan has missed nothing.
      expect(find.textContaining('You missed'), findsNothing);

      // Pretend the plan is ten days old: with Mon/Wed/Fri there is
      // always a training day in the last three days.
      await db
          .update(db.programs)
          .write(
            ProgramsCompanion(
              startedAt: Value(
                DateTime.now().subtract(const Duration(days: 10)),
              ),
            ),
          );
      await settle(tester, frames: 25);
      expect(find.textContaining('You missed'), findsOneWidget);

      await tester.tap(find.text('Skip Full Body A'));
      await settle(tester, frames: 25);
      expect(find.textContaining('You missed'), findsNothing);
      final choices = await SettingsRepository(db).scheduleChoices();
      expect(choices.overrideFor(0), 1);
      expect(choices.missedHandled, isNotNull);
      await unmount(tester);
    });
  });

  testWidgets('history lists the finished workout', (tester) async {
    await tester.runAsync(() async {
      await pumpApp(tester);
      await tester.tap(find.text('Skip'));
      await settle(tester);
      await tester.tap(find.text('I understand'));
      await settle(tester, frames: 40);
      await tester.tap(find.text('Looks good'));
      await settle(tester);

      await tester.tap(navTab('Progress'));
      await settle(tester);
      // New in Phase 6: this week's recap and the achievements preview.
      expect(find.text('THIS WEEK'), findsOneWidget);
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
      await settle(tester);
      expect(find.text('0 of 32 earned'), findsOneWidget);
      expect(find.text('No workouts yet'), findsOneWidget);
      await unmount(tester);
    });
  });
}

/// Drift closes stream queries on a zero-length timer; let it fire before
/// the test ends.
Future<void> unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await settle(tester, frames: 3);
}

/// Pumps frames while letting real async work (sqlite) complete.
Future<void> settle(WidgetTester tester, {int frames = 15}) async {
  for (var i = 0; i < frames; i++) {
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/// A tab in the floating nav bar. Collapsed tabs keep a zero-width label,
/// so tap the whole tab, not its text.
Finder navTab(String label) => find
    .ancestor(
      of: find.descendant(
        of: find.byType(FloatingNavBar),
        matching: find.text(label),
      ),
      matching: find.byType(GestureDetector),
    )
    .first;
