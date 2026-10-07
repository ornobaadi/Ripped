"""Builds every logo, icon and store graphic from one definition.

    python tool/gen_brand.py

The mark is the Weight Stack R: an R built from the plates of a machine
weight stack, with one plate in the accent colour ("your level"). It comes
in three colourways. Volt is the primary one: launcher, splash, store and
web all use it. Ember and Chalk can be picked inside the app.

Everything below is derived from PLATES and PALETTES, so no size or format
can drift from the others:

- assets/brand/                the full kit (SVG + PNG) in every colourway
- lib/core/design/brand.dart   the same plates and colours for the app
- android res                  launcher icons, splash, notification icon
- store/                       Play Store icon and feature graphic
- web/                         favicon and PWA icons

Needs Pillow and fontTools. Nothing from the kit is bundled into the app:
`BrandMark` draws the plates from brand.dart.
"""
import shutil
from pathlib import Path

from fontTools.pens.basePen import decomposeQuadraticSegment
from fontTools.pens.recordingPen import RecordingPen
from fontTools.ttLib import TTFont
from PIL import Image, ImageChops, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
FONT = ROOT / 'assets/fonts/BarlowCondensed-Bold.ttf'
TEXT_FONT = ROOT / 'assets/fonts/Inter.ttf'

# The mark, on a 160 x 192 grid: (left, top, width, is the accent plate).
MARK_W, MARK_H = 160, 192
PLATE_H, PLATE_R = 32, 4
PLATES = [
    (0, 0, 144, False),
    (0, 40, 56, False), (104, 40, 56, False),
    (0, 80, 144, True),
    (0, 120, 56, False), (72, 120, 56, False),
    (0, 160, 56, False), (104, 160, 56, False),
]

# Colourways: tile, plates, accent plate.
PALETTES = {
    'volt': ((0x0E, 0x0F, 0x11), (0xF5, 0xF5, 0xF4), (0xC6, 0xF4, 0x32)),
    'ember': ((0x15, 0x11, 0x0F), (0xF4, 0xEF, 0xE9), (0xFF, 0x5A, 0x26)),
    'chalk': ((0xF1, 0xEE, 0xE7), (0x15, 0x11, 0x0F), (0xFF, 0x5A, 0x26)),
}
PRIMARY = 'volt'
BG, PLATE, ACCENT = PALETTES[PRIMARY]

WHITE = (0xFF, 0xFF, 0xFF)
INK = (0x11, 0x12, 0x14)
GREY = (0xA1, 0xA1, 0xAA)

# How tall the mark is on a tile, as a share of the tile.
TILE_SHARE = 0.47

# Wordmark: the brand font, widened and leaning forward.
WIDEN = 1.14
LEAN = 0.14

_font = TTFont(str(FONT))
_glyphs = _font.getGlyphSet()
_cmap = _font.getBestCmap()
_advance = _font['hmtx']


def contours_of(text: str, tracking: float = 0.0):
    """Outlines of `text` in font units (y up), as lists of segments."""
    out, x = [], 0.0
    for ch in text:
        name = _cmap[ord(ch)]
        pen = RecordingPen()
        _glyphs[name].draw(pen)
        cur = None
        for op, args in pen.value:
            if op == 'moveTo':
                cur = [('M', (args[0][0] + x, args[0][1]))]
                out.append(cur)
            elif op == 'lineTo':
                cur.append(('L', (args[0][0] + x, args[0][1])))
            elif op == 'qCurveTo':
                for c, p in decomposeQuadraticSegment(args):
                    cur.append(('Q', (c[0] + x, c[1]), (p[0] + x, p[1])))
            elif op == 'curveTo':
                raise ValueError('cubic outlines are not expected in this font')
        x += _advance[name][0] * (1 + tracking)
    return out


def mapped(contours, fn):
    return [[(seg[0], *[fn(p) for p in seg[1:]]) for seg in c] for c in contours]


def bounds(contours):
    pts = [p for c in contours for seg in c for p in seg[1:]]
    xs, ys = [p[0] for p in pts], [p[1] for p in pts]
    return min(xs), min(ys), max(xs), max(ys)


def num(v, digits=2):
    return f'{v:.{digits}f}'.rstrip('0').rstrip('.')


def path_d(contours, digits=2):
    parts = []
    for c in contours:
        for seg in c:
            nums = ' '.join(num(v, digits) for p in seg[1:] for v in p)
            parts.append(f'{seg[0]}{nums}')
        parts.append('Z')
    return ''.join(parts)


def flatten(contour, steps=14):
    pts, last = [], None
    for seg in contour:
        if seg[0] in 'ML':
            last = seg[1]
            pts.append(last)
        else:
            c, p = seg[1], seg[2]
            for i in range(1, steps + 1):
                t = i / steps
                pts.append(((1 - t) ** 2 * last[0] + 2 * (1 - t) * t * c[0] + t * t * p[0],
                            (1 - t) ** 2 * last[1] + 2 * (1 - t) * t * c[1] + t * t * p[1]))
            last = p
    return pts


def tinted(mask, colour):
    img = Image.new('RGBA', mask.size, colour + (0,))
    img.putalpha(mask)
    return img


def save_png(img, path):
    path.parent.mkdir(parents=True, exist_ok=True)
    img.save(path, optimize=True)


def write(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding='utf-8', newline='\n')


def hexc(c):
    return '#%02X%02X%02X' % c


# ---------------------------------------------------------------- shapes

def placed(height, cx, cy):
    """The plates of a mark `height` tall centred on (cx, cy), as
    (x, y, w, h, radius, is accent)."""
    s = height / MARK_H
    ox, oy = cx - MARK_W * s / 2, cy - height / 2
    return [(ox + x * s, oy + y * s, w * s, PLATE_H * s, PLATE_R * s, a)
            for x, y, w, a in PLATES]


def wordmark(cap_height, left, middle):
    """RIPPED, `cap_height` tall, starting at `left`, centred on the line
    y = `middle` (y down)."""
    word = mapped(contours_of('RIPPED', tracking=0.10),
                  lambda p: (p[0] * WIDEN + p[1] * LEAN, p[1]))
    x0, y0, x1, y1 = bounds(word)
    s = cap_height / (y1 - y0)
    return mapped(word, lambda p: (left + (p[0] - x0) * s,
                                   middle + ((y0 + y1) / 2 - p[1]) * s))


def plates_layer(size, plates, plate, accent, ss=4):
    """The plates, anti-aliased, on a transparent image."""
    w, h = (size, size) if isinstance(size, int) else size
    out = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    for colour, want in ((plate, False), (accent, True)):
        mask = Image.new('L', (w * ss, h * ss), 0)
        d = ImageDraw.Draw(mask)
        for x, y, pw, ph, r, a in plates:
            if a == want:
                d.rounded_rectangle(
                    (x * ss, y * ss, (x + pw) * ss - 1, (y + ph) * ss - 1),
                    radius=r * ss, fill=255)
        out.alpha_composite(tinted(mask.resize((w, h), Image.LANCZOS), colour))
    return out


def outline_layer(size, contours, colour, ss=4):
    """Font outlines (in pixels, y down) on a transparent image."""
    w, h = size
    mask = Image.new('L', (w * ss, h * ss), 0)
    for c in contours:
        layer = Image.new('L', mask.size, 0)
        ImageDraw.Draw(layer).polygon([(x * ss, y * ss) for x, y in flatten(c)], fill=255)
        mask = ImageChops.difference(mask, layer)  # counters punch holes
    return tinted(mask.resize((w, h), Image.LANCZOS), colour)


def mark_png(size, plate, accent, share=0.92):
    return plates_layer(size, placed(size * share, size / 2, size / 2), plate, accent)


def icon_png(size, palette=PRIMARY, radius=0.0, share=TILE_SHARE):
    """Mark on a solid tile; `radius` as a share of the size."""
    bg, plate, accent = PALETTES[palette]
    ss = 4
    tile = Image.new('RGBA', (size * ss, size * ss), (0, 0, 0, 0))
    d = ImageDraw.Draw(tile)
    if radius:
        d.rounded_rectangle((0, 0, size * ss - 1, size * ss - 1),
                            radius=size * ss * radius, fill=bg + (255,))
    else:
        d.rectangle((0, 0, size * ss, size * ss), fill=bg + (255,))
    tile = tile.resize((size, size), Image.LANCZOS)
    tile.alpha_composite(mark_png(size, plate, accent, share))
    return tile


def glow(size, bg, colour, strength=0.22):
    """The soft corner glow, as on the share card."""
    w, h = size
    layer = Image.new('RGBA', size, bg + (255,))
    spot = Image.new('L', size, 0)
    r = int(w * 0.55)
    ImageDraw.Draw(spot).ellipse((w - r, -r, w + r, r), fill=int(255 * strength))
    spot = spot.filter(ImageFilter.GaussianBlur(w * 0.16))
    layer.paste(Image.new('RGBA', size, colour + (255,)), (0, 0), spot)
    return layer


def lockup_shapes(height=1000):
    """Mark + wordmark side by side in a box `height` tall. Returns the
    plates, the wordmark outlines and the total width."""
    mark_h = height * 0.62
    mark_w = MARK_W * mark_h / MARK_H
    pad = height * 0.19
    plates = placed(mark_h, pad + mark_w / 2, height / 2)
    word = wordmark(mark_h * 0.72, pad + mark_w + height * 0.17, height / 2)
    return plates, word, bounds(word)[2] + pad


def lockup_png(height, plate, accent, word_colour, bg=None):
    plates, word, width = lockup_shapes(1000)
    k = height / 1000
    size = (round(width * k), height)
    img = Image.new('RGBA', size, (bg + (255,)) if bg else (0, 0, 0, 0))
    img.alpha_composite(plates_layer(
        size, [(x * k, y * k, w * k, h * k, r * k, a) for x, y, w, h, r, a in plates],
        plate, accent))
    img.alpha_composite(outline_layer(
        size, mapped(word, lambda p: (p[0] * k, p[1] * k)), word_colour))
    return img


# ------------------------------------------------------------------- svg

def svg_rects(plates, plate, accent):
    return ''.join(
        f'<rect x="{num(x)}" y="{num(y)}" width="{num(w)}" height="{num(h)}" '
        f'rx="{num(r)}" fill="{hexc(accent if a else plate)}"/>'
        for x, y, w, h, r, a in plates)


def svg_mark(plate, accent, tile=None, radius=0.0, share=0.92):
    bg = ''
    if tile:
        bg = (f'<rect width="1000" height="1000" rx="{1000 * radius:.0f}" '
              f'fill="{hexc(tile)}"/>')
    return ('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000">'
            f'{bg}{svg_rects(placed(1000 * share, 500, 500), plate, accent)}</svg>\n')


def svg_lockup(plate, accent, word_colour, bg=None):
    plates, word, width = lockup_shapes(1000)
    rect = f'<rect width="{width:.0f}" height="1000" fill="{hexc(bg)}"/>' if bg else ''
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {width:.0f} 1000">'
            f'{rect}{svg_rects(plates, plate, accent)}'
            f'<path fill="{hexc(word_colour)}" d="{path_d(word)}"/></svg>\n')


# --------------------------------------------------------------- android

def rrect_d(x, y, w, h, r):
    def n(v):
        return num(v, 3)
    a = f'a{n(r)},{n(r)} 0 0 1'
    return (f'M{n(x + r)},{n(y)}h{n(w - 2 * r)}{a} {n(r)},{n(r)}'
            f'v{n(h - 2 * r)}{a} {n(-r)},{n(r)}h{n(2 * r - w)}{a} {n(-r)},{n(-r)}'
            f'v{n(2 * r - h)}{a} {n(r)},{n(-r)}z')


def vector_drawable(viewport, dp, paths, note):
    """`viewport` and `dp` are (width, height); `paths` is (colour, data)."""
    body = '\n'.join(
        f'    <path\n        android:fillColor="{colour}"\n'
        f'        android:pathData="{d}" />' for colour, d in paths)
    return f'''<?xml version="1.0" encoding="utf-8"?>
<!-- Generated by tool/gen_brand.py. {note} -->
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="{dp[0]}dp"
    android:height="{dp[1]}dp"
    android:viewportWidth="{viewport[0]}"
    android:viewportHeight="{viewport[1]}">
{body}
</vector>
'''


def mark_vector(viewport, share, plate, accent, note):
    plates = placed(viewport * share, viewport / 2, viewport / 2)
    paths = []
    for colour, want in ((plate, False), (accent, True)):
        d = ''.join(rrect_d(*p[:5]) for p in plates if p[5] == want)
        if paths and paths[-1][0] == hexc(colour):
            paths[-1] = (hexc(colour), paths[-1][1] + d)
        else:
            paths.append((hexc(colour), d))
    return vector_drawable((viewport, viewport), (viewport, viewport), paths, note)


ADAPTIVE_ICON = '''<?xml version="1.0" encoding="utf-8"?>
<!-- Generated by tool/gen_brand.py. -->
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ripped_bg" />
    <foreground android:drawable="@drawable/ic_launcher_foreground" />
    <monochrome android:drawable="@drawable/ic_launcher_monochrome" />
</adaptive-icon>
'''

# Before Android 12 the launch theme draws the splash itself: the mark in
# the middle, the wordmark near the bottom, as the system does on 12+.
LAUNCH_BACKGROUND = '''<?xml version="1.0" encoding="utf-8"?>
<!-- Generated by tool/gen_brand.py. Splash before Android 12. -->
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@color/ripped_bg" />
    <item
        android:width="288dp"
        android:height="288dp"
        android:gravity="center"
        android:drawable="@drawable/ic_launcher_foreground" />
    <item
        android:width="200dp"
        android:height="80dp"
        android:gravity="bottom|center_horizontal"
        android:bottom="60dp"
        android:drawable="@drawable/splash_branding" />
</layer-list>
'''

DENSITIES = {'mdpi': 48, 'hdpi': 72, 'xhdpi': 96, 'xxhdpi': 144, 'xxxhdpi': 192}


def write_android():
    res = ROOT / 'android/app/src/main/res'
    # Adaptive icon foreground: the mark stays inside the 66dp safe zone.
    # Also the splash icon, where the same safe zone applies.
    write(res / 'drawable/ic_launcher_foreground.xml',
          mark_vector(108, 0.42, PLATE, ACCENT,
                      note='Launcher foreground and splash icon.'))
    # Themed icons (Android 13+): the system colours the shape itself.
    write(res / 'drawable/ic_launcher_monochrome.xml',
          mark_vector(108, 0.42, WHITE, WHITE, note='Themed launcher icon.'))
    # Status-bar icon: Android draws only the shape, in its own colour.
    write(res / 'drawable/ic_notification.xml',
          mark_vector(24, 0.84, WHITE, WHITE, note='Notification small icon.'))
    # The wordmark under the splash icon (200 x 80 dp is the system's size).
    word = wordmark(20, 0, 40)
    x0, _, x1, _ = bounds(word)
    word = mapped(word, lambda p: (p[0] + (200 - (x1 - x0)) / 2, p[1]))
    write(res / 'drawable/splash_branding.xml',
          vector_drawable((200, 80), (200, 80), [(hexc(PLATE), path_d(word, 3))],
                          note='Wordmark at the bottom of the splash.'))
    for folder in ('drawable', 'drawable-v21'):
        write(res / folder / 'launch_background.xml', LAUNCH_BACKGROUND)
    for name in ('ic_launcher', 'ic_launcher_round'):
        write(res / f'mipmap-anydpi-v26/{name}.xml', ADAPTIVE_ICON)
    # Referenced by name from Dart, so the resource shrinker must keep it.
    write(res / 'raw/keep.xml',
          '<?xml version="1.0" encoding="utf-8"?>\n'
          '<resources xmlns:tools="http://schemas.android.com/tools"\n'
          '    tools:keep="@drawable/ic_notification" />\n')
    for density, px in DENSITIES.items():
        folder = res / f'mipmap-{density}'
        save_png(icon_png(px, radius=0.22), folder / 'ic_launcher.png')
        round_icon = icon_png(px, share=0.44)
        circle = Image.new('L', (px * 4, px * 4), 0)
        ImageDraw.Draw(circle).ellipse((0, 0, px * 4 - 1, px * 4 - 1), fill=255)
        round_icon.putalpha(circle.resize((px, px), Image.LANCZOS))
        save_png(round_icon, folder / 'ic_launcher_round.png')


# ----------------------------------------------------------------- store

def feature_graphic():
    w, h = 1024, 500
    img = glow((w, h), BG, ACCENT)
    mark_h = 236
    mark_w = MARK_W * mark_h / MARK_H
    left = 150
    img.alpha_composite(plates_layer(
        (w, h), placed(mark_h, left + mark_w / 2, h / 2), PLATE, ACCENT))
    text_x = left + mark_w + 64
    img.alpha_composite(outline_layer((w, h), wordmark(124, text_x, 222), PLATE))
    ImageDraw.Draw(img).text(
        (text_x + 4, 312), 'The workout plan that adapts to you',
        font=ImageFont.truetype(str(TEXT_FONT), 30), fill=GREY + (255,))
    return img.convert('RGB')


def write_store():
    store = ROOT / 'store'
    # Play wants a full-bleed 512 square (it applies its own mask), <= 1 MB.
    save_png(icon_png(512).convert('RGB'), store / 'play_icon_512.png')
    save_png(feature_graphic(), store / 'feature_graphic_1024x500.png')


# ------------------------------------------------------------------- kit

def write_kit():
    kit = ROOT / 'assets/brand'
    svg, png = kit / 'svg', kit / 'png'
    # Only generated files live here: start clean so old names don't linger.
    for folder in (svg, png, kit / 'app'):
        shutil.rmtree(folder, ignore_errors=True)

    mono = {'white': (0xF5, 0xF5, 0xF4), 'black': INK}
    for name, (bg, plate, accent) in PALETTES.items():
        write(svg / f'mark_{name}.svg', svg_mark(plate, accent))
        write(svg / f'icon_{name}.svg',
              svg_mark(plate, accent, tile=bg, radius=0.22, share=TILE_SHARE))
        write(svg / f'icon_{name}_square.svg',
              svg_mark(plate, accent, tile=bg, share=TILE_SHARE))
        write(svg / f'lockup_{name}.svg', svg_lockup(plate, accent, plate))
        write(svg / f'lockup_{name}_tile.svg', svg_lockup(plate, accent, plate, bg=bg))
        for size in (64, 128, 256, 512, 1024):
            save_png(mark_png(size, plate, accent), png / f'mark_{name}_{size}.png')
        for size in (48, 72, 96, 144, 192, 256, 512, 1024):
            save_png(icon_png(size, name, radius=0.22), png / f'icon_{name}_{size}.png')
        for size in (192, 512, 1024):
            save_png(icon_png(size, name), png / f'icon_{name}_square_{size}.png')
        for height in (120, 240, 480):
            save_png(lockup_png(height, plate, accent, plate),
                     png / f'lockup_{name}_{height}.png')
            save_png(lockup_png(height, plate, accent, plate, bg=bg),
                     png / f'lockup_{name}_tile_{height}.png')
    # One colour, for print, embossing or someone else's background.
    for name, colour in mono.items():
        write(svg / f'mark_{name}.svg', svg_mark(colour, colour))
        write(svg / f'lockup_{name}.svg', svg_lockup(colour, colour, colour))
        for size in (64, 128, 256, 512, 1024):
            save_png(mark_png(size, colour, colour), png / f'mark_{name}_{size}.png')
        for height in (120, 240, 480):
            save_png(lockup_png(height, colour, colour, colour),
                     png / f'lockup_{name}_{height}.png')


# ------------------------------------------------------------------ dart

def dart_colour(c):
    return 'Color(0xFF%02X%02X%02X)' % c


def write_dart():
    logos = '\n'.join(
        f'  {name}(\n    bg: {dart_colour(bg)},\n    plate: {dart_colour(plate)},\n'
        f'    accent: {dart_colour(accent)},\n  ){";" if name == list(PALETTES)[-1] else ","}'
        for name, (bg, plate, accent) in PALETTES.items())
    plates = '\n'.join(
        f'    (x: {x}, y: {y}, width: {w}, accent: {str(a).lower()}),'
        for x, y, w, a in PLATES)
    write(ROOT / 'lib/core/design/brand.dart', f'''// Generated by tool/gen_brand.py, which builds every logo file from the
// same numbers. Don't edit by hand: change the generator and run it again.

import 'dart:ui';

/// The logo's colourways. [{PRIMARY}] is the primary one (launcher icon, splash
/// and store); the others can be picked in You > Logo.
enum BrandLogo {{
{logos}

  new({{required this.bg, required this.plate, required this.accent}});

  /// The tile behind the mark.
  final Color bg;

  /// Every plate of the stack but one.
  final Color plate;

  /// The one coloured plate: "your level" on the stack.
  final Color accent;
}}

/// The Weight Stack R: an R built from the plates of a weight stack, on a
/// [width] x [height] grid.
abstract final class BrandGeometry {{
  static const double width = {MARK_W};
  static const double height = {MARK_H};
  static const double plateHeight = {PLATE_H};
  static const double plateRadius = {PLATE_R};

  /// How tall the mark is on its tile, as a share of the tile.
  static const double tileShare = {TILE_SHARE};

  /// Corner radius of the tile, as a share of its size.
  static const double tileRadius = 0.22;

  /// Left edge, top edge and width of each plate.
  static const plates = <({{double x, double y, double width, bool accent}})>[
{plates}
  ];
}}
''')


# ------------------------------------------------------------------- web

def write_web():
    web = ROOT / 'web'
    save_png(icon_png(32, radius=0.22, share=0.6), web / 'favicon.png')
    for size in (192, 512):
        save_png(icon_png(size, radius=0.22), web / f'icons/Icon-{size}.png')
        # Maskable: full bleed, mark inside the central safe area.
        save_png(icon_png(size, share=0.40), web / f'icons/Icon-maskable-{size}.png')


def main() -> None:
    write_kit()
    write_dart()
    write_android()
    write_store()
    write_web()
    print('brand assets written')


if __name__ == '__main__':
    main()
