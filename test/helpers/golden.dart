import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/l10n/l10n.dart';

/// Every component is captured in light, dark, and dark at 200% text
/// (design.md 6).
enum GoldenVariant {
  light(textScale: 1),
  dark(textScale: 1),
  darkLargeText(textScale: 2);

  new({required this.textScale});
  final double textScale;
}

/// Wraps [child] in theme + localization, the same way the app does.
Widget wrapForTest(Widget child, {GoldenVariant variant = GoldenVariant.dark}) {
  final theme = variant == GoldenVariant.light
      ? AppTheme.light()
      : AppTheme.dark();
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: theme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(variant.textScale)),
        child: Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}

/// Registers one golden test per [GoldenVariant] for [name].
void goldenTest(
  String name,
  Widget Function() build, {
  Size size = const Size(400, 400),
}) {
  for (final variant in GoldenVariant.values) {
    testWidgets('$name (${variant.name})', tags: ['golden'], (tester) async {
      tester.view
        ..physicalSize = Size(size.width, size.height * variant.textScale)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(wrapForTest(build(), variant: variant));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/${name}_${variant.name}.png'),
      );
    });
  }
}
