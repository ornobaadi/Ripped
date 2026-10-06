import 'package:flutter/services.dart';
import 'package:ripped/core/catalog/catalog_open_io.dart'
    if (dart.library.js_interop) 'package:ripped/core/catalog/catalog_open_web.dart';
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

  static Future<CatalogRepository> load() async {
    final data = await rootBundle.load(_asset);
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    return CatalogRepository(await loadCatalog(bytes));
  }

  Exercise byId(String id) =>
      _byId[id] ?? (throw StateError('Unknown exercise $id'));

  Exercise? maybe(String id) => _byId[id];
}
