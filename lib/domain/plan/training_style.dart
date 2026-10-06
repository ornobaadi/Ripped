/// How the training week is divided. `auto` lets the app pick what a coach
/// would for the number of days.
enum TrainingStyle {
  auto,

  /// Every session trains the whole body.
  fullBody,

  /// Alternating upper-body and lower-body days.
  upperLower,

  /// Push (chest, shoulders, triceps), pull (back, biceps), legs.
  pushPullLegs,

  /// One or two body parts per day: "chest day", "leg day".
  bodyPart;

  static TrainingStyle parse(String? raw) =>
      values.asNameMap()[raw] ?? TrainingStyle.auto;

  /// Fewest and most days a week this style makes sense for.
  (int, int) get dayRange => switch (this) {
    auto => (2, 6),
    fullBody => (2, 4),
    upperLower => (2, 6),
    pushPullLegs => (3, 6),
    bodyPart => (3, 6),
  };

  bool fits(int daysPerWeek) {
    final (lo, hi) = dayRange;
    return daysPerWeek >= lo && daysPerWeek <= hi;
  }
}

/// Body areas a day can be built around.
enum BodyPart { chest, back, shoulders, arms, legs, core }
