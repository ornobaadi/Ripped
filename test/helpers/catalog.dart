import 'dart:io';

import 'package:ripped/core/catalog/catalog_loader.dart';
import 'package:ripped/domain/catalog/exercise.dart';

List<Exercise>? _cache;

/// The real bundled catalog, so domain tests exercise actual data.
List<Exercise> realCatalog() =>
    _cache ??= CatalogLoader.loadFile(File('assets/catalog/catalog.sqlite'));
