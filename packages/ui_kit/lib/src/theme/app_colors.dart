import 'package:flutter/material.dart';

/// BedeBestan brand palette.
///
/// Bright teal surfaces with mint paper — never default Material purple.
/// Four semantic accents carry meaning across the whole product:
///
/// * [pay] (coral)      — بدهی: money I must pay.
/// * [receive] (emerald)— طلب: money owed to me.
/// * [reminder] (gold)  — یادآوری / تقویم.
/// * [note] (peach)     — یادداشت.
///
/// Prefer `Theme.of(context).colorScheme` in feature code; use the semantic
/// tokens below for domain-specific accents.
abstract final class AppColors {
  // --- Brand surfaces ---
  static const Color brandDeep = Color(0xFF084E4B);
  static const Color brand = Color(0xFF0E7A74);
  static const Color brandTeal = Color(0xFF1A9B93);

  // --- Semantic accents ---
  /// بدهی — I must pay.
  static const Color pay = Color(0xFFE15D3A);

  /// طلب — owed to me.
  static const Color receive = Color(0xFF1B9E8F);

  /// یادآوری / تقویم.
  static const Color reminder = Color(0xFFE0A01A);

  /// یادداشت (paper).
  static const Color note = Color(0xFFFFF1D6);

  // --- Light theme ---
  static const Color lightBackground = Color(0xFFD9F2EE);
  static const Color lightSurface = Color(0xFFFFFFF8);
  static const Color lightSurfaceAlt = Color(0xFFBFE8E1);
  static const Color lightAppBar = Color(0xFFB3E4DC);
  static const Color lightNav = Color(0xFFC7EDE7);
  static const Color lightOnSurface = Color(0xFF0C3331);
  static const Color lightOnSurfaceVariant = Color(0xFF2F5A56);
  static const Color lightOutline = Color(0xFF8DC4BD);
  static const Color lightError = Color(0xFFB42318);

  // --- Dark theme ---
  static const Color darkBackground = Color(0xFF052422);
  static const Color darkSurface = Color(0xFF0C3F3C);
  static const Color darkSurfaceAlt = Color(0xFF145752);
  static const Color darkOnSurface = Color(0xFFE6F7F4);
  static const Color darkOnSurfaceVariant = Color(0xFFB4DDD7);
  static const Color darkOutline = Color(0xFF3D7A75);
  static const Color darkError = Color(0xFFF2896F);

  static ColorScheme lightScheme() {
    return const ColorScheme.light(
      primary: brand,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF9FE0D6),
      onPrimaryContainer: brandDeep,
      secondary: receive,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFC3F0E8),
      onSecondaryContainer: Color(0xFF07352F),
      tertiary: reminder,
      onTertiary: Color(0xFF3A2C00),
      tertiaryContainer: Color(0xFFFFE4A3),
      onTertiaryContainer: Color(0xFF3A2C00),
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
      primary: Color(0xFF7FD3CB),
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

  /// Darken a light accent so labels stay readable on mint / peach tints.
  static Color onTint(Color color) {
    if (color.computeLuminance() <= 0.45) return color;
    return Color.lerp(color, lightOnSurface, 0.42)!;
  }
}
