import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Gradient + glow tokens for the expressive BedeBestan surface language.
///
/// The base theme stays calm (indigo ink on sand); gradients add depth to
/// hero surfaces, icon badges and ambient page backgrounds without changing
/// the semantic palette. Prefer [accent] to derive a two-stop gradient from
/// any semantic accent ([AppColors.pay], `.receive`, `.reminder`, ...).
abstract final class AppGradients {
  /// Signature brand sweep — indigo, used for the app hero header.
  static const LinearGradient brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.brandDeep, AppColors.brand, AppColors.brandMid],
    stops: [0.0, 0.55, 1.0],
  );

  /// Coral sweep — بدهی / money out.
  static const LinearGradient pay = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF07E52), Color(0xFFE15D3A)],
  );

  /// Emerald sweep — طلب / money in.
  static const LinearGradient receive = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF35BBAA), Color(0xFF128577)],
  );

  /// Gold sweep — یادآوری / تقویم.
  static const LinearGradient reminder = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF3B733), Color(0xFFDB8E0C)],
  );

  /// Warm paper sweep — یادداشت.
  static const LinearGradient note = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFE7B8), Color(0xFFF6C877)],
  );

  /// Derive a soft two-stop gradient from any accent color.
  static LinearGradient accent(Color color) {
    final hsl = HSLColor.fromColor(color);
    final light = hsl
        .withLightness((hsl.lightness + 0.12).clamp(0.0, 1.0))
        .withSaturation((hsl.saturation + 0.05).clamp(0.0, 1.0))
        .toColor();
    final deep = hsl
        .withLightness((hsl.lightness - 0.10).clamp(0.0, 1.0))
        .toColor();
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [light, deep],
    );
  }

  /// A subtle tinted fill used for chips, tiles and soft containers.
  static LinearGradient softTint(Color color, {double alpha = 0.16}) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color.withValues(alpha: alpha),
        color.withValues(alpha: alpha * 0.4),
      ],
    );
  }

  /// Colored glow shadow for a floating accent surface.
  ///
  /// Kept relatively tight (moderate blur) so it stays cheap to paint even
  /// when several accented surfaces are on screen at once.
  static List<BoxShadow> glow(Color color, {double strength = 0.28}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: strength),
        blurRadius: 16,
        spreadRadius: -2,
        offset: const Offset(0, 8),
      ),
    ];
  }
}
