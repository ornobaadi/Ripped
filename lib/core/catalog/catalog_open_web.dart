import 'dart:typed_data';

import 'package:ripped/core/catalog/catalog_loader.dart';
import 'package:ripped/domain/catalog/exercise.dart';
import 'package:sqlite3/wasm.dart';

/// Web (for trying the app in a browser): sqlite compiled to WebAssembly
/// (`web/sqlite3.wasm`) reads the catalog from an in-memory file.
Future<List<Exercise>> loadCatalog(Uint8List bytes) async {
  final sqlite = await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'));
  final fs = InMemoryFileSystem();
  fs
      .xOpen(
        Sqlite3Filename('/catalog.sqlite'),
        SqlFlag.SQLITE_OPEN_CREATE | SqlFlag.SQLITE_OPEN_READWRITE,
      )
      .file
    ..xWrite(bytes, 0)
    ..xClose();
  sqlite.registerVirtualFileSystem(fs, makeDefault: true);
  final db = sqlite.open('/catalog.sqlite', mode: OpenMode.readOnly);
  try {
    return CatalogLoader.load(db);
  } finally {
    db.close();
  }
}
