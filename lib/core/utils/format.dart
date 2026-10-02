import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/l10n/l10n.dart';

/// Unit conversion and number formatting at the UI edge. Storage is
/// always kg (architecture.md 4.2).
abstract final class Fmt {
  static const _lb = 0.45359237;

  static double toDisplay(double kg, Units units) =>
      units == Units.kg ? kg : kg / _lb;

  static double toKg(double value, Units units) =>
      units == Units.kg ? value : value * _lb;

  /// "60", "62.5", "135". Rounds away float noise from conversions.
  static String number(double v) {
    final rounded = (v * 10).round() / 10;
    return rounded == rounded.roundToDouble()
        ? rounded.toInt().toString()
        : rounded.toStringAsFixed(1);
  }

  static String unit(Units units, AppLocalizations l10n) =>
      units == Units.kg ? l10n.unitKg : l10n.unitLb;

  /// "60 kg" / "135 lb"; null weight reads "Bodyweight".
  static String weight(double? kg, Units units, AppLocalizations l10n) =>
      kg == null
      ? l10n.bodyweight
      : '${number(toDisplay(kg, units))} ${unit(units, l10n)}';

  /// "60 kg × 8" or "12 reps" or "45 s".
  static String set({
    required double? kg,
    required int reps,
    required bool timed,
    required Units units,
    required AppLocalizations l10n,
  }) {
    final amount = timed ? '$reps ${l10n.seconds}' : '$reps';
    if (kg == null) return timed ? amount : '$reps ${l10n.reps}';
    return '${weight(kg, units, l10n)} × $amount';
  }

  /// "4,250 kg" volume, whole numbers with thousands separators.
  static String volume(double kg, Units units, AppLocalizations l10n) {
    final v = toDisplay(kg, units).round().toString();
    final grouped = v.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    return '$grouped ${unit(units, l10n)}';
  }

  /// "4:05" or "1:02:09".
  static String clock(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$s' : '$m:$s';
  }
}
