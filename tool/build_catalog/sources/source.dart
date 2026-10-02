import 'dart:typed_data';

import '../src/models.dart';

/// One adapter per exercise data source (architecture.md 9). Swapping or
/// adding a media source only means writing another adapter.
abstract interface class CatalogSource {
  /// Key used in curation.yaml `source:`.
  String get key;

  /// License + attribution recorded on every asset from this source.
  String get license;
  String get attribution;

  Future<List<RawExercise>> fetchExercises();

  Future<Uint8List> fetchImage(String path);
}
