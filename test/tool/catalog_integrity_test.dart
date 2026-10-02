import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../tool/build_catalog/src/models.dart';

/// Guards the committed catalog: Phase 0 exit criteria require every
/// exercise to carry license + attribution and every media file to exist.
void main() {
  late Database db;

  setUpAll(() => db = sqlite3.open('assets/catalog/catalog.sqlite'));
  tearDownAll(() => db.close());

  test('has the curated exercise set', () {
    final count = db.select('SELECT COUNT(*) AS n FROM exercises').first['n'];
    expect(count, greaterThanOrEqualTo(150));
  });

  test('every exercise has license, attribution and known pattern', () {
    for (final row in db.select('SELECT * FROM exercises')) {
      final id = row['id'] as String;
      expect(row['license'], isNotEmpty, reason: id);
      expect(row['attribution'], isNotEmpty, reason: id);
      expect(movementPatterns, contains(row['pattern']), reason: id);
    }
  });

  test('every media item exists on disk and is licensed', () {
    for (final row in db.select('SELECT id, media FROM exercises')) {
      final media = (jsonDecode(row['media'] as String) as List)
          .cast<Map<String, dynamic>>();
      expect(media, isNotEmpty, reason: row['id'] as String);
      for (final m in media) {
        expect(File(m['uri'] as String).existsSync(), isTrue, reason: '$m');
        expect(m['license'], isNotEmpty);
      }
    }
  });

  test('substitutes point at real exercises', () {
    final orphans = db.select('''
      SELECT s.exercise_id, s.substitute_id FROM exercise_substitutes s
      LEFT JOIN exercises e ON e.id = s.substitute_id
      WHERE e.id IS NULL
    ''');
    expect(orphans, isEmpty);
  });

  test('every pattern the plan generator needs is covered', () {
    final patterns = {
      for (final r in db.select('SELECT DISTINCT pattern FROM exercises'))
        r['pattern'] as String,
    };
    expect(patterns, containsAll(movementPatterns));
  });
}
