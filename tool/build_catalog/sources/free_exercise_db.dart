import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../src/models.dart';
import 'source.dart';

/// yuhonas/free-exercise-db, Unlicense (public domain).
/// Always fetched at a pinned commit so builds are reproducible.
class FreeExerciseDbSource implements CatalogSource {
  const new(this.ref, {required this.cacheDir});

  final String ref;
  final Directory cacheDir;

  String get _base =>
      'https://raw.githubusercontent.com/yuhonas/free-exercise-db/$ref';

  @override
  String get key => 'free_exercise_db';

  @override
  String get license => 'Unlicense (public domain)';

  @override
  String get attribution =>
      'free-exercise-db by yuhonas (github.com/yuhonas/free-exercise-db)';

  @override
  Future<List<RawExercise>> fetchExercises() async {
    final bytes = await _cachedGet('dist/exercises.json');
    final list = jsonDecode(utf8.decode(bytes)) as List<dynamic>;
    return [
      for (final e in list.cast<Map<String, dynamic>>())
        RawExercise(
          sourceId: e['id'] as String,
          name: e['name'] as String,
          level: e['level'] as String,
          equipment: (e['equipment'] as String?) ?? 'body only',
          mechanic: e['mechanic'] as String?,
          primaryMuscles: (e['primaryMuscles'] as List).cast<String>(),
          secondaryMuscles: (e['secondaryMuscles'] as List).cast<String>(),
          instructions: (e['instructions'] as List).cast<String>(),
          imagePaths: (e['images'] as List).cast<String>(),
        ),
    ];
  }

  @override
  Future<Uint8List> fetchImage(String path) => _cachedGet('exercises/$path');

  /// Downloads once per ref into the cache dir (git-ignored).
  Future<Uint8List> _cachedGet(String path) async {
    final file = File('${cacheDir.path}/$ref/$path');
    if (file.existsSync()) return await file.readAsBytes();

    final client = HttpClient();
    try {
      final req = await client.getUrl(Uri.parse('$_base/$path'));
      final res = await req.close();
      if (res.statusCode != 200) {
        throw HttpException('GET $path -> ${res.statusCode}');
      }
      final builder = BytesBuilder(copy: false);
      await res.forEach(builder.add);
      final bytes = builder.takeBytes();
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes);
      return bytes;
    } finally {
      client.close();
    }
  }
}
