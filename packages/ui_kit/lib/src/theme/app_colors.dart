import 'package:flutter/material.dart';

/// BedeBestan brand palette.
///
/// Deep navy/teal surfaces with warm cream paper — never default Material
/// purple. Four semantic accents carry meaning across the whole product:
///
/// * [pay] (coral)      — بدهی: money I must pay.
/// * [receive] (emerald)— طلب: money owed to me.
/// * [reminder] (gold)  — یادآوری / تقویم.
/// * [note] (cream)     — یادداشت.
///
/// Prefer `Theme.of(context).colorScheme` in feature code; use the semantic
/// tokens below for domain-specific accents.
abstract final class AppColors {
  // --- Brand surfaces (deep navy/teal) ---
  static const Color brandDeep = Color(0xFF0B2E2F);
  static const Color brand = Color(0xFF0F3D3E);
  static const Color brandTeal = Color(0xFF1A5C5E);

  // --- Semantic accents ---
  /// بدهی — I must pay.
  static const Color pay = Color(0xFFE07A5F);

  /// طلب — owed to me.
  static const Color receive = Color(0xFF2A9D8F);

  /// یادآوری / تقویم.
  static const Color reminder = Color(0xFFD4A017);

  /// یادداشت (paper).
  static const Color note = Color(0xFFF4EDE4);

  // --- Light theme ---
  static const Color lightBackground = Color(0xFFFBF7F1);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFF4EDE4);
  static const Color lightOnSurface = Color(0xFF14302E);
  static const Color lightOnSurfaceVariant = Color(0xFF3E534F);
  static const Color lightOutline = Color(0xFFC9B9A4);
  static const Color lightError = Color(0xFFB42318);

  // --- Dark theme ---
  static const Color darkBackground = Color(0xFF08201F);
  static const Color darkSurface = Color(0xFF0F3D3E);
  static const Color darkSurfaceAlt = Color(0xFF14484A);
  static const Color darkOnSurface = Color(0xFFE6F0EC);
  static const Color darkOnSurfaceVariant = Color(0xFFC5D8D3);
  static const Color darkOutline = Color(0xFF3D6A6B);
  static const Color darkError = Color(0xFFF2896F);

  static ColorScheme lightScheme() {
    return const ColorScheme.light(
      primary: brand,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFCDE7E2),
      onPrimaryContainer: brandDeep,
      secondary: receive,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFCCEAE4),
      onSecondaryContainer: Color(0xFF07352F),
      tertiary: reminder,
      onTertiary: Color(0xFF3A2C00),
      surface: lightSurface,
      onSurface: lightOnSurface,
      onSurfaceVariant: lightOnSurfaceVariant,
      surfaceContainerHighest: lightSurfaceAlt,
      error: lightError,
      onError: Colors.white,
      errorContainer: Color(0xFFFCEEEE),
      onErrorContainer: lightError,
      outline: lightOutline,
    );
  }

  static ColorScheme darkScheme() {
    return const ColorScheme.dark(
      primary: receive,
      onPrimary: Color(0xFF04231F),
      primaryContainer: brandTeal,
      onPrimaryContainer: Color(0xFFD6EFEA),
      secondary: Color(0xFF7FC9BE),
      onSecondary: Color(0xFF04231F),
      tertiary: reminder,
      onTertiary: Color(0xFF3A2C00),
      surface: darkSurface,
      onSurface: darkOnSurface,
      onSurfaceVariant: darkOnSurfaceVariant,
      surfaceContainerHighest: darkSurfaceAlt,
      error: darkError,
      onError: Color(0xFF3B0A0A),
      errorContainer: Color(0xFF3B1512),
      onErrorContainer: darkError,
      outline: darkOutline,
    );
  }

  /// Darken a light accent so labels stay readable on cream tints.
  static Color onTint(Color color) {
    if (color.computeLuminance() <= 0.45) return color;
    return Color.lerp(color, lightOnSurface, 0.42)!;
  }
}
