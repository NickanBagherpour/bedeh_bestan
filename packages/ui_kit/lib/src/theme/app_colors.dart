import 'package:flutter/material.dart';

/// BedeBestan brand palette.
///
/// Indigo ink on warm sand paper — never default Material purple.
/// Semantic accents stay distinct from the chrome:
///
/// * [pay] (coral)      — بدهی: money I must pay.
/// * [receive] (emerald)— طلب: money owed to me.
/// * [reminder] (gold)  — یادآوری / رویداد تقویم.
/// * [birthday] (rose)  — تولد.
/// * [note] (peach)     — یادداشت.
///
/// Prefer `Theme.of(context).colorScheme` in feature code; use the semantic
/// tokens below for domain-specific accents.
abstract final class AppColors {
  // --- Brand (indigo) ---
  static const Color brandDeep = Color(0xFF2A2870);
  static const Color brand = Color(0xFF3F3AA8);
  static const Color brandMid = Color(0xFF5B56C7);

  // --- Semantic accents ---
  /// بدهی — I must pay.
  static const Color pay = Color(0xFFE15D3A);

  /// طلب — owed to me.
  static const Color receive = Color(0xFF1B9E8F);

  /// یادآوری / تقویم.
  static const Color reminder = Color(0xFFE0A01A);

  /// تولد on the calendar.
  static const Color birthday = Color(0xFFD4537E);

  /// یادداشت (paper).
  static const Color note = Color(0xFFFFF1D6);

  // --- Light theme ---
  static const Color lightBackground = Color(0xFFF6F1E8);
  static const Color lightSurface = Color(0xFFFFFCF7);
  static const Color lightSurfaceAlt = Color(0xFFE7E3F6);
  static const Color lightAppBar = Color(0xFFDCD8F4);
  static const Color lightNav = Color(0xFFE8E5F8);
  static const Color lightOnSurface = Color(0xFF1C1B33);
  static const Color lightOnSurfaceVariant = Color(0xFF4A4768);
  static const Color lightOutline = Color(0xFFC3BEDD);
  static const Color lightError = Color(0xFFB42318);

  // --- Dark theme ---
  static const Color darkBackground = Color(0xFF12111F);
  static const Color darkSurface = Color(0xFF1E1C36);
  static const Color darkSurfaceAlt = Color(0xFF2A2750);
  static const Color darkOnSurface = Color(0xFFEDEBFA);
  static const Color darkOnSurfaceVariant = Color(0xFFC4C0DC);
  static const Color darkOutline = Color(0xFF4E4A78);
  static const Color darkError = Color(0xFFF2896F);

  static ColorScheme lightScheme() {
    return const ColorScheme.light(
      primary: brand,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFD0CCF4),
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
      primary: Color(0xFFB4B0F0),
      onPrimary: Color(0xFF1C1848),
      primaryContainer: brandMid,
      onPrimaryContainer: Color(0xFFEDEBFA),
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

  /// Darken a light accent so labels stay readable on sand / lavender tints.
  static Color onTint(Color color) {
    if (color.computeLuminance() <= 0.45) return color;
    return Color.lerp(color, lightOnSurface, 0.42)!;
  }
}
