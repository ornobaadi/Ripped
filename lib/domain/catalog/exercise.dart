/// Read-only exercise from the bundled catalog (architecture.md 4.1).
library;

enum MovementPattern {
  squat,
  hinge,
  lunge,
  horizontalPush,
  verticalPush,
  horizontalPull,
  verticalPull,
  carry,
  coreAntiExtension,
  coreRotation,
  calf,
  isolationArm,
  isolationLeg,
  conditioning,
  mobility;

  static MovementPattern parse(String raw) => switch (raw) {
    'squat' => squat,
    'hinge' => hinge,
    'lunge' => lunge,
    'horizontal_push' => horizontalPush,
    'vertical_push' => verticalPush,
    'horizontal_pull' => horizontalPull,
    'vertical_pull' => verticalPull,
    'carry' => carry,
    'core_anti_extension' => coreAntiExtension,
    'core_rotation' => coreRotation,
    'calf' => calf,
    'isolation_arm' => isolationArm,
    'isolation_leg' => isolationLeg,
    'conditioning' => conditioning,
    'mobility' => mobility,
    _ => throw ArgumentError.value(raw, 'pattern'),
  };

  /// Big bilateral lifts get heavier, lower-rep prescriptions. Lunges are
  /// multi-joint but balance-limited, so they stay in moderate rep ranges.
  bool get isCompound => switch (this) {
    squat || hinge => true,
    horizontalPush || verticalPush || horizontalPull || verticalPull => true,
    _ => false,
  };
}

/// What the user has access to (onboarding step 3).
enum Equipment {
  /// Always available.
  bodyweight,
  dumbbells,
  kettlebells,
  bands,
  pullUpBar,

  /// Barbells, cables, machines, benches, racks: a full gym.
  gym;

  /// Maps catalog equipment strings to the access they require.
  static Equipment fromCatalog(String raw) => switch (raw) {
    'body only' => bodyweight,
    'dumbbell' => dumbbells,
    'kettlebells' => kettlebells,
    'bands' => bands,
    'pull-up bar' => pullUpBar,
    _ => gym,
  };
}

/// Gym members are assumed to have everything.
bool hasAccess(Set<Equipment> owned, Equipment required) =>
    required == Equipment.bodyweight ||
    owned.contains(Equipment.gym) ||
    owned.contains(required);

enum Level {
  beginner,
  intermediate,
  expert;

  static Level parse(String raw) => switch (raw) {
    'beginner' => beginner,
    'intermediate' => intermediate,
    _ => expert,
  };
}

enum Joint {
  knee,
  lowerBack,
  shoulder,
  wrist,
  elbow,
  hip;

  static Joint parse(String raw) => switch (raw) {
    'knee' => knee,
    'lower_back' => lowerBack,
    'shoulder' => shoulder,
    'wrist' => wrist,
    'elbow' => elbow,
    'hip' => hip,
    _ => throw ArgumentError.value(raw, 'joint'),
  };
}

enum MediaKind { image, gif, video }

class ExerciseMedia {
  const new({
    required this.kind,
    required this.uri,
    required this.license,
    required this.attribution,
    this.thumbUri,
    this.variant,
  });

  final MediaKind kind;
  final String uri;
  final String license;
  final String attribution;

  /// Still frame for lists (videos only).
  final String? thumbUri;

  /// "dark" or "light" when the media is baked for one theme, else null.
  final String? variant;
}

extension ExerciseMediaX on Exercise {
  /// The demo video for the given theme ("dark" / "light"), if any.
  ExerciseMedia? videoFor(String variant) => media
      .where((m) => m.kind == MediaKind.video && m.variant == variant)
      .firstOrNull;

  /// Still images (exercises without a video).
  List<ExerciseMedia> get stills =>
      media.where((m) => m.kind == MediaKind.image).toList();

  /// Best still for a thumbnail in the given theme.
  String? thumbFor(String variant) =>
      videoFor(variant)?.thumbUri ?? stills.firstOrNull?.uri;
}

class Exercise {
  const new({
    required this.id,
    required this.name,
    required this.pattern,
    required this.equipment,
    required this.equipmentLabel,
    required this.level,
    required this.priority,
    this.primaryMuscles = const [],
    this.secondaryMuscles = const [],
    this.jointStress = const {},
    this.isBodyweight = false,
    this.unilateral = false,
    this.isTimed = false,
    this.instructions = const [],
    this.media = const [],
    this.substitutes = const [],
  });

  final String id;
  final String name;
  final MovementPattern pattern;
  final Equipment equipment;

  /// Raw catalog label, e.g. "barbell", for display.
  final String equipmentLabel;
  final Level level;

  /// Higher = preferred by the plan generator.
  final int priority;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;
  final Set<Joint> jointStress;
  final bool isBodyweight;
  final bool unilateral;

  /// Prescribed in seconds instead of reps.
  final bool isTimed;
  final List<String> instructions;
  final List<ExerciseMedia> media;

  /// Ranked substitute exercise ids.
  final List<String> substitutes;

  /// Loaded exercises track weight. Bodyweight, cardio and mobility work
  /// only track reps or time.
  bool get isWeighted =>
      !isBodyweight &&
      pattern != MovementPattern.conditioning &&
      pattern != MovementPattern.mobility;

  @override
  String toString() => 'Exercise($id)';
}
