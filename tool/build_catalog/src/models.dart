/// Movement patterns used by the plan generator (architecture.md 4.1).
const movementPatterns = {
  'squat',
  'hinge',
  'lunge',
  'horizontal_push',
  'vertical_push',
  'horizontal_pull',
  'vertical_pull',
  'carry',
  'core_anti_extension',
  'core_rotation',
  'calf',
  'isolation_arm',
  'isolation_leg',
  'conditioning',
  'mobility',
};

const levels = {'beginner', 'intermediate', 'expert'};

const joints = {'knee', 'lower_back', 'shoulder', 'wrist', 'elbow', 'hip'};

/// One exercise as delivered by a source adapter, before curation.
class RawExercise {
  const new({
    required this.sourceId,
    required this.name,
    required this.level,
    required this.equipment,
    required this.mechanic,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    required this.instructions,
    required this.imagePaths,
  });

  final String sourceId;
  final String name;
  final String level;
  final String equipment;
  final String? mechanic;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;
  final List<String> instructions;

  /// Source-relative image paths; the adapter knows how to fetch them.
  final List<String> imagePaths;
}

/// Our curation layer on top of a source entry (curation.yaml).
class CurationEntry {
  const new({
    required this.id,
    required this.source,
    required this.sourceId,
    required this.pattern,
    required this.priority,
    this.name,
    this.level,
    this.equipment,
    this.jointStress = const [],
    this.substitutes = const [],
    this.isBodyweight = false,
    this.unilateral = false,
    this.timed = false,
    this.video,
  });

  factory fromYaml(Map<dynamic, dynamic> y) => CurationEntry(
    id: y['id'] as String,
    source: y['source'] as String,
    sourceId: y['source_id'] as String,
    pattern: y['pattern'] as String,
    priority: (y['priority'] as int?) ?? 50,
    name: y['name'] as String?,
    level: y['level'] as String?,
    equipment: y['equipment'] as String?,
    jointStress: [...?(y['joint_stress'] as List?)?.cast<String>()],
    substitutes: [...?(y['substitutes'] as List?)?.cast<String>()],
    isBodyweight: (y['bodyweight'] as bool?) ?? false,
    unilateral: (y['unilateral'] as bool?) ?? false,
    timed: (y['timed'] as bool?) ?? false,
    video: y['video'] as String?,
  );

  final String id;
  final String source;
  final String sourceId;
  final String pattern;
  final int priority;
  final String? name;
  final String? level;
  final String? equipment;
  final List<String> jointStress;
  final List<String> substitutes;
  final bool isBodyweight;
  final bool unilateral;

  /// Prescribed in seconds instead of reps (planks, carries, stretches).
  final bool timed;

  /// Demo video slug in the video source; null keeps the still images.
  final String? video;
}

/// One media item. Kind is image | gif | video (PRD 8: media-agnostic).
class MediaItem {
  const new({
    required this.kind,
    required this.uri,
    required this.license,
    required this.attribution,
    this.thumbUri,
    this.variant,
  });

  final String kind;
  final String uri;
  final String? thumbUri;
  final String? variant;
  final String license;
  final String attribution;

  Map<String, Object?> toJson() => {
    'kind': kind,
    'uri': uri,
    'thumb_uri': thumbUri,
    'variant': variant,
    'license': license,
    'attribution': attribution,
  };
}
