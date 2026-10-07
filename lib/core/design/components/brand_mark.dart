import 'package:flutter/material.dart';
import 'package:ripped/core/design/brand.dart';

/// The Ripped logo: the Weight Stack R on its rounded tile, in one of the
/// [BrandLogo] colourways. Drawn in code from the numbers that
/// `tool/gen_brand.py` also builds every icon file from, so it is sharp at
/// any size and bundles no image.
class BrandMark extends StatelessWidget {
  const new({
    this.size = 32,
    this.logo = BrandLogo.volt,
    this.bare = false,
    this.plate,
    this.accent,
    super.key,
  });

  /// Side of the tile, or height of the [bare] mark.
  final double size;
  final BrandLogo logo;

  /// Only the plates, with no tile: for a background that is already the
  /// brand's own, like the share card.
  final bool bare;

  /// Override the [logo]'s plate colours.
  final Color? plate;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: bare
            ? Size(size * BrandGeometry.width / BrandGeometry.height, size)
            : Size.square(size),
        painter: _MarkPainter(
          plate: plate ?? logo.plate,
          accent: accent ?? logo.accent,
          tile: bare ? null : logo.bg,
        ),
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  const new({required this.plate, required this.accent, required this.tile});

  final Color plate;
  final Color accent;
  final Color? tile;

  @override
  void paint(Canvas canvas, Size size) {
    var height = size.height;
    if (tile != null) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(size.width * BrandGeometry.tileRadius),
        ),
        Paint()..color = tile!,
      );
      height *= BrandGeometry.tileShare;
    }
    final k = height / BrandGeometry.height;
    final left = (size.width - BrandGeometry.width * k) / 2;
    final top = (size.height - height) / 2;
    for (final p in BrandGeometry.plates) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            left + p.x * k,
            top + p.y * k,
            p.width * k,
            BrandGeometry.plateHeight * k,
          ),
          const Radius.circular(BrandGeometry.plateRadius) * k,
        ),
        Paint()..color = p.accent ? accent : plate,
      );
    }
  }

  @override
  bool shouldRepaint(_MarkPainter old) =>
      old.plate != plate || old.accent != accent || old.tile != tile;
}
