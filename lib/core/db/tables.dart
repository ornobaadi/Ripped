import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Time-ordered UUIDv7: unique offline and sorts by creation time.
String newId() => _uuid.v7();

/// Shared columns for every user table (architecture.md 4.2): client UUIDv7
/// ids so offline rows never collide, and soft deletes for future sync.
mixin SyncColumns on Table {
  TextColumn get id => text().clientDefault(newId)();

  /// Null until the user signs in (Phase 3).
  TextColumn get userId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Onboarding answers. One active row.
class Profiles extends Table with SyncColumns {
  TextColumn get goal => text()();
  TextColumn get experience => text()();

  /// JSON list of Equipment names.
  TextColumn get equipment => text()();
  IntColumn get daysPerWeek => integer()();

  /// JSON list of ISO weekdays.
  TextColumn get preferredDays => text()();
  IntColumn get sessionMinutes => integer()();

  /// JSON list of Joint names.
  TextColumn get avoid => text()();
  TextColumn get units => text()();
  DateTimeColumn get onboardingDoneAt => dateTime().nullable()();
  DateTimeColumn get disclaimerAcceptedAt => dateTime().nullable()();
}

class Programs extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get splitType => text()();
  IntColumn get generatedByVersion => integer()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get startedAt => dateTime()();
}

class ProgramDays extends Table with SyncColumns {
  TextColumn get programId => text().references(Programs, #id)();
  IntColumn get dayIndex => integer()();
  TextColumn get name => text()();
}

class ProgramExercises extends Table with SyncColumns {
  TextColumn get programDayId => text().references(ProgramDays, #id)();

  /// Catalog exercise id (stable across catalog versions).
  TextColumn get exerciseId => text()();
  IntColumn get sortOrder => integer()();
  IntColumn get sets => integer()();
  IntColumn get repMin => integer()();
  IntColumn get repMax => integer()();
  IntColumn get restSeconds => integer()();
  TextColumn get reason => text()();
}

enum WorkoutStatus { inProgress, completed, abandoned }

class Workouts extends Table with SyncColumns {
  TextColumn get programDayId =>
      text().nullable().references(ProgramDays, #id)();

  /// Program day index at the time, for the rotation.
  IntColumn get dayIndex => integer().nullable()();
  TextColumn get name => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();
  IntColumn get durationS => integer().nullable()();
  TextColumn get feeling => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get status => textEnum<WorkoutStatus>()();
}

class WorkoutExercises extends Table with SyncColumns {
  TextColumn get workoutId => text().references(Workouts, #id)();
  TextColumn get exerciseId => text()();
  IntColumn get sortOrder => integer()();
  IntColumn get repMin => integer()();
  IntColumn get repMax => integer()();
  IntColumn get restSeconds => integer()();
  BoolColumn get skipped => boolean().withDefault(const Constant(false))();
}

/// Rows are created pre-filled when the workout starts; `completedAt` is
/// set the moment a set is logged.
class WorkoutSets extends Table with SyncColumns {
  TextColumn get workoutExerciseId =>
      text().references(WorkoutExercises, #id)();
  IntColumn get setIndex => integer()();

  /// Always kg; null for unloaded work.
  RealColumn get weightKg => real().nullable()();

  /// Reps, or seconds for timed exercises.
  IntColumn get reps => integer()();
  IntColumn get targetReps => integer()();
  IntColumn get rpe => integer().nullable()();
  BoolColumn get isWarmup => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
}

/// Progression memory per exercise.
class ExerciseStates extends Table with SyncColumns {
  TextColumn get exerciseId => text().unique()();
  RealColumn get currentWeightKg => real().nullable()();
  IntColumn get currentRepTarget => integer()();
  IntColumn get stallCount => integer().withDefault(const Constant(0))();
  IntColumn get lastTotalReps => integer().withDefault(const Constant(0))();
  TextColumn get lastDecision => text().nullable()();
  DateTimeColumn get lastProgressedAt => dateTime().nullable()();
}

/// Local key/value preferences. Device-scoped, never synced.
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
