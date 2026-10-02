import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

import '../../tool/build_catalog/src/models.dart';
import '../../tool/build_catalog/src/validate.dart';

CurationEntry entry(
  String id, {
  String sourceId = 'Src',
  String pattern = 'squat',
  List<String> substitutes = const [],
  List<String> jointStress = const [],
}) => CurationEntry(
  id: id,
  source: 'src',
  sourceId: sourceId,
  pattern: pattern,
  priority: 50,
  substitutes: substitutes,
  jointStress: jointStress,
);

void main() {
  final known = {
    'src': {'Src', 'Other'},
  };

  test('valid curation has no errors', () {
    final errors = validateCuration([
      entry('a', substitutes: ['b']),
      entry('b', sourceId: 'Other'),
    ], known);
    expect(errors, isEmpty);
  });

  test('reports every kind of problem', () {
    final errors = validateCuration([
      entry('Bad-Id'),
      entry('dup'),
      entry('dup'),
      entry('p', pattern: 'twerk'),
      entry('j', jointStress: ['toe']),
      entry('s', sourceId: 'Missing'),
      entry('self', substitutes: ['self', 'ghost']),
    ], known);

    expect(errors, contains('Bad-Id: id must be lower_snake_case'));
    expect(errors, contains('dup: duplicate id'));
    expect(errors, contains('p: unknown pattern "twerk"'));
    expect(errors, contains('j: unknown joint "toe"'));
    expect(errors, contains('s: "Missing" not found in src'));
    expect(errors, contains('self: lists itself as substitute'));
    expect(errors, contains('self: unknown substitute "ghost"'));
  });

  test('curation.yaml is internally consistent', () {
    final yaml = loadYaml(
      File('tool/build_catalog/curation.yaml').readAsStringSync(),
    ) as YamlMap;
    final entries = [
      for (final e in yaml['exercises'] as YamlList)
        CurationEntry.fromYaml(e as YamlMap),
    ];
    // Source ids are checked against the real dataset by the build itself.
    final ids = {for (final e in entries) e.sourceId};
    final errors = validateCuration(entries, {'free_exercise_db': ids});
    expect(errors, isEmpty);
  });
}
