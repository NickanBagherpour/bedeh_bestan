#!/usr/bin/env python3
"""Generate BedeBestan launcher / splash / favicon artwork.

Mark = money + reminder + notes on full-bleed indigo (AppColors).
Intentionally avoids saffron/white/green stripe layouts.
"""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / "apps/bedeh_bestan"
BRAND = APP / "assets/branding"

# AppColors — keep in sync with packages/ui_kit/.../app_colors.dart
BRAND_DEEP = (42, 40, 112, 255)  # #2A2870
BRAND_MID = (91, 86, 199, 255)  # #5B56C7
BRAND_MAIN = (63, 58, 168, 255)  # #3F3AA8
CREAM = (255, 252, 247, 255)  # #FFFCF7
NOTE = (255, 241, 214, 255)  # #FFF1D6
GOLD = (224, 160, 26, 255)  # #E0A01A
GOLD_DEEP = (180, 120, 10, 255)
TRANSPARENT = (0, 0, 0, 0)

ANDROID_DENSITIES = {
    "mdpi": 1,
    "hdpi": 1.5,
    "xhdpi": 2,
    "xxhdpi": 3,
    "xxxhdpi": 4,
}

IOS_ICONS = [
    ("Icon-App-20x20@1x.png", 20),
    ("Icon-App-20x20@2x.png", 40),
    ("Icon-App-20x20@3x.png", 60),
    ("Icon-App-29x29@1x.png", 29),
    ("Icon-App-29x29@2x.png", 58),
    ("Icon-App-29x29@3x.png", 87),
    ("Icon-App-40x40@1x.png", 40),
    ("Icon-App-40x40@2x.png", 80),
    ("Icon-App-40x40@3x.png", 120),
    ("Icon-App-60x60@2x.png", 120),
    ("Icon-App-60x60@3x.png", 180),
    ("Icon-App-76x76@1x.png", 76),
    ("Icon-App-76x76@2x.png", 152),
    ("Icon-App-83.5x83.5@2x.png", 167),
    ("Icon-App-1024x1024@1x.png", 1024),
]


def _s(value: float, scale: float) -> int:
    return max(1, int(round(value * scale)))


def _draw_note(
    draw: ImageDraw.ImageDraw,
    cx: int,
    cy: int,
    scale: float,
) -> tuple[int, int, int, int]:
    """Cream note card with folded corner + ruled lines. Returns card box."""
    w = _s(420, scale)
    h = _s(500, scale)
    left = cx - w // 2 - _s(40, scale)
    top = cy - h // 2 + _s(10, scale)
    right = left + w
    bottom = top + h
    radius = _s(48, scale)
    fold = _s(90, scale)

    # Soft indigo shadow under the card.
    draw.rounded_rectangle(
        [left + _s(14, scale), top + _s(18, scale), right + _s(14, scale), bottom + _s(18, scale)],
        radius=radius,
        fill=BRAND_MID,
    )
    draw.rounded_rectangle(
        [left, top, right, bottom],
        radius=radius,
        fill=CREAM,
    )

    # Folded top-right corner (note paper).
    draw.polygon(
        [
            (right - fold, top),
            (right, top + fold),
            (right - fold, top + fold),
        ],
        fill=NOTE,
    )
    draw.line(
        [(right - fold, top), (right - fold, top + fold), (right, top + fold)],
        fill=BRAND_MID,
        width=max(2, _s(6, scale)),
    )

    # Ruled note lines.
    line_left = left + _s(56, scale)
    line_right = right - _s(56, scale)
    for i, y_off in enumerate((170, 240, 310)):
        y = top + _s(y_off, scale)
        # Shorter last line.
        end = line_right - (_s(70, scale) if i == 2 else 0)
        draw.rounded_rectangle(
            [line_left, y, end, y + _s(22, scale)],
            radius=_s(11, scale),
            fill=BRAND_MID if i < 2 else (160, 155, 210, 255),
        )

    return left, top, right, bottom


def _draw_coin(
    draw: ImageDraw.ImageDraw,
    cx: int,
    cy: int,
    scale: float,
) -> None:
    """Gold coin for money / قسط / بده‌بستان."""
    r = _s(148, scale)
    draw.ellipse([cx - r, cy - r, cx + r, cy + r], fill=GOLD_DEEP)
    r2 = _s(132, scale)
    draw.ellipse([cx - r2, cy - r2, cx + r2, cy + r2], fill=GOLD)
    # Inner ring.
    r3 = _s(100, scale)
    draw.ellipse(
        [cx - r3, cy - r3, cx + r3, cy + r3],
        outline=GOLD_DEEP,
        width=max(3, _s(10, scale)),
    )
    # Simple currency hub (filled circle + bar = coin face).
    hub = _s(36, scale)
    draw.ellipse([cx - hub, cy - hub, cx + hub, cy + hub], fill=GOLD_DEEP)
    bar_w = _s(18, scale)
    bar_h = _s(70, scale)
    draw.rounded_rectangle(
        [cx - bar_w // 2, cy - bar_h // 2, cx + bar_w // 2, cy + bar_h // 2],
        radius=_s(9, scale),
        fill=CREAM,
    )


def _draw_bell(
    draw: ImageDraw.ImageDraw,
    cx: int,
    cy: int,
    scale: float,
) -> None:
    """Reminder bell badge."""
    # Badge disc.
    r = _s(110, scale)
    draw.ellipse([cx - r, cy - r, cx + r, cy + r], fill=BRAND_MAIN)
    r_in = _s(96, scale)
    draw.ellipse([cx - r_in, cy - r_in, cx + r_in, cy + r_in], fill=CREAM)

    # Bell body (dome + mouth).
    body_w = _s(78, scale)
    body_h = _s(70, scale)
    top = cy - _s(38, scale)
    draw.pieslice(
        [cx - body_w // 2, top, cx + body_w // 2, top + body_h],
        start=180,
        end=360,
        fill=GOLD,
    )
    draw.rectangle(
        [cx - body_w // 2, top + body_h // 2 - _s(4, scale), cx + body_w // 2, top + body_h - _s(8, scale)],
        fill=GOLD,
    )
    # Bell lip.
    lip_y = top + body_h - _s(10, scale)
    draw.rounded_rectangle(
        [cx - body_w // 2 - _s(8, scale), lip_y, cx + body_w // 2 + _s(8, scale), lip_y + _s(18, scale)],
        radius=_s(8, scale),
        fill=GOLD_DEEP,
    )
    # Clapper.
    cl = _s(14, scale)
    draw.ellipse(
        [cx - cl, lip_y + _s(10, scale), cx + cl, lip_y + _s(10, scale) + cl * 2],
        fill=GOLD_DEEP,
    )
    # Cap.
    cap = _s(12, scale)
    draw.ellipse(
        [cx - cap, top - _s(10, scale), cx + cap, top + _s(14, scale)],
        fill=GOLD_DEEP,
    )


def draw_mark(
    canvas: Image.Image,
    cx: int,
    cy: int,
    scale: float,
) -> None:
    """Notes card + money coin + reminder bell."""
    draw = ImageDraw.Draw(canvas)
    left, top, right, bottom = _draw_note(draw, cx, cy, scale)

    # Coin overlaps lower-left of the note (money).
    coin_x = left + _s(70, scale)
    coin_y = bottom - _s(40, scale)
    _draw_coin(draw, coin_x, coin_y, scale)

    # Bell badge on upper-right (reminder).
    bell_x = right - _s(20, scale)
    bell_y = top + _s(40, scale)
    _draw_bell(draw, bell_x, bell_y, scale)


def app_icon(size: int = 1024) -> Image.Image:
    """Full-bleed legacy / iOS / web icon."""
    img = Image.new("RGBA", (size, size), BRAND_DEEP)
    draw_mark(img, size // 2, size // 2, (size / 1024) * 1.05)
    return img


def adaptive_foreground(size: int = 1024) -> Image.Image:
    """Android adaptive foreground — mark in the safe zone."""
    img = Image.new("RGBA", (size, size), TRANSPARENT)
    draw_mark(img, size // 2, size // 2, (size / 1024) * 0.9)
    return img


def splash_mark(size: int = 512) -> Image.Image:
    """Splash / launch image glyph on transparent."""
    img = Image.new("RGBA", (size, size), TRANSPARENT)
    draw_mark(img, size // 2, size // 2, (size / 1024) * 1.15)
    return img


def maskable(size: int) -> Image.Image:
    """PWA maskable — full indigo + mark with safe padding."""
    img = Image.new("RGBA", (size, size), BRAND_DEEP)
    draw_mark(img, size // 2, size // 2, (size / 1024) * 0.85)
    return img


def save_resized(src: Image.Image, path: Path, size: int) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    src.resize((size, size), Image.Resampling.LANCZOS).save(path, optimize=True)


def write_android(icon: Image.Image, fg: Image.Image, splash: Image.Image) -> None:
    res = APP / "android/app/src/main/res"
    for name, scale in ANDROID_DENSITIES.items():
        save_resized(icon, res / f"mipmap-{name}/ic_launcher.png", int(48 * scale))
        save_resized(
            fg,
            res / f"mipmap-{name}/ic_launcher_foreground.png",
            int(108 * scale),
        )
        save_resized(splash, res / f"drawable-{name}/splash_icon.png", int(160 * scale))

    anydpi = res / "mipmap-anydpi-v26"
    anydpi.mkdir(parents=True, exist_ok=True)
    (anydpi / "ic_launcher.xml").write_text(
        """<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
""",
        encoding="utf-8",
    )
    colors = res / "values/colors.xml"
    colors.write_text(
        """<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#2A2870</color>
    <color name="splash_background">#2A2870</color>
    <color name="splash_background_dark">#12111F</color>
</resources>
""",
        encoding="utf-8",
    )


def write_ios(icon: Image.Image, splash: Image.Image) -> None:
    icons = APP / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    for name, size in IOS_ICONS:
        save_resized(icon, icons / name, size)
    launch = APP / "ios/Runner/Assets.xcassets/LaunchImage.imageset"
    save_resized(splash, launch / "LaunchImage.png", 200)
    save_resized(splash, launch / "LaunchImage@2x.png", 400)
    save_resized(splash, launch / "LaunchImage@3x.png", 600)


def write_web(icon: Image.Image) -> None:
    web = APP / "web"
    save_resized(icon, web / "favicon.png", 48)
    save_resized(icon, web / "icons/Icon-192.png", 192)
    save_resized(icon, web / "icons/Icon-512.png", 512)
    save_resized(maskable(192), web / "icons/Icon-maskable-192.png", 192)
    save_resized(maskable(512), web / "icons/Icon-maskable-512.png", 512)


def main() -> None:
    BRAND.mkdir(parents=True, exist_ok=True)
    icon = app_icon()
    fg = adaptive_foreground()
    splash = splash_mark()
    icon.save(BRAND / "app_icon.png", optimize=True)
    fg.save(BRAND / "app_icon_fg.png", optimize=True)
    splash.save(BRAND / "splash_icon.png", optimize=True)
    write_android(icon, fg, splash)
    write_ios(icon, splash)
    write_web(icon)
    print("wrote branding, android mipmaps, iOS icons, web icons")


if __name__ == "__main__":
    main()
