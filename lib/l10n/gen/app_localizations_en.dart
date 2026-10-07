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
  String get usageData => 'Share anonymous usage data';

  @override
  String get usageDataSub =>
      'Which features get used. Never your workouts, weights or account.';

  @override
  String get thisWeekTitle => 'This week';

  @override
  String get thisWeekEmpty =>
      'Nothing logged yet this week. Your first workout fills this in.';

  @override
  String get shareWeek => 'Share this week';

  @override
  String shareWeekText(int workouts, int sets, String volume) {
    return 'My week on Ripped: $workouts workouts, $sets sets, $volume lifted.';
  }

  @override
  String get recapWorkouts => 'Workouts';

  @override
  String get recapSets => 'Sets';

  @override
  String get recapVolume => 'Lifted';

  @override
  String get recapTime => 'Time';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String recapUp(int percent) {
    return 'Up $percent% on last week';
  }

  @override
  String recapDown(int percent) {
    return 'Down $percent% on last week';
  }

  @override
  String get muscleBalanceTitle => 'Muscles this week';

  @override
  String muscleSets(String muscle, int count) {
    return '$muscle: $count sets';
  }

  @override
  String get muscleChest => 'Chest';

  @override
  String get muscleBack => 'Back';

  @override
  String get muscleShoulders => 'Shoulders';

  @override
  String get muscleArms => 'Arms';

  @override
  String get muscleCore => 'Core';

  @override
  String get muscleLegs => 'Legs';

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String achievementsCount(int earned, int total) {
    return '$earned of $total earned';
  }

  @override
  String get achievementsSeeAll => 'See all achievements';

  @override
  String achievementEarned(String title) {
    return '$title, earned';
  }

  @override
  String get achievementHiddenTitle => 'Hidden achievement';

  @override
  String get achievementHiddenSub => 'Keep training to uncover it';

  @override
  String get achievementUnlocked => 'Achievement unlocked';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String get achGroupWorkouts => 'Showing up';

  @override
  String get achGroupStreak => 'Streaks';

  @override
  String get achGroupRecords => 'Records';

  @override
  String get achGroupVolume => 'Total lifted';

  @override
  String get achGroupLevel => 'Levels';

  @override
  String get achGroupVariety => 'Variety';

  @override
  String get achGroupSecret => 'Hidden';

  @override
  String get easyWeekOfferTitle => 'Time for an easy week?';

  @override
  String get easyWeekOfferFatigue =>
      'Your last few sessions felt tough. A lighter week helps you recover and come back stronger.';

  @override
  String get easyWeekOfferLongRun =>
      'You\'ve trained hard for weeks in a row. A lighter week now keeps progress coming.';

  @override
  String get easyWeekAccept => 'Go easy this week';

  @override
  String get easyWeekActiveTitle => 'Easy week';

  @override
  String get easyWeekActiveMessage =>
      'Weights are about 10% lighter with a set fewer until Monday. Your progress is saved for next week.';

  @override
  String get easyWeekEnd => 'Back to normal';

  @override
  String get notNow => 'Not now';

  @override
  String get planRefreshTitle => 'Freshen up your plan?';

  @override
  String get planRefreshMessage =>
      'You\'ve followed this plan for two months. New exercises can spark new progress. Your history and records stay.';

  @override
  String get planRefreshAccept => 'Build a new plan';

  @override
  String focusExerciseOf(int index, int total) {
    return 'Exercise $index of $total';
  }

  @override
  String setOf(int index, int total) {
    return 'Set $index of $total';
  }

  @override
  String changeSet(int number, String load) {
    return 'Change set $number: $load';
  }

  @override
  String get tapToChange => 'Tap the numbers to change them';

  @override
  String get allSets => 'All sets';

  @override
  String get nextExercise => 'Next exercise';

  @override
  String get allDoneFinish => 'All sets done. Finish up';

  @override
  String get exerciseDone => 'Exercise done';

  @override
  String restNext(String set, String load) {
    return 'Next: $set · $load';
  }

  @override
  String get skipRestLong => 'Skip rest';

  @override
  String workoutProgress(int done, int total) {
    return '$done of $total sets done';
  }

  @override
  String get cueStart => 'First set. Start steady.';

  @override
  String get cueNewExercise => 'New exercise. Find your groove.';

  @override
  String get cueKeepGoing => 'Good. Keep that form.';

  @override
  String get cueHalfway => 'This one takes you past halfway.';

  @override
  String get cueLastSet => 'Last set of this exercise. Make it count.';

  @override
  String get cueFinalSet => 'Final set of the workout. Finish strong.';

  @override
  String get builtForYou => 'Built for you';

  @override
  String factSchedule(int days, int minutes) {
    return '$days days a week, $minutes minutes each';
  }

  @override
  String factEquipment(String gear) {
    return 'Training with: $gear';
  }

  @override
  String get factBodyweight => 'No equipment needed';

  @override
  String factProtect(String joints) {
    return 'Going easy on your $joints';
  }

  @override
  String factExercises(int exercises, int workouts) {
    return '$exercises exercises across $workouts workouts';
  }

  @override
  String trainingDaysCount(int count) {
    return '$count training days a week';
  }

  @override
  String get planEdit => 'Edit plan';

  @override
  String get planEditDone => 'Done editing';

  @override
  String get planRenameDay => 'Rename day';

  @override
  String get planDayName => 'Day name';

  @override
  String get planDayFull => 'This day is full. Remove an exercise first.';

  @override
  String planReorder(String name) {
    return 'Reorder $name';
  }

  @override
  String planRemove(String name) {
    return 'Remove $name';
  }

  @override
  String planRestLine(String line, int seconds) {
    return '$line · $seconds s rest';
  }

  @override
  String get planSets => 'Sets';

  @override
  String get planRepsFrom => 'Reps, from';

  @override
  String get planRepsTo => 'Reps, up to';

  @override
  String get planTimeFrom => 'Time, from';

  @override
  String get planTimeTo => 'Time, up to';

  @override
  String get planRest => 'Rest between sets';

  @override
  String get onbSplitTitle => 'How do you want to split your week?';

  @override
  String get onbSplitHint =>
      'Not sure? Keep the first one. You can change any day later.';

  @override
  String get styleAuto => 'Coach\'s pick';

  @override
  String get styleAutoSub =>
      'The best fit for your days: each muscle trained about twice a week with time to recover.';

  @override
  String get styleFullBody => 'Full body';

  @override
  String get styleFullBodySub =>
      'Everything, every session. Great when you train two or three days.';

  @override
  String get styleUpperLower => 'Upper / Lower';

  @override
  String get styleUpperLowerSub =>
      'Upper body one day, legs the next. Balanced and easy to follow.';

  @override
  String get stylePpl => 'Push / Pull / Legs';

  @override
  String get stylePplSub =>
      'Pushing muscles, pulling muscles, then legs. Popular for five or six days.';

  @override
  String get styleBodyPart => 'Body part days';

  @override
  String get styleBodyPartSub =>
      'Chest day, back day, leg day. One or two areas get all your focus.';

  @override
  String get planRebuildDay => 'Rebuild this day';

  @override
  String get planRebuildDaySub =>
      'Pick body parts and get a fresh set of exercises';

  @override
  String get planRebuildTitle => 'What should this day train?';

  @override
  String get planRebuildHint =>
      'Pick one or more. For example chest and shoulders together.';

  @override
  String get planRebuildAction => 'Build the day';

  @override
  String get shareHeadline => 'My week';

  @override
  String get shareLifted => 'lifted this week';

  @override
  String shareTopMuscle(String muscle) {
    return 'Most trained: $muscle';
  }

  @override
  String get shareTagline => 'Ripped · the workout plan that adapts to you';

  @override
  String get shareFormatPost => 'Post';

  @override
  String get shareFormatStory => 'Story';

  @override
  String get shareAction => 'Share or save';

  @override
  String get shareHint =>
      'Choose where it goes next. Pick Save or Photos to keep it on your phone.';

  @override
  String hoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String praiseRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new personal records. You\'re getting stronger.',
      one: 'A new personal record. You\'re getting stronger.',
    );
    return '$_temp0';
  }

  @override
  String praiseLevel(int level) {
    return 'You reached level $level. That\'s earned.';
  }

  @override
  String praiseWeek(int target) {
    return 'All $target workouts done this week. That\'s how streaks are built.';
  }

  @override
  String get praiseComeback =>
      'Good to have you back. The hardest one is done.';

  @override
  String get praiseFirst =>
      'Your first workout is in the books. The start is the hard part.';

  @override
  String praiseProgress(int total, int left) {
    String _temp0 = intl.Intl.pluralLogic(
      left,
      locale: localeName,
      other: '$left more',
      one: 'One more',
    );
    return 'Workout $total done. $_temp0 to complete your week.';
  }

  @override
  String praiseCount(int total) {
    return 'Workout $total done. You keep showing up.';
  }

  @override
  String get hapticsTitle => 'Vibration feedback';

  @override
  String get hapticsSub =>
      'A buzz when you log a set, when rest ends and when a workout is saved';

  @override
  String notifyWorkoutTitle(String name) {
    return 'Today: $name';
  }

  @override
  String get notifyCatchUpTitle => 'Yesterday\'s workout is still here';

  @override
  String notifyCatchUpBody(String name) {
    return '$name: do it today, save it for later or skip it. Your call.';
  }

  @override
  String missedTitle(String weekday) {
    return 'You missed $weekday\'s workout';
  }

  @override
  String missedRest(String missed) {
    return '$missed is still waiting. Today is a rest day, so it\'s up to you.';
  }

  @override
  String missedTraining(String missed, String today) {
    return '$missed is still waiting. Do it today and $today moves to your next training day, do both, or skip it.';
  }

  @override
  String missedDoIt(String name) {
    return 'Do $name today';
  }

  @override
  String get missedDoBoth => 'Do both today';

  @override
  String missedSkip(String name) {
    return 'Skip $name';
  }

  @override
  String get missedKeep => 'Keep it for my next training day';

  @override
  String missedSkipped(String name) {
    return 'Skipped. Next up: $name.';
  }

  @override
  String get pickWorkout => 'Choose a different workout';

  @override
  String get pickWorkoutTitle => 'What do you want to train?';

  @override
  String secondWorkout(String name) {
    return 'Do $name too';
  }

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'Match phone';

  @override
  String get themeSystemSub => 'Follows your phone\'s light or dark setting';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get logoTitle => 'Logo';

  @override
  String get logoSub =>
      'Used in the app and on the cards you share. The icon on your home screen stays the same.';

  @override
  String get logoVolt => 'Volt';

  @override
  String get logoVoltSub => 'Lime on black';

  @override
  String get logoEmber => 'Ember';

  @override
  String get logoEmberSub => 'Orange on warm black';

  @override
  String get logoChalk => 'Chalk';

  @override
  String get logoChalkSub => 'Orange on chalk white';

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
      'Exercise demo videos from Free Exercise DB with Videos by Arham Wani (MIT License). Exercise data and images from free-exercise-db by yuhonas, released into the public domain (Unlicense). Icons: Material Symbols by Google (Apache License 2.0). Fonts: Inter and Barlow Condensed (SIL Open Font License).';

  @override
  String get playDemo => 'Play demo';

  @override
  String get pauseDemo => 'Pause demo';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String streakWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count-week streak',
      one: '1-week streak',
      zero: 'No streak yet',
    );
    return '$_temp0';
  }

  @override
  String streakWeeksShort(int count) {
    return '${count}w';
  }

  @override
  String levelLabel(int level) {
    return 'Level $level';
  }

  @override
  String xpProgress(int current, int next) {
    return '$current / $next XP';
  }

  @override
  String xpEarned(int amount) {
    return '+$amount XP';
  }

  @override
  String get titleBeginner => 'Beginner';

  @override
  String get titleRegular => 'Regular';

  @override
  String get titleDedicated => 'Dedicated';

  @override
  String get titleAthlete => 'Athlete';

  @override
  String get titleLegend => 'Legend';

  @override
  String levelUp(int level) {
    return 'Level up! You\'re now level $level.';
  }

  @override
  String get newBest => 'New best';

  @override
  String prE1rm(String value) {
    return 'Estimated max $value';
  }

  @override
  String prReps(int reps, String weight) {
    return '$reps reps at $weight';
  }

  @override
  String prVolume(String value) {
    return 'Session volume $value';
  }

  @override
  String prPrevious(String value) {
    return 'was $value';
  }

  @override
  String weekTargetHit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks',
      one: '1 week',
    );
    return 'Weekly target hit. Streak: $_temp0.';
  }

  @override
  String get volumeSpikeNote =>
      'Big jump in training volume this week. Sleep, eat well, and take your rest days.';

  @override
  String get welcomeBackTitle => 'Welcome back';

  @override
  String get welcomeBackMessage =>
      'Good to see you. Let\'s ease back in with today\'s session.';

  @override
  String get comebackBonus => 'Welcome back bonus';

  @override
  String get shieldAvailable => 'Streak shield ready this month';

  @override
  String get shieldUsed => 'Shield used this month';

  @override
  String get streakTitle => 'Weekly streak';

  @override
  String get recordsTitle => 'Personal records';

  @override
  String get recordsEmpty =>
      'Beat a previous session and your records show up here.';

  @override
  String get chartTitle => 'Strength over time';

  @override
  String get chartEmpty => 'Log a lift twice to see your trend.';

  @override
  String get chartEstimatedMax => 'Estimated max';

  @override
  String get sectionReminders => 'Reminders';

  @override
  String get remindersToggle => 'Workout reminders';

  @override
  String get remindersSub => 'On your training days';

  @override
  String get reminderTime => 'Time';

  @override
  String get reminderTitle => 'Training day';

  @override
  String get reminderBody => 'Your workout is ready when you are.';

  @override
  String get notificationsDenied =>
      'Notifications are off for Ripped. You can turn them on in system settings.';

  @override
  String weekOf(String date) {
    return 'Week of $date';
  }

  @override
  String weekDoneOfTarget(int done, int target) {
    return '$done/$target';
  }

  @override
  String get backupTitle => 'Back up your progress';

  @override
  String get backupMessage =>
      'Sign in so your workouts are safe if you change phones. The app works fully without an account.';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get signingIn => 'Signing in…';

  @override
  String get signInFailed =>
      'Couldn\'t sign in with Google. Check your connection and try again.';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutConfirm => 'Sign out? Your workouts stay on this phone.';

  @override
  String get signedIn => 'Signed in';

  @override
  String get sectionDataPrivacy => 'Data & privacy';

  @override
  String get exportData => 'Export my data';

  @override
  String get exportDataSub => 'Everything you\'ve logged, as JSON and CSV';

  @override
  String get exportFailed => 'Couldn\'t create the export. Please try again.';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get terms => 'Terms of use';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountSub => 'Removes your account and backups';

  @override
  String get deleteAccountTitle => 'Delete your account?';

  @override
  String get deleteAccountBody =>
      'This permanently deletes your account and all backed-up data, and clears Ripped on this phone. It can\'t be undone. Export your data first if you want a copy.';

  @override
  String get deleteAccountConfirm => 'Delete forever';

  @override
  String get accountDeleted => 'Your account and data were deleted.';

  @override
  String get deleteAccountFailed =>
      'Couldn\'t delete your account. Check your connection and try again.';

  @override
  String syncedAgo(String time) {
    return 'Backed up $time';
  }

  @override
  String get syncing => 'Backing up…';

  @override
  String get syncFailed => 'Not backed up yet. We\'ll retry automatically.';

  @override
  String get syncOtherAccount =>
      'This phone\'s data belongs to another account, so it isn\'t being backed up here.';

  @override
  String get syncNow => 'Back up now';

  @override
  String get agoJustNow => 'just now';

  @override
  String agoMinutes(int n) {
    return '$n min ago';
  }

  @override
  String agoHours(int n) {
    return '$n h ago';
  }

  @override
  String agoDays(int n) {
    return '$n d ago';
  }

  @override
  String get sendFeedback => 'Send feedback';

  @override
  String get sendFeedbackSub => 'Bugs, ideas, anything. We read every message.';

  @override
  String get feedbackSubject => 'Ripped feedback';
}
