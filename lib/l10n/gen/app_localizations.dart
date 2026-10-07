import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Ripped'**
  String get appTitle;

  /// No description provided for @tabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tabToday;

  /// No description provided for @tabProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get tabProgress;

  /// No description provided for @tabYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get tabYou;

  /// No description provided for @todayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTitle;

  /// No description provided for @startWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start workout'**
  String get startWorkout;

  /// No description provided for @resumeWorkout.
  ///
  /// In en, this message translates to:
  /// **'Resume workout'**
  String get resumeWorkout;

  /// No description provided for @workoutInProgress.
  ///
  /// In en, this message translates to:
  /// **'Workout in progress'**
  String get workoutInProgress;

  /// No description provided for @weekProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {target} this week'**
  String weekProgress(int done, int target);

  /// No description provided for @exerciseCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 exercise} other{{count} exercises}}'**
  String exerciseCount(int count);

  /// No description provided for @approxMinutes.
  ///
  /// In en, this message translates to:
  /// **'~{minutes} min'**
  String approxMinutes(int minutes);

  /// No description provided for @restDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get restDayTitle;

  /// No description provided for @restDayMessage.
  ///
  /// In en, this message translates to:
  /// **'Recovery is part of the plan. Your muscles grow while you rest.'**
  String get restDayMessage;

  /// No description provided for @trainAnyway.
  ///
  /// In en, this message translates to:
  /// **'Train anyway'**
  String get trainAnyway;

  /// No description provided for @doneTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Done for today'**
  String get doneTodayTitle;

  /// No description provided for @doneTodayMessage.
  ///
  /// In en, this message translates to:
  /// **'Nice work. Next up: {day}.'**
  String doneTodayMessage(String day);

  /// No description provided for @previewPlan.
  ///
  /// In en, this message translates to:
  /// **'View plan'**
  String get previewPlan;

  /// No description provided for @upNext.
  ///
  /// In en, this message translates to:
  /// **'Up next'**
  String get upNext;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @onbGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your main goal?'**
  String get onbGoalTitle;

  /// No description provided for @goalStrength.
  ///
  /// In en, this message translates to:
  /// **'Get stronger'**
  String get goalStrength;

  /// No description provided for @goalStrengthSub.
  ///
  /// In en, this message translates to:
  /// **'Lift heavier with fewer reps'**
  String get goalStrengthSub;

  /// No description provided for @goalMuscle.
  ///
  /// In en, this message translates to:
  /// **'Build muscle'**
  String get goalMuscle;

  /// No description provided for @goalMuscleSub.
  ///
  /// In en, this message translates to:
  /// **'Moderate reps, steady growth'**
  String get goalMuscleSub;

  /// No description provided for @goalFitness.
  ///
  /// In en, this message translates to:
  /// **'Get fit and healthy'**
  String get goalFitness;

  /// No description provided for @goalFitnessSub.
  ///
  /// In en, this message translates to:
  /// **'Strength plus conditioning'**
  String get goalFitnessSub;

  /// No description provided for @goalFatLoss.
  ///
  /// In en, this message translates to:
  /// **'Lose fat'**
  String get goalFatLoss;

  /// No description provided for @goalFatLossSub.
  ///
  /// In en, this message translates to:
  /// **'Keep muscle while you lean out'**
  String get goalFatLossSub;

  /// No description provided for @goalMobility.
  ///
  /// In en, this message translates to:
  /// **'Move better'**
  String get goalMobility;

  /// No description provided for @goalMobilitySub.
  ///
  /// In en, this message translates to:
  /// **'Strength with mobility work'**
  String get goalMobilitySub;

  /// No description provided for @onbExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'How much have you trained?'**
  String get onbExperienceTitle;

  /// No description provided for @expBeginner.
  ///
  /// In en, this message translates to:
  /// **'New to this'**
  String get expBeginner;

  /// No description provided for @expBeginnerSub.
  ///
  /// In en, this message translates to:
  /// **'Less than 6 months of regular training'**
  String get expBeginnerSub;

  /// No description provided for @expIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Some experience'**
  String get expIntermediate;

  /// No description provided for @expIntermediateSub.
  ///
  /// In en, this message translates to:
  /// **'Comfortable with the main lifts'**
  String get expIntermediateSub;

  /// No description provided for @expAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Experienced'**
  String get expAdvanced;

  /// No description provided for @expAdvancedSub.
  ///
  /// In en, this message translates to:
  /// **'Years of consistent training'**
  String get expAdvancedSub;

  /// No description provided for @onbEquipmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Where do you train?'**
  String get onbEquipmentTitle;

  /// No description provided for @onbEquipmentHint.
  ///
  /// In en, this message translates to:
  /// **'Pick everything you have access to.'**
  String get onbEquipmentHint;

  /// No description provided for @eqGym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get eqGym;

  /// No description provided for @eqGymSub.
  ///
  /// In en, this message translates to:
  /// **'Barbells, machines, cables'**
  String get eqGymSub;

  /// No description provided for @eqBodyweight.
  ///
  /// In en, this message translates to:
  /// **'No equipment'**
  String get eqBodyweight;

  /// No description provided for @eqBodyweightSub.
  ///
  /// In en, this message translates to:
  /// **'Just your body'**
  String get eqBodyweightSub;

  /// No description provided for @eqDumbbells.
  ///
  /// In en, this message translates to:
  /// **'Dumbbells'**
  String get eqDumbbells;

  /// No description provided for @eqKettlebells.
  ///
  /// In en, this message translates to:
  /// **'Kettlebells'**
  String get eqKettlebells;

  /// No description provided for @eqBands.
  ///
  /// In en, this message translates to:
  /// **'Resistance bands'**
  String get eqBands;

  /// No description provided for @eqPullUpBar.
  ///
  /// In en, this message translates to:
  /// **'Pull-up bar'**
  String get eqPullUpBar;

  /// No description provided for @onbDaysTitle.
  ///
  /// In en, this message translates to:
  /// **'How many days a week?'**
  String get onbDaysTitle;

  /// No description provided for @onbDaysHint.
  ///
  /// In en, this message translates to:
  /// **'Pick your days, or let us spread them out.'**
  String get onbDaysHint;

  /// No description provided for @daysPerWeek.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysPerWeek(int count);

  /// No description provided for @pickDays.
  ///
  /// In en, this message translates to:
  /// **'Which days? (optional)'**
  String get pickDays;

  /// No description provided for @onbLengthTitle.
  ///
  /// In en, this message translates to:
  /// **'How long per session?'**
  String get onbLengthTitle;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutes(int count);

  /// No description provided for @onbAvoidTitle.
  ///
  /// In en, this message translates to:
  /// **'Anything to go easy on?'**
  String get onbAvoidTitle;

  /// No description provided for @onbAvoidHint.
  ///
  /// In en, this message translates to:
  /// **'We\'ll leave out exercises that load these. This isn\'t medical advice.'**
  String get onbAvoidHint;

  /// No description provided for @jointKnee.
  ///
  /// In en, this message translates to:
  /// **'Knees'**
  String get jointKnee;

  /// No description provided for @jointLowerBack.
  ///
  /// In en, this message translates to:
  /// **'Lower back'**
  String get jointLowerBack;

  /// No description provided for @jointShoulder.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get jointShoulder;

  /// No description provided for @jointWrist.
  ///
  /// In en, this message translates to:
  /// **'Wrists'**
  String get jointWrist;

  /// No description provided for @jointElbow.
  ///
  /// In en, this message translates to:
  /// **'Elbows'**
  String get jointElbow;

  /// No description provided for @jointHip.
  ///
  /// In en, this message translates to:
  /// **'Hips'**
  String get jointHip;

  /// No description provided for @nothingToAvoid.
  ///
  /// In en, this message translates to:
  /// **'Nothing, I\'m good'**
  String get nothingToAvoid;

  /// No description provided for @disclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you start'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'Ripped gives general fitness guidance, not medical advice. Check with a doctor before starting a new program, especially if you have an injury or health condition. Stop any exercise that causes pain.'**
  String get disclaimerBody;

  /// No description provided for @disclaimerAccept.
  ///
  /// In en, this message translates to:
  /// **'I understand'**
  String get disclaimerAccept;

  /// No description provided for @buildingPlan.
  ///
  /// In en, this message translates to:
  /// **'Building your plan…'**
  String get buildingPlan;

  /// No description provided for @planReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your plan is ready'**
  String get planReadyTitle;

  /// No description provided for @looksGood.
  ///
  /// In en, this message translates to:
  /// **'Looks good'**
  String get looksGood;

  /// No description provided for @regenerate.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get regenerate;

  /// No description provided for @swap.
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get swap;

  /// No description provided for @swapFor.
  ///
  /// In en, this message translates to:
  /// **'Swap for…'**
  String get swapFor;

  /// No description provided for @noSwaps.
  ///
  /// In en, this message translates to:
  /// **'No alternatives fit your equipment and settings.'**
  String get noSwaps;

  /// No description provided for @planTitle.
  ///
  /// In en, this message translates to:
  /// **'Your plan'**
  String get planTitle;

  /// No description provided for @setsReps.
  ///
  /// In en, this message translates to:
  /// **'{sets} × {min}–{max}'**
  String setsReps(int sets, int min, int max);

  /// No description provided for @setsSeconds.
  ///
  /// In en, this message translates to:
  /// **'{sets} × {min}–{max} s'**
  String setsSeconds(int sets, int min, int max);

  /// No description provided for @setLabel.
  ///
  /// In en, this message translates to:
  /// **'Set {number}'**
  String setLabel(int number);

  /// No description provided for @markSetDone.
  ///
  /// In en, this message translates to:
  /// **'Mark set {number} done'**
  String markSetDone(int number);

  /// No description provided for @setDone.
  ///
  /// In en, this message translates to:
  /// **'Set {number} done'**
  String setDone(int number);

  /// No description provided for @increase.
  ///
  /// In en, this message translates to:
  /// **'Increase {label}'**
  String increase(String label);

  /// No description provided for @decrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease {label}'**
  String decrease(String label);

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @reps.
  ///
  /// In en, this message translates to:
  /// **'reps'**
  String get reps;

  /// No description provided for @repsLabel.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get repsLabel;

  /// No description provided for @secondsLabel.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get secondsLabel;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get seconds;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @unitKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get unitKg;

  /// No description provided for @unitLb.
  ///
  /// In en, this message translates to:
  /// **'lb'**
  String get unitLb;

  /// No description provided for @bodyweight.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight'**
  String get bodyweight;

  /// No description provided for @setsProgress.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total} sets'**
  String setsProgress(int done, int total);

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @finishWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish workout?'**
  String get finishWorkoutTitle;

  /// No description provided for @finishUnfinished.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 set isn\'t logged. It won\'t count.} other{{count} sets aren\'t logged. They won\'t count.}}'**
  String finishUnfinished(int count);

  /// No description provided for @howDidItFeel.
  ///
  /// In en, this message translates to:
  /// **'How did it feel?'**
  String get howDidItFeel;

  /// No description provided for @feelingEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get feelingEasy;

  /// No description provided for @feelingJustRight.
  ///
  /// In en, this message translates to:
  /// **'Just right'**
  String get feelingJustRight;

  /// No description provided for @feelingTough.
  ///
  /// In en, this message translates to:
  /// **'Tough'**
  String get feelingTough;

  /// No description provided for @finishAction.
  ///
  /// In en, this message translates to:
  /// **'Finish workout'**
  String get finishAction;

  /// No description provided for @keepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get keepGoing;

  /// No description provided for @discardWorkout.
  ///
  /// In en, this message translates to:
  /// **'Discard workout'**
  String get discardWorkout;

  /// No description provided for @discardConfirm.
  ///
  /// In en, this message translates to:
  /// **'Discard this workout? Logged sets will be lost.'**
  String get discardConfirm;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @rest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get rest;

  /// No description provided for @skipRest.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipRest;

  /// No description provided for @addTime.
  ///
  /// In en, this message translates to:
  /// **'+15 s'**
  String get addTime;

  /// No description provided for @findYourWeight.
  ///
  /// In en, this message translates to:
  /// **'First time: start light, then adjust to a weight you can lift for {reps} reps with good form.'**
  String findYourWeight(int reps);

  /// No description provided for @lastTime.
  ///
  /// In en, this message translates to:
  /// **'Last time: {summary}'**
  String lastTime(String summary);

  /// No description provided for @targetRange.
  ///
  /// In en, this message translates to:
  /// **'Target {min}–{max}'**
  String targetRange(int min, int max);

  /// No description provided for @addSet.
  ///
  /// In en, this message translates to:
  /// **'Add set'**
  String get addSet;

  /// No description provided for @removeSet.
  ///
  /// In en, this message translates to:
  /// **'Remove set'**
  String get removeSet;

  /// No description provided for @skipExercise.
  ///
  /// In en, this message translates to:
  /// **'Skip exercise'**
  String get skipExercise;

  /// No description provided for @unskipExercise.
  ///
  /// In en, this message translates to:
  /// **'Do this exercise'**
  String get unskipExercise;

  /// No description provided for @skipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get skipped;

  /// No description provided for @swapExercise.
  ///
  /// In en, this message translates to:
  /// **'Swap exercise'**
  String get swapExercise;

  /// No description provided for @moveUp.
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get moveUp;

  /// No description provided for @moveDown.
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get moveDown;

  /// No description provided for @addExercise.
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get addExercise;

  /// No description provided for @exerciseDetails.
  ///
  /// In en, this message translates to:
  /// **'How to do it'**
  String get exerciseDetails;

  /// No description provided for @editSet.
  ///
  /// In en, this message translates to:
  /// **'Edit set {number}'**
  String editSet(int number);

  /// No description provided for @logSet.
  ///
  /// In en, this message translates to:
  /// **'Log set'**
  String get logSet;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @exerciseOf.
  ///
  /// In en, this message translates to:
  /// **'{index} of {total}'**
  String exerciseOf(int index, int total);

  /// No description provided for @searchExercises.
  ///
  /// In en, this message translates to:
  /// **'Search exercises'**
  String get searchExercises;

  /// No description provided for @workoutCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout complete'**
  String get workoutCompleteTitle;

  /// No description provided for @statDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get statDuration;

  /// No description provided for @statSets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get statSets;

  /// No description provided for @statVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get statVolume;

  /// No description provided for @nextTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Next time'**
  String get nextTimeTitle;

  /// No description provided for @progressIncreaseWeight.
  ///
  /// In en, this message translates to:
  /// **'+{amount} → {weight}'**
  String progressIncreaseWeight(String amount, String weight);

  /// No description provided for @progressIncreaseReps.
  ///
  /// In en, this message translates to:
  /// **'Aim for {reps}'**
  String progressIncreaseReps(int reps);

  /// No description provided for @progressBaseline.
  ///
  /// In en, this message translates to:
  /// **'Starting point saved'**
  String get progressBaseline;

  /// No description provided for @progressHold.
  ///
  /// In en, this message translates to:
  /// **'Same target, you\'ve got this'**
  String get progressHold;

  /// No description provided for @progressDeload.
  ///
  /// In en, this message translates to:
  /// **'Lighter week: {weight}'**
  String progressDeload(String weight);

  /// No description provided for @progressHarder.
  ///
  /// In en, this message translates to:
  /// **'Ready for a harder variation'**
  String get progressHarder;

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @primaryMuscles.
  ///
  /// In en, this message translates to:
  /// **'Main muscles'**
  String get primaryMuscles;

  /// No description provided for @secondaryMuscles.
  ///
  /// In en, this message translates to:
  /// **'Also works'**
  String get secondaryMuscles;

  /// No description provided for @equipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get equipment;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No workouts yet'**
  String get historyEmptyTitle;

  /// No description provided for @historyEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Finish your first workout and it shows up here.'**
  String get historyEmptyMessage;

  /// No description provided for @historySummary.
  ///
  /// In en, this message translates to:
  /// **'{sets} sets · {volume}'**
  String historySummary(int sets, String volume);

  /// No description provided for @youTitle.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get youTitle;

  /// No description provided for @sectionTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get sectionTraining;

  /// No description provided for @sectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get sectionPreferences;

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sectionAbout;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @usageData.
  ///
  /// In en, this message translates to:
  /// **'Share anonymous usage data'**
  String get usageData;

  /// No description provided for @usageDataSub.
  ///
  /// In en, this message translates to:
  /// **'Which features get used. Never your workouts, weights or account.'**
  String get usageDataSub;

  /// No description provided for @thisWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeekTitle;

  /// No description provided for @thisWeekEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged yet this week. Your first workout fills this in.'**
  String get thisWeekEmpty;

  /// No description provided for @shareWeek.
  ///
  /// In en, this message translates to:
  /// **'Share this week'**
  String get shareWeek;

  /// No description provided for @shareWeekText.
  ///
  /// In en, this message translates to:
  /// **'My week on Ripped: {workouts} workouts, {sets} sets, {volume} lifted.'**
  String shareWeekText(int workouts, int sets, String volume);

  /// No description provided for @recapWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get recapWorkouts;

  /// No description provided for @recapSets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get recapSets;

  /// No description provided for @recapVolume.
  ///
  /// In en, this message translates to:
  /// **'Lifted'**
  String get recapVolume;

  /// No description provided for @recapTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get recapTime;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// No description provided for @recapUp.
  ///
  /// In en, this message translates to:
  /// **'Up {percent}% on last week'**
  String recapUp(int percent);

  /// No description provided for @recapDown.
  ///
  /// In en, this message translates to:
  /// **'Down {percent}% on last week'**
  String recapDown(int percent);

  /// No description provided for @muscleBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Muscles this week'**
  String get muscleBalanceTitle;

  /// No description provided for @muscleSets.
  ///
  /// In en, this message translates to:
  /// **'{muscle}: {count} sets'**
  String muscleSets(String muscle, int count);

  /// No description provided for @muscleChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get muscleChest;

  /// No description provided for @muscleBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get muscleBack;

  /// No description provided for @muscleShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get muscleShoulders;

  /// No description provided for @muscleArms.
  ///
  /// In en, this message translates to:
  /// **'Arms'**
  String get muscleArms;

  /// No description provided for @muscleCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get muscleCore;

  /// No description provided for @muscleLegs.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get muscleLegs;

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @achievementsCount.
  ///
  /// In en, this message translates to:
  /// **'{earned} of {total} earned'**
  String achievementsCount(int earned, int total);

  /// No description provided for @achievementsSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all achievements'**
  String get achievementsSeeAll;

  /// No description provided for @achievementEarned.
  ///
  /// In en, this message translates to:
  /// **'{title}, earned'**
  String achievementEarned(String title);

  /// No description provided for @achievementHiddenTitle.
  ///
  /// In en, this message translates to:
  /// **'Hidden achievement'**
  String get achievementHiddenTitle;

  /// No description provided for @achievementHiddenSub.
  ///
  /// In en, this message translates to:
  /// **'Keep training to uncover it'**
  String get achievementHiddenSub;

  /// No description provided for @achievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Achievement unlocked'**
  String get achievementUnlocked;

  /// No description provided for @percent.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String percent(int value);

  /// No description provided for @achGroupWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Showing up'**
  String get achGroupWorkouts;

  /// No description provided for @achGroupStreak.
  ///
  /// In en, this message translates to:
  /// **'Streaks'**
  String get achGroupStreak;

  /// No description provided for @achGroupRecords.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get achGroupRecords;

  /// No description provided for @achGroupVolume.
  ///
  /// In en, this message translates to:
  /// **'Total lifted'**
  String get achGroupVolume;

  /// No description provided for @achGroupLevel.
  ///
  /// In en, this message translates to:
  /// **'Levels'**
  String get achGroupLevel;

  /// No description provided for @achGroupVariety.
  ///
  /// In en, this message translates to:
  /// **'Variety'**
  String get achGroupVariety;

  /// No description provided for @achGroupSecret.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get achGroupSecret;

  /// No description provided for @easyWeekOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'Time for an easy week?'**
  String get easyWeekOfferTitle;

  /// No description provided for @easyWeekOfferFatigue.
  ///
  /// In en, this message translates to:
  /// **'Your last few sessions felt tough. A lighter week helps you recover and come back stronger.'**
  String get easyWeekOfferFatigue;

  /// No description provided for @easyWeekOfferLongRun.
  ///
  /// In en, this message translates to:
  /// **'You\'ve trained hard for weeks in a row. A lighter week now keeps progress coming.'**
  String get easyWeekOfferLongRun;

  /// No description provided for @easyWeekAccept.
  ///
  /// In en, this message translates to:
  /// **'Go easy this week'**
  String get easyWeekAccept;

  /// No description provided for @easyWeekActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Easy week'**
  String get easyWeekActiveTitle;

  /// No description provided for @easyWeekActiveMessage.
  ///
  /// In en, this message translates to:
  /// **'Weights are about 10% lighter with a set fewer until Monday. Your progress is saved for next week.'**
  String get easyWeekActiveMessage;

  /// No description provided for @easyWeekEnd.
  ///
  /// In en, this message translates to:
  /// **'Back to normal'**
  String get easyWeekEnd;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @planRefreshTitle.
  ///
  /// In en, this message translates to:
  /// **'Freshen up your plan?'**
  String get planRefreshTitle;

  /// No description provided for @planRefreshMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ve followed this plan for two months. New exercises can spark new progress. Your history and records stay.'**
  String get planRefreshMessage;

  /// No description provided for @planRefreshAccept.
  ///
  /// In en, this message translates to:
  /// **'Build a new plan'**
  String get planRefreshAccept;

  /// No description provided for @focusExerciseOf.
  ///
  /// In en, this message translates to:
  /// **'Exercise {index} of {total}'**
  String focusExerciseOf(int index, int total);

  /// No description provided for @setOf.
  ///
  /// In en, this message translates to:
  /// **'Set {index} of {total}'**
  String setOf(int index, int total);

  /// No description provided for @changeSet.
  ///
  /// In en, this message translates to:
  /// **'Change set {number}: {load}'**
  String changeSet(int number, String load);

  /// No description provided for @tapToChange.
  ///
  /// In en, this message translates to:
  /// **'Tap the numbers to change them'**
  String get tapToChange;

  /// No description provided for @allSets.
  ///
  /// In en, this message translates to:
  /// **'All sets'**
  String get allSets;

  /// No description provided for @nextExercise.
  ///
  /// In en, this message translates to:
  /// **'Next exercise'**
  String get nextExercise;

  /// No description provided for @allDoneFinish.
  ///
  /// In en, this message translates to:
  /// **'All sets done. Finish up'**
  String get allDoneFinish;

  /// No description provided for @exerciseDone.
  ///
  /// In en, this message translates to:
  /// **'Exercise done'**
  String get exerciseDone;

  /// No description provided for @restNext.
  ///
  /// In en, this message translates to:
  /// **'Next: {set} · {load}'**
  String restNext(String set, String load);

  /// No description provided for @skipRestLong.
  ///
  /// In en, this message translates to:
  /// **'Skip rest'**
  String get skipRestLong;

  /// No description provided for @workoutProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} sets done'**
  String workoutProgress(int done, int total);

  /// No description provided for @cueStart.
  ///
  /// In en, this message translates to:
  /// **'First set. Start steady.'**
  String get cueStart;

  /// No description provided for @cueNewExercise.
  ///
  /// In en, this message translates to:
  /// **'New exercise. Find your groove.'**
  String get cueNewExercise;

  /// No description provided for @cueKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Good. Keep that form.'**
  String get cueKeepGoing;

  /// No description provided for @cueHalfway.
  ///
  /// In en, this message translates to:
  /// **'This one takes you past halfway.'**
  String get cueHalfway;

  /// No description provided for @cueLastSet.
  ///
  /// In en, this message translates to:
  /// **'Last set of this exercise. Make it count.'**
  String get cueLastSet;

  /// No description provided for @cueFinalSet.
  ///
  /// In en, this message translates to:
  /// **'Final set of the workout. Finish strong.'**
  String get cueFinalSet;

  /// No description provided for @builtForYou.
  ///
  /// In en, this message translates to:
  /// **'Built for you'**
  String get builtForYou;

  /// No description provided for @factSchedule.
  ///
  /// In en, this message translates to:
  /// **'{days} days a week, {minutes} minutes each'**
  String factSchedule(int days, int minutes);

  /// No description provided for @factEquipment.
  ///
  /// In en, this message translates to:
  /// **'Training with: {gear}'**
  String factEquipment(String gear);

  /// No description provided for @factBodyweight.
  ///
  /// In en, this message translates to:
  /// **'No equipment needed'**
  String get factBodyweight;

  /// No description provided for @factProtect.
  ///
  /// In en, this message translates to:
  /// **'Going easy on your {joints}'**
  String factProtect(String joints);

  /// No description provided for @factExercises.
  ///
  /// In en, this message translates to:
  /// **'{exercises} exercises across {workouts} workouts'**
  String factExercises(int exercises, int workouts);

  /// No description provided for @trainingDaysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} training days a week'**
  String trainingDaysCount(int count);

  /// No description provided for @planEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit plan'**
  String get planEdit;

  /// No description provided for @planEditDone.
  ///
  /// In en, this message translates to:
  /// **'Done editing'**
  String get planEditDone;

  /// No description provided for @planRenameDay.
  ///
  /// In en, this message translates to:
  /// **'Rename day'**
  String get planRenameDay;

  /// No description provided for @planDayName.
  ///
  /// In en, this message translates to:
  /// **'Day name'**
  String get planDayName;

  /// No description provided for @planDayFull.
  ///
  /// In en, this message translates to:
  /// **'This day is full. Remove an exercise first.'**
  String get planDayFull;

  /// No description provided for @planReorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder {name}'**
  String planReorder(String name);

  /// No description provided for @planRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}'**
  String planRemove(String name);

  /// No description provided for @planRestLine.
  ///
  /// In en, this message translates to:
  /// **'{line} · {seconds} s rest'**
  String planRestLine(String line, int seconds);

  /// No description provided for @planSets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get planSets;

  /// No description provided for @planRepsFrom.
  ///
  /// In en, this message translates to:
  /// **'Reps, from'**
  String get planRepsFrom;

  /// No description provided for @planRepsTo.
  ///
  /// In en, this message translates to:
  /// **'Reps, up to'**
  String get planRepsTo;

  /// No description provided for @planTimeFrom.
  ///
  /// In en, this message translates to:
  /// **'Time, from'**
  String get planTimeFrom;

  /// No description provided for @planTimeTo.
  ///
  /// In en, this message translates to:
  /// **'Time, up to'**
  String get planTimeTo;

  /// No description provided for @planRest.
  ///
  /// In en, this message translates to:
  /// **'Rest between sets'**
  String get planRest;

  /// No description provided for @onbSplitTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you want to split your week?'**
  String get onbSplitTitle;

  /// No description provided for @onbSplitHint.
  ///
  /// In en, this message translates to:
  /// **'Not sure? Keep the first one. You can change any day later.'**
  String get onbSplitHint;

  /// No description provided for @styleAuto.
  ///
  /// In en, this message translates to:
  /// **'Coach\'s pick'**
  String get styleAuto;

  /// No description provided for @styleAutoSub.
  ///
  /// In en, this message translates to:
  /// **'The best fit for your days: each muscle trained about twice a week with time to recover.'**
  String get styleAutoSub;

  /// No description provided for @styleFullBody.
  ///
  /// In en, this message translates to:
  /// **'Full body'**
  String get styleFullBody;

  /// No description provided for @styleFullBodySub.
  ///
  /// In en, this message translates to:
  /// **'Everything, every session. Great when you train two or three days.'**
  String get styleFullBodySub;

  /// No description provided for @styleUpperLower.
  ///
  /// In en, this message translates to:
  /// **'Upper / Lower'**
  String get styleUpperLower;

  /// No description provided for @styleUpperLowerSub.
  ///
  /// In en, this message translates to:
  /// **'Upper body one day, legs the next. Balanced and easy to follow.'**
  String get styleUpperLowerSub;

  /// No description provided for @stylePpl.
  ///
  /// In en, this message translates to:
  /// **'Push / Pull / Legs'**
  String get stylePpl;

  /// No description provided for @stylePplSub.
  ///
  /// In en, this message translates to:
  /// **'Pushing muscles, pulling muscles, then legs. Popular for five or six days.'**
  String get stylePplSub;

  /// No description provided for @styleBodyPart.
  ///
  /// In en, this message translates to:
  /// **'Body part days'**
  String get styleBodyPart;

  /// No description provided for @styleBodyPartSub.
  ///
  /// In en, this message translates to:
  /// **'Chest day, back day, leg day. One or two areas get all your focus.'**
  String get styleBodyPartSub;

  /// No description provided for @planRebuildDay.
  ///
  /// In en, this message translates to:
  /// **'Rebuild this day'**
  String get planRebuildDay;

  /// No description provided for @planRebuildDaySub.
  ///
  /// In en, this message translates to:
  /// **'Pick body parts and get a fresh set of exercises'**
  String get planRebuildDaySub;

  /// No description provided for @planRebuildTitle.
  ///
  /// In en, this message translates to:
  /// **'What should this day train?'**
  String get planRebuildTitle;

  /// No description provided for @planRebuildHint.
  ///
  /// In en, this message translates to:
  /// **'Pick one or more. For example chest and shoulders together.'**
  String get planRebuildHint;

  /// No description provided for @planRebuildAction.
  ///
  /// In en, this message translates to:
  /// **'Build the day'**
  String get planRebuildAction;

  /// No description provided for @shareHeadline.
  ///
  /// In en, this message translates to:
  /// **'My week'**
  String get shareHeadline;

  /// No description provided for @shareLifted.
  ///
  /// In en, this message translates to:
  /// **'lifted this week'**
  String get shareLifted;

  /// No description provided for @shareTopMuscle.
  ///
  /// In en, this message translates to:
  /// **'Most trained: {muscle}'**
  String shareTopMuscle(String muscle);

  /// No description provided for @shareTagline.
  ///
  /// In en, this message translates to:
  /// **'Ripped · the workout plan that adapts to you'**
  String get shareTagline;

  /// No description provided for @shareFormatPost.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get shareFormatPost;

  /// No description provided for @shareFormatStory.
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get shareFormatStory;

  /// No description provided for @shareAction.
  ///
  /// In en, this message translates to:
  /// **'Share or save'**
  String get shareAction;

  /// No description provided for @shareHint.
  ///
  /// In en, this message translates to:
  /// **'Choose where it goes next. Pick Save or Photos to keep it on your phone.'**
  String get shareHint;

  /// No description provided for @hoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String hoursMinutes(int hours, int minutes);

  /// No description provided for @praiseRecords.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{A new personal record. You\'re getting stronger.} other{{count} new personal records. You\'re getting stronger.}}'**
  String praiseRecords(int count);

  /// No description provided for @praiseLevel.
  ///
  /// In en, this message translates to:
  /// **'You reached level {level}. That\'s earned.'**
  String praiseLevel(int level);

  /// No description provided for @praiseWeek.
  ///
  /// In en, this message translates to:
  /// **'All {target} workouts done this week. That\'s how streaks are built.'**
  String praiseWeek(int target);

  /// No description provided for @praiseComeback.
  ///
  /// In en, this message translates to:
  /// **'Good to have you back. The hardest one is done.'**
  String get praiseComeback;

  /// No description provided for @praiseFirst.
  ///
  /// In en, this message translates to:
  /// **'Your first workout is in the books. The start is the hard part.'**
  String get praiseFirst;

  /// No description provided for @praiseProgress.
  ///
  /// In en, this message translates to:
  /// **'Workout {total} done. {left, plural, =1{One more} other{{left} more}} to complete your week.'**
  String praiseProgress(int total, int left);

  /// No description provided for @praiseCount.
  ///
  /// In en, this message translates to:
  /// **'Workout {total} done. You keep showing up.'**
  String praiseCount(int total);

  /// No description provided for @hapticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Vibration feedback'**
  String get hapticsTitle;

  /// No description provided for @hapticsSub.
  ///
  /// In en, this message translates to:
  /// **'A buzz when you log a set, when rest ends and when a workout is saved'**
  String get hapticsSub;

  /// No description provided for @notifyWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Today: {name}'**
  String notifyWorkoutTitle(String name);

  /// No description provided for @notifyCatchUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Yesterday\'s workout is still here'**
  String get notifyCatchUpTitle;

  /// No description provided for @notifyCatchUpBody.
  ///
  /// In en, this message translates to:
  /// **'{name}: do it today, save it for later or skip it. Your call.'**
  String notifyCatchUpBody(String name);

  /// No description provided for @missedTitle.
  ///
  /// In en, this message translates to:
  /// **'You missed {weekday}\'s workout'**
  String missedTitle(String weekday);

  /// No description provided for @missedRest.
  ///
  /// In en, this message translates to:
  /// **'{missed} is still waiting. Today is a rest day, so it\'s up to you.'**
  String missedRest(String missed);

  /// No description provided for @missedTraining.
  ///
  /// In en, this message translates to:
  /// **'{missed} is still waiting. Do it today and {today} moves to your next training day, do both, or skip it.'**
  String missedTraining(String missed, String today);

  /// No description provided for @missedDoIt.
  ///
  /// In en, this message translates to:
  /// **'Do {name} today'**
  String missedDoIt(String name);

  /// No description provided for @missedDoBoth.
  ///
  /// In en, this message translates to:
  /// **'Do both today'**
  String get missedDoBoth;

  /// No description provided for @missedSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip {name}'**
  String missedSkip(String name);

  /// No description provided for @missedKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep it for my next training day'**
  String get missedKeep;

  /// No description provided for @missedSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped. Next up: {name}.'**
  String missedSkipped(String name);

  /// No description provided for @pickWorkout.
  ///
  /// In en, this message translates to:
  /// **'Choose a different workout'**
  String get pickWorkout;

  /// No description provided for @pickWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'What do you want to train?'**
  String get pickWorkoutTitle;

  /// No description provided for @secondWorkout.
  ///
  /// In en, this message translates to:
  /// **'Do {name} too'**
  String secondWorkout(String name);

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'Match phone'**
  String get themeSystem;

  /// No description provided for @themeSystemSub.
  ///
  /// In en, this message translates to:
  /// **'Follows your phone\'s light or dark setting'**
  String get themeSystemSub;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @logoTitle.
  ///
  /// In en, this message translates to:
  /// **'Logo'**
  String get logoTitle;

  /// No description provided for @logoSub.
  ///
  /// In en, this message translates to:
  /// **'Used in the app and on the cards you share. The icon on your home screen stays the same.'**
  String get logoSub;

  /// No description provided for @logoVolt.
  ///
  /// In en, this message translates to:
  /// **'Volt'**
  String get logoVolt;

  /// No description provided for @logoVoltSub.
  ///
  /// In en, this message translates to:
  /// **'Lime on black'**
  String get logoVoltSub;

  /// No description provided for @logoEmber.
  ///
  /// In en, this message translates to:
  /// **'Ember'**
  String get logoEmber;

  /// No description provided for @logoEmberSub.
  ///
  /// In en, this message translates to:
  /// **'Orange on warm black'**
  String get logoEmberSub;

  /// No description provided for @logoChalk.
  ///
  /// In en, this message translates to:
  /// **'Chalk'**
  String get logoChalk;

  /// No description provided for @logoChalkSub.
  ///
  /// In en, this message translates to:
  /// **'Orange on chalk white'**
  String get logoChalkSub;

  /// No description provided for @unitsMetric.
  ///
  /// In en, this message translates to:
  /// **'Kilograms'**
  String get unitsMetric;

  /// No description provided for @unitsImperial.
  ///
  /// In en, this message translates to:
  /// **'Pounds'**
  String get unitsImperial;

  /// No description provided for @editPlan.
  ///
  /// In en, this message translates to:
  /// **'Change goals and plan'**
  String get editPlan;

  /// No description provided for @editPlanSub.
  ///
  /// In en, this message translates to:
  /// **'Re-answer the questions and build a new plan'**
  String get editPlanSub;

  /// No description provided for @viewPlan.
  ///
  /// In en, this message translates to:
  /// **'View current plan'**
  String get viewPlan;

  /// No description provided for @healthDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Health disclaimer'**
  String get healthDisclaimer;

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get credits;

  /// No description provided for @creditsBody.
  ///
  /// In en, this message translates to:
  /// **'Exercise demo videos from Free Exercise DB with Videos by Arham Wani (MIT License). Exercise data and images from free-exercise-db by yuhonas, released into the public domain (Unlicense). Icons: Material Symbols by Google (Apache License 2.0). Fonts: Inter and Barlow Condensed (SIL Open Font License).'**
  String get creditsBody;

  /// No description provided for @playDemo.
  ///
  /// In en, this message translates to:
  /// **'Play demo'**
  String get playDemo;

  /// No description provided for @pauseDemo.
  ///
  /// In en, this message translates to:
  /// **'Pause demo'**
  String get pauseDemo;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @streakWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No streak yet} =1{1-week streak} other{{count}-week streak}}'**
  String streakWeeks(int count);

  /// No description provided for @streakWeeksShort.
  ///
  /// In en, this message translates to:
  /// **'{count}w'**
  String streakWeeksShort(int count);

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String levelLabel(int level);

  /// No description provided for @xpProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {next} XP'**
  String xpProgress(int current, int next);

  /// No description provided for @xpEarned.
  ///
  /// In en, this message translates to:
  /// **'+{amount} XP'**
  String xpEarned(int amount);

  /// No description provided for @titleBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get titleBeginner;

  /// No description provided for @titleRegular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get titleRegular;

  /// No description provided for @titleDedicated.
  ///
  /// In en, this message translates to:
  /// **'Dedicated'**
  String get titleDedicated;

  /// No description provided for @titleAthlete.
  ///
  /// In en, this message translates to:
  /// **'Athlete'**
  String get titleAthlete;

  /// No description provided for @titleLegend.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get titleLegend;

  /// No description provided for @levelUp.
  ///
  /// In en, this message translates to:
  /// **'Level up! You\'re now level {level}.'**
  String levelUp(int level);

  /// No description provided for @newBest.
  ///
  /// In en, this message translates to:
  /// **'New best'**
  String get newBest;

  /// No description provided for @prE1rm.
  ///
  /// In en, this message translates to:
  /// **'Estimated max {value}'**
  String prE1rm(String value);

  /// No description provided for @prReps.
  ///
  /// In en, this message translates to:
  /// **'{reps} reps at {weight}'**
  String prReps(int reps, String weight);

  /// No description provided for @prVolume.
  ///
  /// In en, this message translates to:
  /// **'Session volume {value}'**
  String prVolume(String value);

  /// No description provided for @prPrevious.
  ///
  /// In en, this message translates to:
  /// **'was {value}'**
  String prPrevious(String value);

  /// No description provided for @weekTargetHit.
  ///
  /// In en, this message translates to:
  /// **'Weekly target hit. Streak: {count, plural, =1{1 week} other{{count} weeks}}.'**
  String weekTargetHit(int count);

  /// No description provided for @volumeSpikeNote.
  ///
  /// In en, this message translates to:
  /// **'Big jump in training volume this week. Sleep, eat well, and take your rest days.'**
  String get volumeSpikeNote;

  /// No description provided for @welcomeBackTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBackTitle;

  /// No description provided for @welcomeBackMessage.
  ///
  /// In en, this message translates to:
  /// **'Good to see you. Let\'s ease back in with today\'s session.'**
  String get welcomeBackMessage;

  /// No description provided for @comebackBonus.
  ///
  /// In en, this message translates to:
  /// **'Welcome back bonus'**
  String get comebackBonus;

  /// No description provided for @shieldAvailable.
  ///
  /// In en, this message translates to:
  /// **'Streak shield ready this month'**
  String get shieldAvailable;

  /// No description provided for @shieldUsed.
  ///
  /// In en, this message translates to:
  /// **'Shield used this month'**
  String get shieldUsed;

  /// No description provided for @streakTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly streak'**
  String get streakTitle;

  /// No description provided for @recordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal records'**
  String get recordsTitle;

  /// No description provided for @recordsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Beat a previous session and your records show up here.'**
  String get recordsEmpty;

  /// No description provided for @chartTitle.
  ///
  /// In en, this message translates to:
  /// **'Strength over time'**
  String get chartTitle;

  /// No description provided for @chartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Log a lift twice to see your trend.'**
  String get chartEmpty;

  /// No description provided for @chartEstimatedMax.
  ///
  /// In en, this message translates to:
  /// **'Estimated max'**
  String get chartEstimatedMax;

  /// No description provided for @sectionReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get sectionReminders;

  /// No description provided for @remindersToggle.
  ///
  /// In en, this message translates to:
  /// **'Workout reminders'**
  String get remindersToggle;

  /// No description provided for @remindersSub.
  ///
  /// In en, this message translates to:
  /// **'On your training days'**
  String get remindersSub;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get reminderTime;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Training day'**
  String get reminderTitle;

  /// No description provided for @reminderBody.
  ///
  /// In en, this message translates to:
  /// **'Your workout is ready when you are.'**
  String get reminderBody;

  /// No description provided for @notificationsDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off for Ripped. You can turn them on in system settings.'**
  String get notificationsDenied;

  /// No description provided for @weekOf.
  ///
  /// In en, this message translates to:
  /// **'Week of {date}'**
  String weekOf(String date);

  /// No description provided for @weekDoneOfTarget.
  ///
  /// In en, this message translates to:
  /// **'{done}/{target}'**
  String weekDoneOfTarget(int done, int target);

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Back up your progress'**
  String get backupTitle;

  /// No description provided for @backupMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in so your workouts are safe if you change phones. The app works fully without an account.'**
  String get backupMessage;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get signingIn;

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t sign in with Google. Check your connection and try again.'**
  String get signInFailed;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign out? Your workouts stay on this phone.'**
  String get signOutConfirm;

  /// No description provided for @signedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get signedIn;

  /// No description provided for @sectionDataPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data & privacy'**
  String get sectionDataPrivacy;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export my data'**
  String get exportData;

  /// No description provided for @exportDataSub.
  ///
  /// In en, this message translates to:
  /// **'Everything you\'ve logged, as JSON and CSV'**
  String get exportDataSub;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the export. Please try again.'**
  String get exportFailed;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get terms;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountSub.
  ///
  /// In en, this message translates to:
  /// **'Removes your account and backups'**
  String get deleteAccountSub;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your account and all backed-up data, and clears Ripped on this phone. It can\'t be undone. Export your data first if you want a copy.'**
  String get deleteAccountBody;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete forever'**
  String get deleteAccountConfirm;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your account and data were deleted.'**
  String get accountDeleted;

  /// No description provided for @deleteAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete your account. Check your connection and try again.'**
  String get deleteAccountFailed;

  /// No description provided for @syncedAgo.
  ///
  /// In en, this message translates to:
  /// **'Backed up {time}'**
  String syncedAgo(String time);

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Backing up…'**
  String get syncing;

  /// No description provided for @syncFailed.
  ///
  /// In en, this message translates to:
  /// **'Not backed up yet. We\'ll retry automatically.'**
  String get syncFailed;

  /// No description provided for @syncOtherAccount.
  ///
  /// In en, this message translates to:
  /// **'This phone\'s data belongs to another account, so it isn\'t being backed up here.'**
  String get syncOtherAccount;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get syncNow;

  /// No description provided for @agoJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get agoJustNow;

  /// No description provided for @agoMinutes.
  ///
  /// In en, this message translates to:
  /// **'{n} min ago'**
  String agoMinutes(int n);

  /// No description provided for @agoHours.
  ///
  /// In en, this message translates to:
  /// **'{n} h ago'**
  String agoHours(int n);

  /// No description provided for @agoDays.
  ///
  /// In en, this message translates to:
  /// **'{n} d ago'**
  String agoDays(int n);

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get sendFeedback;

  /// No description provided for @sendFeedbackSub.
  ///
  /// In en, this message translates to:
  /// **'Bugs, ideas, anything. We read every message.'**
  String get sendFeedbackSub;

  /// No description provided for @feedbackSubject.
  ///
  /// In en, this message translates to:
  /// **'Ripped feedback'**
  String get feedbackSubject;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
