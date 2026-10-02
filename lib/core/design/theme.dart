import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ripped/core/design/tokens.dart';

/// Exposes [AppColors] through the widget tree: `context.colors.accent`.
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const new(this.colors);

  final AppColors colors;

  @override
  AppColorsExtension copyWith({AppColors? colors}) =>
      AppColorsExtension(colors ?? this.colors);

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) =>
      t < 0.5 ? this : (other ?? this);
}

extension AppThemeContext on BuildContext {
  AppColors get colors =>
      Theme.of(this).extension<AppColorsExtension>()!.colors;
}

abstract final class AppSystemUi {
  /// Transparent bars with light icons for the dark-first UI.
  static const overlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarContrastEnforced: false,
  );
}

abstract final class AppTheme {
  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);
  static ThemeData light() => _build(AppColors.light, Brightness.light);

  static const _tabular = [FontFeature.tabularFigures()];

  static TextStyle _style(
    double size,
    double lineHeight,
    Color color, {
    FontWeight weight = FontWeight.w400,
    String family = AppFonts.ui,
  }) => TextStyle(
    fontFamily: family,
    fontSize: size,
    height: lineHeight / size,
    fontWeight: weight,
    // Inter ships as a variable font; the axis must be set explicitly.
    fontVariations: family == AppFonts.ui
        ? [FontVariation.weight(weight.value.toDouble())]
        : null,
    color: color,
    fontFeatures: _tabular,
  );

  // Type scale from design.md 5.2. Display face for headings and big
  // numbers, UI face for everything else.
  static TextTheme _textTheme(Color c) => TextTheme(
    displayLarge: _style(
      40,
      44,
      c,
      weight: FontWeight.w700,
      family: AppFonts.display,
    ),
    titleLarge: _style(
      28,
      34,
      c,
      weight: FontWeight.w700,
      family: AppFonts.display,
    ),
    headlineSmall: _style(
      22,
      28,
      c,
      weight: FontWeight.w600,
      family: AppFonts.display,
    ),
    bodyLarge: _style(16, 24, c),
    bodyMedium: _style(14, 20, c),
    labelLarge: _style(14, 20, c, weight: FontWeight.w600),
    bodySmall: _style(12, 16, c),
  );

  static ThemeData _build(AppColors c, Brightness brightness) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.accent,
      onPrimary: c.onAccent,
      secondary: c.textSecondary,
      onSecondary: c.bg,
      error: c.warning,
      onError: c.onAccent,
      surface: c.surface,
      onSurface: c.textPrimary,
      surfaceContainerHighest: c.surfaceRaised,
      outline: c.border,
      // Selected chips and segmented buttons use the container pair.
      secondaryContainer: c.surfaceRaised,
      onSecondaryContainer: c.textPrimary,
      primaryContainer: c.surfaceRaised,
      onPrimaryContainer: c.textPrimary,
    );
    return ThemeData(
      colorScheme: scheme,
      fontFamily: AppFonts.ui,
      scaffoldBackgroundColor: c.bg,
      textTheme: _textTheme(c.textPrimary),
      dividerColor: c.border,
      extensions: [AppColorsExtension(c)],
      appBarTheme: AppBarTheme(
        backgroundColor: c.bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: brightness == Brightness.dark
            ? AppSystemUi.overlay
            : AppSystemUi.overlay.copyWith(
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
      ),
      // Android predictive back: the previous page peeks as you swipe.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
        },
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.surface,
        selectedColor: c.surfaceRaised,
        labelStyle: _style(14, 20, c.textPrimary, weight: FontWeight.w600),
        secondaryLabelStyle: _style(
          14,
          20,
          c.textPrimary,
          weight: FontWeight.w600,
        ),
        side: BorderSide(color: c.border),
      ),
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.standard,
    );
  }
}
