import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// Demo videos from "Free Exercise DB with Videos" (Arham Wani). Matched to
/// our exercises by hand via `video:` slugs in curation.yaml, then cropped,
/// re-encoded and bundled, so nothing is fetched at runtime.
class ExerciseVideoDb {
  const new({required this.cacheDir});

  final Directory cacheDir;

  static const _api =
      'https://free-exercise-db-api.vercel.app/api/v1/exercises?limit=1000';

  String get license => 'MIT';

  String get attribution =>
      'Free Exercise DB with Videos by Arham Wani '
      '(exercise-database.zenithfits.com)';

  /// Slug (the video file name) -> download URL. Male demo when there is
  /// one, female otherwise.
  Future<Map<String, String>> fetchIndex() async {
    final bytes = await _cachedGet(_api, 'exercises.json');
    final data =
        (jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>)['data']
            as List<dynamic>;
    final index = <String, String>{};
    for (final e in data.cast<Map<String, dynamic>>()) {
      final videos = (e['videos'] as Map<String, dynamic>?) ?? const {};
      final url = (videos['male'] ?? videos['female']) as String?;
      if (url == null) continue;
      final slug = url.split('/').last.replaceAll('.mp4', '');
      index[slug] = url;
    }
    return index;
  }

  /// Downloads (once) and returns the local path of the source video.
  Future<File> fetchVideo(String slug, String url) async {
    await _cachedGet(url, 'videos/$slug.mp4');
    return File('${cacheDir.path}/video_db/videos/$slug.mp4');
  }

  Future<Uint8List> _cachedGet(String url, String name) async {
    final file = File('${cacheDir.path}/video_db/$name');
    if (file.existsSync()) return await file.readAsBytes();

    final client = HttpClient();
    try {
      final res = await (await client.getUrl(Uri.parse(url))).close();
      if (res.statusCode != 200) {
        throw HttpException('GET $url -> ${res.statusCode}');
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
