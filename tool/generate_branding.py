#!/usr/bin/env python3
"""Generate BedeBestan launcher / splash artwork (teal + cream + gold)."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / "apps/bedeh_bestan"
BRAND = APP / "assets/branding"

TEAL = (15, 61, 62, 255)
CREAM = (244, 237, 228, 255)
GOLD = (212, 160, 23, 255)
CORAL = (224, 122, 95, 255)
EMERALD = (42, 157, 143, 255)

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


def rounded_rect(
    draw: ImageDraw.ImageDraw,
    box: tuple[int, int, int, int],
    radius: int,
    fill: tuple[int, int, int, int],
) -> None:
    draw.rounded_rectangle(box, radius=radius, fill=fill)


def mark(draw: ImageDraw.ImageDraw, cx: int, cy: int, scale: float) -> None:
    r = int(260 * scale)
    width = max(8, int(36 * scale))
    draw.ellipse(
        [cx - r, cy - r, cx + r, cy + r],
        outline=GOLD,
        width=width,
    )
    arm = int(150 * scale)
    thick = max(10, int(42 * scale))
    draw.line(
        [(cx + arm, cy - arm // 3), (cx - arm // 4, cy + arm)],
        fill=CORAL,
        width=thick,
    )
    draw.line(
        [(cx - arm, cy + arm // 3), (cx + arm // 4, cy - arm)],
        fill=EMERALD,
        width=thick,
    )
    hub = int(48 * scale)
    draw.ellipse([cx - hub, cy - hub, cx + hub, cy + hub], fill=GOLD)


def app_icon(size: int = 1024) -> Image.Image:
    img = Image.new("RGBA", (size, size), TEAL)
    draw = ImageDraw.Draw(img)
    m = int(size * 0.14)
    rounded_rect(draw, (m, m, size - m, size - m), int(size * 0.18), CREAM)
    mark(draw, size // 2, size // 2, size / 1024)
    return img


def adaptive_foreground(size: int = 1024) -> Image.Image:
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    m = int(size * 0.22)
    rounded_rect(draw, (m, m, size - m, size - m), int(size * 0.16), CREAM)
    mark(draw, size // 2, size // 2, (size / 1024) * 0.78)
    return img


def splash_mark(size: int = 512) -> Image.Image:
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    m = int(size * 0.08)
    rounded_rect(draw, (m, m, size - m, size - m), int(size * 0.18), CREAM)
    mark(draw, size // 2, size // 2, (size / 1024) * 1.15)
    return img


def maskable(size: int) -> Image.Image:
    img = Image.new("RGBA", (size, size), TEAL)
    draw = ImageDraw.Draw(img)
    m = int(size * 0.22)
    rounded_rect(draw, (m, m, size - m, size - m), int(size * 0.16), CREAM)
    mark(draw, size // 2, size // 2, (size / 1024) * 0.72)
    return img


def save_resized(src: Image.Image, path: Path, size: int) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    src.resize((size, size), Image.Resampling.LANCZOS).save(path)


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
    <color name="ic_launcher_background">#0F3D3E</color>
    <color name="splash_background">#0F3D3E</color>
    <color name="splash_background_dark">#08201F</color>
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
    icon.save(BRAND / "app_icon.png")
    fg.save(BRAND / "app_icon_fg.png")
    splash.save(BRAND / "splash_icon.png")
    write_android(icon, fg, splash)
    write_ios(icon, splash)
    write_web(icon)
    print("wrote branding, android mipmaps, iOS icons, web icons")


if __name__ == "__main__":
    main()
