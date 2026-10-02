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

  /// No description provided for @mediaCredit.
  ///
  /// In en, this message translates to:
  /// **'Image: {attribution}'**
  String mediaCredit(String attribution);

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
  /// **'Exercise data and images from free-exercise-db by yuhonas, released into the public domain (Unlicense). Fonts: Inter and Barlow Condensed (SIL Open Font License).'**
  String get creditsBody;

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
