import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/catalog/exercise.dart';

/// Square exercise image from the bundled catalog, with a neutral
/// placeholder so layouts never jump if media is missing.
class ExerciseThumb extends StatelessWidget {
  const new({required this.exercise, this.size = 56, super.key});

  final Exercise exercise;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final image = exercise.media
        .where((m) => m.kind == MediaKind.image)
        .firstOrNull;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: SizedBox.square(
          dimension: size,
          child: image == null
              ? ColoredBox(
                  color: c.surfaceRaised,
                  child: Icon(Symbols.exercise_rounded, color: c.textSecondary),
                )
              : Image.asset(
                  image.uri,
                  fit: BoxFit.cover,
                  // Decode at display size: keeps lists smooth.
                  cacheWidth: (size * dpr).round(),
                  errorBuilder: (_, _, _) => ColoredBox(color: c.surfaceRaised),
                ),
        ),
      ),
    );
  }
}
