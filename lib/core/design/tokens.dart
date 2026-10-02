import 'package:flutter/animation.dart';

/// Color tokens from design.md 5.1.
class AppColors {
  const new({
    required this.bg,
    required this.surface,
    required this.surfaceRaised,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.accent,
    required this.onAccent,
    required this.success,
    required this.warning,
  });

  final Color bg;
  final Color surface;
  final Color surfaceRaised;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color accent;
  final Color onAccent;
  final Color success;
  final Color warning;

  static const dark = AppColors(
    bg: Color(0xFF0E0F11),
    surface: Color(0xFF17191C),
    surfaceRaised: Color(0xFF202328),
    textPrimary: Color(0xFFF5F5F4),
    textSecondary: Color(0xFFA1A1AA),
    border: Color(0xFF2A2D33),
    accent: Color(0xFFC6F432),
    onAccent: Color(0xFF0E0F11),
    success: Color(0xFF4ADE80),
    warning: Color(0xFFFBBF24),
  );

  static const light = AppColors(
    bg: Color(0xFFFAFAF9),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFF2F2F0),
    textPrimary: Color(0xFF111214),
    textSecondary: Color(0xFF5B5E66),
    border: Color(0xFFE4E4E1),
    accent: Color(0xFF4F7A00),
    onAccent: Color(0xFFFFFFFF),
    success: Color(0xFF15803D),
    warning: Color(0xFFB45309),
  );
}

/// 4-pt spacing grid (design.md 5.3).
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

abstract final class AppRadii {
  static const double chip = 8;
  static const double card = 16;
  static const double sheet = 28;
}

/// Motion tokens (design.md 5.5).
abstract final class AppMotion {
  static const fast = Duration(milliseconds: 120);
  static const base = Duration(milliseconds: 220);
  static const celebrate = Duration(milliseconds: 750);
  static const Curve fastCurve = Curves.easeOut;
  static const Curve baseCurve = Curves.easeInOutCubic;
}

/// Font families (design.md 5.2). Files are bundled under assets/fonts/;
/// never fetched at runtime.
abstract final class AppFonts {
  /// UI text: labels, body, buttons.
  static const ui = 'Inter';

  /// Headings and big numbers (weights, reps, timers).
  static const display = 'BarlowCondensed';
}

/// Minimum tap targets (design.md 7).
abstract final class AppTapTargets {
  static const double min = 48;
  static const double workout = 56;
}
