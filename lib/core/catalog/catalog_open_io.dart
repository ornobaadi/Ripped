import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:ripped/core/catalog/catalog_loader.dart';
import 'package:ripped/domain/catalog/exercise.dart';
import 'package:sqlite3/sqlite3.dart';

/// sqlite can't read from inside the APK, so the asset is copied to app
/// storage, keyed by a content hash so a new catalog build replaces the
/// old copy.
Future<List<Exercise>> loadCatalog(Uint8List bytes) async {
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
  final db = sqlite3.open(file.path, mode: OpenMode.readOnly);
  try {
    return CatalogLoader.load(db);
  } finally {
    db.close();
  }
}

/// 32-bit FNV-1a: fast, stable, good enough to detect a changed file.
String _fnv1a(Uint8List bytes) {
  var hash = 0x811c9dc5;
  for (final b in bytes) {
    hash = ((hash ^ b) * 0x01000193) & 0xffffffff;
  }
  return hash.toRadixString(16);
}
