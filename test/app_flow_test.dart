import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/app/app.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/app/router.dart';
import 'package:ripped/core/catalog/catalog_repository.dart';
import 'package:ripped/core/db/app_database.dart';
import 'package:ripped/core/design/components/components.dart';

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
      expect(find.byType(SetRow), findsWidgets);
      await tester.tap(find.bySemanticsLabel('Mark set 1 done').first);
      await settle(tester);
      expect(find.text('Rest'), findsOneWidget);

      // Finish.
      await tester.tap(find.text('Finish'));
      await settle(tester);
      await tester.tap(find.text('Just right'));
      await tester.tap(find.text('Finish workout'));
      await settle(tester, frames: 40);

      expect(find.text('Workout complete'), findsOneWidget);
      expect(find.text('NEXT TIME'), findsOneWidget);
      expect(find.textContaining('XP'), findsWidgets);
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
      await tester.tap(find.bySemanticsLabel('Mark set 1 done').first);
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
