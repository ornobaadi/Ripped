// Builds assets/catalog/catalog.sqlite + images + ATTRIBUTIONS.md from
// openly licensed sources and our curation.yaml (architecture.md 9).
//
//   dart run tool/build_catalog/build_catalog.dart
//
// Fails (exit 1) on any curation error, so a bad catalog never ships.
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:sqlite3/sqlite3.dart';
import 'package:yaml/yaml.dart';

import 'sources/exercise_video_db.dart';
import 'sources/free_exercise_db.dart';
import 'sources/source.dart';
import 'src/models.dart';
import 'src/validate.dart';

/// Bump when the catalog schema or content changes.
const catalogVersion = 3;
const maxImageSize = 720;

/// Demo videos: square, muted, looping, baked onto the media tile colour of
/// each theme (AppColors.surfaceRaised) so they sit flush in the UI.
const videoSize = 540;
const videoBackgrounds = {'dark': '0x202328', 'light': '0xF2F2F0'};

Future<void> main() async {
  final root = Directory.current.path;
  final curationFile = File('$root/tool/build_catalog/curation.yaml');
  final yaml = loadYaml(await curationFile.readAsString()) as YamlMap;
  final cacheDir = Directory('$root/.dart_tool/catalog_cache');
  final outDir = Directory('$root/assets/catalog');

  final sourcesYaml = yaml['sources'] as YamlMap;
  final sources = <String, CatalogSource>{
    'free_exercise_db': FreeExerciseDbSource(
      (sourcesYaml['free_exercise_db'] as YamlMap)['ref'] as String,
      cacheDir: cacheDir,
    ),
  };

  final entries = [
    for (final e in yaml['exercises'] as YamlList)
      CurationEntry.fromYaml(e as YamlMap),
  ];

  final videoDb = ExerciseVideoDb(cacheDir: cacheDir);

  stdout.writeln('Fetching sources...');
  final videoIndex = await videoDb.fetchIndex();
  final raw = <String, Map<String, RawExercise>>{
    for (final s in sources.values)
      s.key: {for (final r in await s.fetchExercises()) r.sourceId: r},
  };

  final errors = validateCuration(entries, {
    for (final MapEntry(:key, :value) in raw.entries) key: value.keys.toSet(),
  }, videoSlugs: videoIndex.keys.toSet());
  if (errors.isNotEmpty) {
    stderr.writeln('Curation has ${errors.length} problem(s):');
    for (final e in errors) {
      stderr.writeln('  - $e');
    }
    exit(1);
  }

  if (outDir.existsSync()) await outDir.delete(recursive: true);
  await Directory('${outDir.path}/images').create(recursive: true);
  await Directory('${outDir.path}/videos').create(recursive: true);
  final db = sqlite3.open('${outDir.path}/catalog.sqlite');
  _createSchema(db);

  final insert = db.prepare('''
    INSERT INTO exercises (id, slug, name, primary_muscles, secondary_muscles,
      equipment, pattern, level, mechanic, joint_stress, is_bodyweight,
      unilateral, is_timed, priority, instructions, media, source, source_id, license,
      attribution, catalog_version)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  ''');
  final insertSub = db.prepare(
    'INSERT INTO exercise_substitutes VALUES (?, ?, ?)',
  );

  db.execute('BEGIN');
  for (final e in entries) {
    final source = sources[e.source]!;
    final r = raw[e.source]![e.sourceId]!;
    final media = <MediaItem>[];
    if (e.video case final slug?) {
      final src = await videoDb.fetchVideo(slug, videoIndex[slug]!);
      final crop = await _motionCrop(src);
      for (final MapEntry(key: variant, value: bg)
          in videoBackgrounds.entries) {
        final rel = 'assets/catalog/videos/${e.id}_$variant.mp4';
        final thumb = 'assets/catalog/videos/${e.id}_$variant.webp';
        await _writeVideo(
          src,
          crop,
          bg,
          File('$root/$rel'),
          File('$root/$thumb'),
        );
        media.add(
          MediaItem(
            kind: 'video',
            uri: rel,
            thumbUri: thumb,
            variant: variant,
            license: videoDb.license,
            attribution: videoDb.attribution,
          ),
        );
      }
    }
    // Stills only where there's no video; keeps the app small.
    for (final (i, path)
        in media.isEmpty ? r.imagePaths.indexed : const <(int, String)>[]) {
      // Flat folder: Flutter asset entries don't include subdirectories.
      final rel = 'assets/catalog/images/${e.id}_$i.$imageExt';
      await _writeImage(await source.fetchImage(path), File('$root/$rel'));
      media.add(
        MediaItem(
          kind: 'image',
          uri: rel,
          license: source.license,
          attribution: source.attribution,
        ),
      );
    }
    insert.execute([
      e.id,
      e.id.replaceAll('_', '-'),
      e.name ?? r.name,
      jsonEncode(r.primaryMuscles),
      jsonEncode(r.secondaryMuscles),
      e.equipment ?? r.equipment,
      e.pattern,
      e.level ?? r.level,
      r.mechanic,
      jsonEncode(e.jointStress),
      _bool(e.isBodyweight || r.equipment == 'body only'),
      _bool(e.unilateral),
      _bool(e.timed),
      e.priority,
      jsonEncode(r.instructions),
      jsonEncode([for (final m in media) m.toJson()]),
      e.source,
      e.sourceId,
      source.license,
      source.attribution,
      catalogVersion,
    ]);
    for (final (rank, sub) in e.substitutes.indexed) {
      insertSub.execute([e.id, sub, rank]);
    }
    stdout.write('.');
  }
  db
    ..execute('COMMIT')
    ..execute('PRAGMA user_version = $catalogVersion')
    ..execute('VACUUM')
    ..close();

  await _writeAttributions(
    File('${outDir.path}/ATTRIBUTIONS.md'),
    sources,
    videoDb,
  );
  stdout.writeln('\nBuilt ${entries.length} exercises -> ${outDir.path}');
}

int _bool(bool value) => value ? 1 : 0;

void _createSchema(Database db) {
  db
    ..execute('''
      CREATE TABLE exercises (
        id TEXT PRIMARY KEY NOT NULL,
        slug TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        primary_muscles TEXT NOT NULL,
        secondary_muscles TEXT NOT NULL,
        equipment TEXT NOT NULL,
        pattern TEXT NOT NULL,
        level TEXT NOT NULL,
        mechanic TEXT,
        joint_stress TEXT NOT NULL,
        is_bodyweight INTEGER NOT NULL,
        unilateral INTEGER NOT NULL,
        is_timed INTEGER NOT NULL,
        priority INTEGER NOT NULL,
        instructions TEXT NOT NULL,
        form_cues TEXT,
        common_mistakes TEXT,
        media TEXT NOT NULL,
        source TEXT NOT NULL,
        source_id TEXT NOT NULL,
        license TEXT NOT NULL,
        attribution TEXT NOT NULL,
        catalog_version INTEGER NOT NULL
      )''')
    ..execute('''
      CREATE TABLE exercise_substitutes (
        exercise_id TEXT NOT NULL REFERENCES exercises(id),
        substitute_id TEXT NOT NULL REFERENCES exercises(id),
        rank INTEGER NOT NULL,
        PRIMARY KEY (exercise_id, substitute_id)
      )''')
    ..execute('CREATE INDEX idx_exercises_pattern ON exercises(pattern)');
}

/// WebP via ffmpeg when available (about half the size of JPEG), else JPEG.
final bool _hasFfmpeg = () {
  try {
    return Process.runSync('ffmpeg', ['-version']).exitCode == 0;
  } on ProcessException {
    return false;
  }
}();

String get imageExt => _hasFfmpeg ? 'webp' : 'jpg';

/// Resizes to <= [maxImageSize] px and re-encodes, which strips metadata.
Future<void> _writeImage(Uint8List bytes, File out) async {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) throw StateError('Cannot decode ${out.path}');
  final resized = decoded.width > maxImageSize || decoded.height > maxImageSize
      ? img.copyResize(
          decoded,
          width: decoded.width >= decoded.height ? maxImageSize : null,
          height: decoded.height > decoded.width ? maxImageSize : null,
        )
      : decoded;
  resized.exif.clear();
  await out.parent.create(recursive: true);
  final jpg = img.encodeJpg(resized, quality: 90);
  if (!_hasFfmpeg) {
    await out.writeAsBytes(img.encodeJpg(resized, quality: 80));
    return;
  }
  final tmp = File('${out.path}.tmp.jpg');
  await tmp.writeAsBytes(jpg);
  final result = await Process.run('ffmpeg', [
    '-y',
    '-loglevel',
    'error',
    '-i',
    tmp.path,
    '-map_metadata',
    '-1',
    '-c:v',
    'libwebp',
    '-quality',
    '75',
    out.path,
  ]);
  await tmp.delete();
  if (result.exitCode != 0) {
    throw ProcessException('ffmpeg', [], '${result.stderr}', result.exitCode);
  }
}

Future<void> _writeAttributions(
  File out,
  Map<String, CatalogSource> sources,
  ExerciseVideoDb videoDb,
) async {
  final b = StringBuffer()
    ..writeln('# Exercise data attributions')
    ..writeln()
    ..writeln('Generated by tool/build_catalog. Shown in Settings > Credits.')
    ..writeln();
  for (final s in sources.values) {
    b
      ..writeln('- **${s.key}** — ${s.attribution}')
      ..writeln('  License: ${s.license}');
  }
  b
    ..writeln('- **exercise_video_db** — ${videoDb.attribution}')
    ..writeln('  License: ${videoDb.license}');
  await out.writeAsString(b.toString());
}

/// Square crop (x, y, side) around everything that moves, from a quick pass
/// over low-res greyscale frames. Background is white; the figure isn't.
Future<(int, int, int)> _motionCrop(File src) async {
  const w = 240;
  final probe = await Process.run('ffprobe', [
    '-v',
    'error',
    '-select_streams',
    'v:0',
    '-show_entries',
    'stream=width,height',
    '-of',
    'csv=p=0',
    src.path,
  ]);
  final [srcW, srcH] = (probe.stdout as String)
      .trim()
      .split(',')
      .map(int.parse)
      .toList();
  final h = (srcH * w / srcW).round();
  final res = await Process.run('ffmpeg', [
    '-loglevel',
    'error',
    '-i',
    src.path,
    '-vf',
    'fps=4,scale=$w:$h,format=gray',
    '-f',
    'rawvideo',
    '-',
  ], stdoutEncoding: null);
  if (res.exitCode != 0) {
    throw ProcessException('ffmpeg', [], '${res.stderr}', res.exitCode);
  }
  final px = res.stdout as List<int>;
  var (x0, y0, x1, y1) = (w, h, 0, 0);
  for (var i = 0; i < px.length; i++) {
    if (px[i] > 235) continue;
    final x = i % w;
    final y = (i ~/ w) % h;
    if (x < x0) x0 = x;
    if (x > x1) x1 = x;
    if (y < y0) y0 = y;
    if (y > y1) y1 = y;
  }
  final scale = srcW / w;
  final side = max(x1 - x0, y1 - y0) * scale * 1.12;
  final cx = (x0 + x1) / 2 * scale;
  final cy = (y0 + y1) / 2 * scale;
  return ((cx - side / 2).round(), (cy - side / 2).round(), side.round());
}

/// Muted looping H.264 + a still of the first frame for list thumbnails.
/// White is keyed out and replaced with the theme's tile colour.
Future<void> _writeVideo(
  File src,
  (int, int, int) crop,
  String background,
  File out,
  File thumb,
) async {
  final (x, y, side) = crop;
  // Pad generously with white so a crop near the edge never fails.
  final pad = side;
  // Only white that is really background goes: white connected to the
  // frame edge (flood fill), plus large pure-white areas trapped inside
  // machine frames. A plain colour key also ate the white highlights on the
  // body. The mask is feathered so edges stay smooth.
  const p = videoSize;
  final erode = 'erosion,' * 10;
  final dilate = 'dilation,' * 11;
  final graph =
      '[0:v]fps=24,pad=iw+${2 * pad}:ih+${2 * pad}:$pad:$pad:white,'
      'crop=$side:$side:${x + pad}:${y + pad},'
      'scale=$p:$p:flags=lanczos,pad=iw+8:ih+8:4:4:white,format=gbrp,'
      'split=4[src][m1][m2][b0];'
      "[m1]format=gray,lut=y='if(gte(val,243),255,0)',"
      "floodfill=x=0:y=0:s0=255:d0=128,lut=y='if(eq(val,128),255,0)'[flood];"
      "[m2]format=gray,lut=y='if(gte(val,253),255,0)',"
      '$erode${dilate}null[holes];'
      '[flood][holes]blend=all_mode=lighten,dilation,gblur=sigma=0.8,'
      'format=gbrp[a];'
      '[b0]drawbox=color=$background:t=fill,format=gbrp[bg];'
      '[src][bg][a]maskedmerge,crop=$p:$p:4:4,format=yuv420p';
  Future<void> run(List<String> args) async {
    final r = await Process.run('ffmpeg', [
      '-y',
      '-loglevel',
      'error',
      ...args,
    ]);
    if (r.exitCode != 0) {
      throw ProcessException('ffmpeg', args, '${r.stderr}', r.exitCode);
    }
  }

  await run([
    '-i',
    src.path,
    '-filter_complex',
    graph,
    '-an',
    '-map_metadata',
    '-1',
    '-c:v',
    'libx264',
    '-preset',
    'slow',
    '-crf',
    '24',
    '-profile:v',
    'main',
    '-movflags',
    '+faststart',
    out.path,
  ]);
  await run([
    '-i',
    out.path,
    '-vf',
    'scale=240:240:flags=lanczos',
    '-frames:v',
    '1',
    '-map_metadata',
    '-1',
    '-c:v',
    'libwebp',
    '-quality',
    '80',
    thumb.path,
  ]);
}
