import 'package:ripped/core/catalog/catalog_loader.dart';
import 'package:ripped/domain/catalog/exercise.dart';
import 'package:sqlite3/sqlite3.dart';

List<Exercise>? _cache;

/// The real bundled catalog, so domain tests exercise actual data.
List<Exercise> realCatalog() {
  if (_cache case final cached?) return cached;
  final db = sqlite3.open(
    'assets/catalog/catalog.sqlite',
    mode: OpenMode.readOnly,
  );
  try {
    return _cache = CatalogLoader.load(db);
  } finally {
    db.close();
  }
}
