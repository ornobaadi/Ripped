import 'package:ripped/core/utils/format.dart';
import 'package:ripped/domain/gamification/xp.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/domain/records/personal_records.dart';
import 'package:ripped/l10n/l10n.dart';

/// Localized labels for domain values.
extension DomainLabels on AppLocalizations {
  String levelTitle(LevelTitle t) => switch (t) {
    LevelTitle.beginner => titleBeginner,
    LevelTitle.regular => titleRegular,
    LevelTitle.dedicated => titleDedicated,
    LevelTitle.athlete => titleAthlete,
    LevelTitle.legend => titleLegend,
  };

  /// Headline + "was ..." detail for a record.
  (String, String) prText(
    PrType type, {
    required double value,
    required double previous,
    required double weightKg,
    required int reps,
    required Units units,
  }) => switch (type) {
    PrType.e1rm => (
      prE1rm(Fmt.weight(value, units, this)),
      prPrevious(Fmt.weight(previous, units, this)),
    ),
    PrType.reps => (
      prReps(reps, Fmt.weight(weightKg, units, this)),
      prPrevious('${previous.round()} $repsLabel'.toLowerCase()),
    ),
    PrType.volume => (
      prVolume(Fmt.volume(value, units, this)),
      prPrevious(Fmt.volume(previous, units, this)),
    ),
  };
}
