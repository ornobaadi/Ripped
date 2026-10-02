// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ripped';

  @override
  String get tabToday => 'Today';

  @override
  String get tabProgress => 'Progress';

  @override
  String get tabYou => 'You';

  @override
  String get todayTitle => 'Today';

  @override
  String get startWorkout => 'Start workout';

  @override
  String get resumeWorkout => 'Resume workout';

  @override
  String get workoutInProgress => 'Workout in progress';

  @override
  String weekProgress(int done, int target) {
    return '$done of $target this week';
  }

  @override
  String exerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises',
      one: '1 exercise',
    );
    return '$_temp0';
  }

  @override
  String approxMinutes(int minutes) {
    return '~$minutes min';
  }

  @override
  String get restDayTitle => 'Rest day';

  @override
  String get restDayMessage =>
      'Recovery is part of the plan. Your muscles grow while you rest.';

  @override
  String get trainAnyway => 'Train anyway';

  @override
  String get doneTodayTitle => 'Done for today';

  @override
  String doneTodayMessage(String day) {
    return 'Nice work. Next up: $day.';
  }

  @override
  String get previewPlan => 'View plan';

  @override
  String get upNext => 'Up next';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get done => 'Done';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get continueLabel => 'Continue';

  @override
  String get onbGoalTitle => 'What\'s your main goal?';

  @override
  String get goalStrength => 'Get stronger';

  @override
  String get goalStrengthSub => 'Lift heavier with fewer reps';

  @override
  String get goalMuscle => 'Build muscle';

  @override
  String get goalMuscleSub => 'Moderate reps, steady growth';

  @override
  String get goalFitness => 'Get fit and healthy';

  @override
  String get goalFitnessSub => 'Strength plus conditioning';

  @override
  String get goalFatLoss => 'Lose fat';

  @override
  String get goalFatLossSub => 'Keep muscle while you lean out';

  @override
  String get goalMobility => 'Move better';

  @override
  String get goalMobilitySub => 'Strength with mobility work';

  @override
  String get onbExperienceTitle => 'How much have you trained?';

  @override
  String get expBeginner => 'New to this';

  @override
  String get expBeginnerSub => 'Less than 6 months of regular training';

  @override
  String get expIntermediate => 'Some experience';

  @override
  String get expIntermediateSub => 'Comfortable with the main lifts';

  @override
  String get expAdvanced => 'Experienced';

  @override
  String get expAdvancedSub => 'Years of consistent training';

  @override
  String get onbEquipmentTitle => 'Where do you train?';

  @override
  String get onbEquipmentHint => 'Pick everything you have access to.';

  @override
  String get eqGym => 'Gym';

  @override
  String get eqGymSub => 'Barbells, machines, cables';

  @override
  String get eqBodyweight => 'No equipment';

  @override
  String get eqBodyweightSub => 'Just your body';

  @override
  String get eqDumbbells => 'Dumbbells';

  @override
  String get eqKettlebells => 'Kettlebells';

  @override
  String get eqBands => 'Resistance bands';

  @override
  String get eqPullUpBar => 'Pull-up bar';

  @override
  String get onbDaysTitle => 'How many days a week?';

  @override
  String get onbDaysHint => 'Pick your days, or let us spread them out.';

  @override
  String daysPerWeek(int count) {
    return '$count days';
  }

  @override
  String get pickDays => 'Which days? (optional)';

  @override
  String get onbLengthTitle => 'How long per session?';

  @override
  String minutes(int count) {
    return '$count min';
  }

  @override
  String get onbAvoidTitle => 'Anything to go easy on?';

  @override
  String get onbAvoidHint =>
      'We\'ll leave out exercises that load these. This isn\'t medical advice.';

  @override
  String get jointKnee => 'Knees';

  @override
  String get jointLowerBack => 'Lower back';

  @override
  String get jointShoulder => 'Shoulders';

  @override
  String get jointWrist => 'Wrists';

  @override
  String get jointElbow => 'Elbows';

  @override
  String get jointHip => 'Hips';

  @override
  String get nothingToAvoid => 'Nothing, I\'m good';

  @override
  String get disclaimerTitle => 'Before you start';

  @override
  String get disclaimerBody =>
      'Ripped gives general fitness guidance, not medical advice. Check with a doctor before starting a new program, especially if you have an injury or health condition. Stop any exercise that causes pain.';

  @override
  String get disclaimerAccept => 'I understand';

  @override
  String get buildingPlan => 'Building your plan…';

  @override
  String get planReadyTitle => 'Your plan is ready';

  @override
  String get looksGood => 'Looks good';

  @override
  String get regenerate => 'Start over';

  @override
  String get swap => 'Swap';

  @override
  String get swapFor => 'Swap for…';

  @override
  String get noSwaps => 'No alternatives fit your equipment and settings.';

  @override
  String get planTitle => 'Your plan';

  @override
  String setsReps(int sets, int min, int max) {
    return '$sets × $min–$max';
  }

  @override
  String setsSeconds(int sets, int min, int max) {
    return '$sets × $min–$max s';
  }

  @override
  String setLabel(int number) {
    return 'Set $number';
  }

  @override
  String markSetDone(int number) {
    return 'Mark set $number done';
  }

  @override
  String setDone(int number) {
    return 'Set $number done';
  }

  @override
  String increase(String label) {
    return 'Increase $label';
  }

  @override
  String decrease(String label) {
    return 'Decrease $label';
  }

  @override
  String get selected => 'Selected';

  @override
  String get reps => 'reps';

  @override
  String get repsLabel => 'Reps';

  @override
  String get secondsLabel => 'Seconds';

  @override
  String get seconds => 's';

  @override
  String get weight => 'Weight';

  @override
  String get unitKg => 'kg';

  @override
  String get unitLb => 'lb';

  @override
  String get bodyweight => 'Bodyweight';

  @override
  String setsProgress(int done, int total) {
    return '$done/$total sets';
  }

  @override
  String get finish => 'Finish';

  @override
  String get finishWorkoutTitle => 'Finish workout?';

  @override
  String finishUnfinished(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sets aren\'t logged. They won\'t count.',
      one: '1 set isn\'t logged. It won\'t count.',
    );
    return '$_temp0';
  }

  @override
  String get howDidItFeel => 'How did it feel?';

  @override
  String get feelingEasy => 'Easy';

  @override
  String get feelingJustRight => 'Just right';

  @override
  String get feelingTough => 'Tough';

  @override
  String get finishAction => 'Finish workout';

  @override
  String get keepGoing => 'Keep going';

  @override
  String get discardWorkout => 'Discard workout';

  @override
  String get discardConfirm =>
      'Discard this workout? Logged sets will be lost.';

  @override
  String get discard => 'Discard';

  @override
  String get rest => 'Rest';

  @override
  String get skipRest => 'Skip';

  @override
  String get addTime => '+15 s';

  @override
  String findYourWeight(int reps) {
    return 'First time: start light, then adjust to a weight you can lift for $reps reps with good form.';
  }

  @override
  String lastTime(String summary) {
    return 'Last time: $summary';
  }

  @override
  String targetRange(int min, int max) {
    return 'Target $min–$max';
  }

  @override
  String get addSet => 'Add set';

  @override
  String get removeSet => 'Remove set';

  @override
  String get skipExercise => 'Skip exercise';

  @override
  String get unskipExercise => 'Do this exercise';

  @override
  String get skipped => 'Skipped';

  @override
  String get swapExercise => 'Swap exercise';

  @override
  String get moveUp => 'Move up';

  @override
  String get moveDown => 'Move down';

  @override
  String get addExercise => 'Add exercise';

  @override
  String get exerciseDetails => 'How to do it';

  @override
  String editSet(int number) {
    return 'Edit set $number';
  }

  @override
  String get logSet => 'Log set';

  @override
  String get undo => 'Undo';

  @override
  String exerciseOf(int index, int total) {
    return '$index of $total';
  }

  @override
  String get searchExercises => 'Search exercises';

  @override
  String get workoutCompleteTitle => 'Workout complete';

  @override
  String get statDuration => 'Duration';

  @override
  String get statSets => 'Sets';

  @override
  String get statVolume => 'Volume';

  @override
  String get nextTimeTitle => 'Next time';

  @override
  String progressIncreaseWeight(String amount, String weight) {
    return '+$amount → $weight';
  }

  @override
  String progressIncreaseReps(int reps) {
    return 'Aim for $reps';
  }

  @override
  String get progressBaseline => 'Starting point saved';

  @override
  String get progressHold => 'Same target, you\'ve got this';

  @override
  String progressDeload(String weight) {
    return 'Lighter week: $weight';
  }

  @override
  String get progressHarder => 'Ready for a harder variation';

  @override
  String get instructions => 'Instructions';

  @override
  String get primaryMuscles => 'Main muscles';

  @override
  String get secondaryMuscles => 'Also works';

  @override
  String get equipment => 'Equipment';

  @override
  String mediaCredit(String attribution) {
    return 'Image: $attribution';
  }

  @override
  String get historyTitle => 'History';

  @override
  String get historyEmptyTitle => 'No workouts yet';

  @override
  String get historyEmptyMessage =>
      'Finish your first workout and it shows up here.';

  @override
  String historySummary(int sets, String volume) {
    return '$sets sets · $volume';
  }

  @override
  String get youTitle => 'You';

  @override
  String get sectionTraining => 'Training';

  @override
  String get sectionPreferences => 'Preferences';

  @override
  String get sectionAbout => 'About';

  @override
  String get units => 'Units';

  @override
  String get unitsMetric => 'Kilograms';

  @override
  String get unitsImperial => 'Pounds';

  @override
  String get editPlan => 'Change goals and plan';

  @override
  String get editPlanSub => 'Re-answer the questions and build a new plan';

  @override
  String get viewPlan => 'View current plan';

  @override
  String get healthDisclaimer => 'Health disclaimer';

  @override
  String get credits => 'Credits';

  @override
  String get creditsBody =>
      'Exercise data and images from free-exercise-db by yuhonas, released into the public domain (Unlicense). Fonts: Inter and Barlow Condensed (SIL Open Font License).';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';
}
