import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ripped/core/catalog/catalog_loader.dart';
import 'package:ripped/domain/catalog/exercise.dart';

/// In-memory exercise catalog. Loaded once at startup from the bundled
/// sqlite asset; lookups are synchronous afterwards.
class CatalogRepository {
  new(List<Exercise> exercises)
    : all = List.unmodifiable(exercises),
      _byId = {for (final e in exercises) e.id: e};

  final List<Exercise> all;
  final Map<String, Exercise> _byId;

  static const _asset = 'assets/catalog/catalog.sqlite';

  /// sqlite can't read from inside the APK, so the asset is copied to app
  /// storage, keyed by a content hash so a new catalog build replaces the
  /// old copy.
  static Future<CatalogRepository> load() async {
    final data = await rootBundle.load(_asset);
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/catalog_${_fnv1a(bytes)}.sqlite');
    if (!file.existsSync()) {
      for (final old in dir.listSync().whereType<File>()) {
        if (old.uri.pathSegments.last.startsWith('catalog_')) {
          await old.delete();
        }
      }
      await file.writeAsBytes(bytes, flush: true);
    }
    return CatalogRepository(CatalogLoader.loadFile(file));
  }

  /// 32-bit FNV-1a: fast, stable, good enough to detect a changed file.
  static String _fnv1a(Uint8List bytes) {
    var hash = 0x811c9dc5;
    for (final b in bytes) {
      hash = ((hash ^ b) * 0x01000193) & 0xffffffff;
    }
    return hash.toRadixString(16);
  }

  Exercise byId(String id) =>
      _byId[id] ?? (throw StateError('Unknown exercise $id'));

  Exercise? maybe(String id) => _byId[id];
}
