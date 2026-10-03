import 'models.dart';

/// Returns human-readable problems with the curation; empty means valid.
/// Pure so it can be unit-tested without network or files.
List<String> validateCuration(
  List<CurationEntry> entries,
  Map<String, Set<String>> sourceIdsBySource, {
  Set<String>? videoSlugs,
}) {
  final errors = <String>[];
  final ids = <String>{};
  final idPattern = RegExp(r'^[a-z0-9_]+$');

  for (final e in entries) {
    if (!idPattern.hasMatch(e.id)) {
      errors.add('${e.id}: id must be lower_snake_case');
    }
    if (!ids.add(e.id)) errors.add('${e.id}: duplicate id');
    if (!movementPatterns.contains(e.pattern)) {
      errors.add('${e.id}: unknown pattern "${e.pattern}"');
    }
    if (e.level != null && !levels.contains(e.level)) {
      errors.add('${e.id}: unknown level "${e.level}"');
    }
    for (final j in e.jointStress) {
      if (!joints.contains(j)) errors.add('${e.id}: unknown joint "$j"');
    }
    final known = sourceIdsBySource[e.source];
    if (known == null) {
      errors.add('${e.id}: unknown source "${e.source}"');
    } else if (!known.contains(e.sourceId)) {
      errors.add('${e.id}: "${e.sourceId}" not found in ${e.source}');
    }
    if (e.video != null &&
        videoSlugs != null &&
        !videoSlugs.contains(e.video)) {
      errors.add('${e.id}: unknown video "${e.video}"');
    }
  }

  for (final e in entries) {
    for (final s in e.substitutes) {
      if (s == e.id) errors.add('${e.id}: lists itself as substitute');
      if (!ids.contains(s)) errors.add('${e.id}: unknown substitute "$s"');
    }
  }
  return errors;
}
