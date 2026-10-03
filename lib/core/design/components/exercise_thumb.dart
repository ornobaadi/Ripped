import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ripped/core/design/theme.dart';
import 'package:ripped/core/design/tokens.dart';
import 'package:ripped/domain/catalog/exercise.dart';

/// Square exercise still from the bundled catalog (the first frame of the
/// demo video for the current theme), with a neutral placeholder so layouts
/// never jump if media is missing.
class ExerciseThumb extends StatelessWidget {
  const new({required this.exercise, this.size = 56, super.key});

  final Exercise exercise;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final uri = exercise.thumbFor(Theme.of(context).brightness.name);
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: SizedBox.square(
          dimension: size,
          child: ColoredBox(
            color: c.surfaceRaised,
            child: uri == null
                ? Icon(Symbols.exercise_rounded, color: c.textSecondary)
                : Image.asset(
                    uri,
                    fit: BoxFit.cover,
                    // Decode at display size: keeps lists smooth.
                    cacheWidth: (size * dpr).round(),
                    gaplessPlayback: true,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
          ),
        ),
      ),
    );
  }
}
