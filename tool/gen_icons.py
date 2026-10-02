"""Renders legacy launcher PNGs + the Play Store icon from the same geometry
as android/app/src/main/res/drawable/ic_launcher_foreground.xml.

    python tool/gen_icons.py

Placeholder mark until the final logo exists.
"""
from pathlib import Path

from PIL import Image, ImageDraw

BG = (0x0E, 0x0F, 0x11, 255)
ACCENT = (0xC6, 0xF4, 0x32, 255)

# (x0, y0, x1, y1, radius) in the 108-unit adaptive icon viewport.
SHAPES = [
    (40, 51.5, 68, 56.5, 0),
    (34, 36, 44, 72, 2),
    (64, 36, 74, 72, 2),
    (26, 44, 34, 64, 2),
    (74, 44, 82, 64, 2),
]

DENSITIES = {'mdpi': 48, 'hdpi': 72, 'xhdpi': 96, 'xxhdpi': 144, 'xxxhdpi': 192}


def render(size: int, round_corners: bool) -> Image.Image:
    scale_up = 4  # supersample for smooth edges
    s = size * scale_up
    img = Image.new('RGBA', (s, s), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    if round_corners:
        d.rounded_rectangle((0, 0, s - 1, s - 1), radius=s * 0.22, fill=BG)
    else:
        d.rectangle((0, 0, s, s), fill=BG)
    # Legacy icons show the full 108 viewport cropped to the central 72.
    k = s / 72
    for x0, y0, x1, y1, r in SHAPES:
        box = ((x0 - 18) * k, (y0 - 18) * k, (x1 - 18) * k, (y1 - 18) * k)
        d.rounded_rectangle(box, radius=r * k, fill=ACCENT)
    return img.resize((size, size), Image.LANCZOS)


def main() -> None:
    root = Path(__file__).resolve().parent.parent
    res = root / 'android/app/src/main/res'
    for density, px in DENSITIES.items():
        render(px, round_corners=True).save(res / f'mipmap-{density}/ic_launcher.png')
    store = root / 'store'
    store.mkdir(exist_ok=True)
    # Play Store wants a full-bleed square; it applies its own mask.
    render(512, round_corners=False).save(store / 'play_icon_512.png')
    print('icons written')


if __name__ == '__main__':
    main()
