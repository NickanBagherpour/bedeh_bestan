import 'dart:ui' show lerpDouble;

import 'package:core/core.dart' show AppStyle;
import 'package:flutter/material.dart';

/// Central style tokens that let every Kit surface adapt to the chosen
/// [AppStyle] (classic vs glass) **without knowing the enum itself**.
///
/// Widgets read these tokens via [KitSurfaceStyle.of]; the theme carries the
/// active preset as a [ThemeExtension]. Adding a new skin later is a single
/// preset here + one enum value in `core` — no widget edits.
@immutable
class KitSurfaceStyle extends ThemeExtension<KitSurfaceStyle> {
  const KitSurfaceStyle({
    required this.style,
    required this.blurSigma,
    required this.surfaceAlpha,
    required this.borderAlpha,
    required this.shadowAlpha,
    required this.ambientBoost,
    required this.sheenAlpha,
  });

  /// The active skin (kept so widgets can special-case if they must).
  final AppStyle style;

  /// Backdrop blur (logical px) behind translucent surfaces. 0 → no blur.
  final double blurSigma;

  /// Opacity applied to surface fills. 1 → fully opaque (classic).
  final double surfaceAlpha;

  /// Opacity applied to the hairline surface border.
  final double borderAlpha;

  /// Opacity applied to drop shadows.
  final double shadowAlpha;

  /// Multiplier for the ambient aurora background strength.
  final double ambientBoost;

  /// Strength of the bright top-edge “light” sheen on glass surfaces.
  /// 0 → none (classic).
  final double sheenAlpha;

  bool get isGlass => style == AppStyle.glass;

  static const KitSurfaceStyle classic = KitSurfaceStyle(
    style: AppStyle.classic,
    blurSigma: 0,
    surfaceAlpha: 1,
    borderAlpha: 1,
    shadowAlpha: 1,
    ambientBoost: 1,
    sheenAlpha: 0,
  );

  static const KitSurfaceStyle glass = KitSurfaceStyle(
    style: AppStyle.glass,
    blurSigma: 26,
    surfaceAlpha: 0.44,
    borderAlpha: 1,
    shadowAlpha: 0.55,
    ambientBoost: 2.2,
    sheenAlpha: 1,
  );

  static KitSurfaceStyle forStyle(AppStyle style) => switch (style) {
        AppStyle.classic => classic,
        AppStyle.glass => glass,
      };

  /// Resolves the active surface style from the ambient theme, falling back to
  /// [classic] so widgets stay safe even without the extension registered.
  static KitSurfaceStyle of(BuildContext context) =>
      Theme.of(context).extension<KitSurfaceStyle>() ?? classic;

  @override
  KitSurfaceStyle copyWith({
    AppStyle? style,
    double? blurSigma,
    double? surfaceAlpha,
    double? borderAlpha,
    double? shadowAlpha,
    double? ambientBoost,
    double? sheenAlpha,
  }) {
    return KitSurfaceStyle(
      style: style ?? this.style,
      blurSigma: blurSigma ?? this.blurSigma,
      surfaceAlpha: surfaceAlpha ?? this.surfaceAlpha,
      borderAlpha: borderAlpha ?? this.borderAlpha,
      shadowAlpha: shadowAlpha ?? this.shadowAlpha,
      ambientBoost: ambientBoost ?? this.ambientBoost,
      sheenAlpha: sheenAlpha ?? this.sheenAlpha,
    );
  }

  @override
  KitSurfaceStyle lerp(KitSurfaceStyle? other, double t) {
    if (other == null) return this;
    return KitSurfaceStyle(
      style: t < 0.5 ? style : other.style,
      blurSigma: lerpDouble(blurSigma, other.blurSigma, t) ?? blurSigma,
      surfaceAlpha:
          lerpDouble(surfaceAlpha, other.surfaceAlpha, t) ?? surfaceAlpha,
      borderAlpha: lerpDouble(borderAlpha, other.borderAlpha, t) ?? borderAlpha,
      shadowAlpha: lerpDouble(shadowAlpha, other.shadowAlpha, t) ?? shadowAlpha,
      ambientBoost:
          lerpDouble(ambientBoost, other.ambientBoost, t) ?? ambientBoost,
      sheenAlpha: lerpDouble(sheenAlpha, other.sheenAlpha, t) ?? sheenAlpha,
    );
  }
}
