import 'package:core/core.dart' show AppStyle;
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';
import 'app_spacing.dart';
import 'app_typography.dart';
import 'kit_surface_style.dart';

/// Builds light/dark [ThemeData] for BedeBestan — calm, premium, RTL-first.
///
/// The [style] selects the visual skin (classic vs glass) independently of
/// light/dark. All skin-specific tuning is derived from [KitSurfaceStyle] so
/// surfaces stay consistent across the app.
abstract final class AppTheme {
  static ThemeData lightFor(
    String languageCode, {
    AppStyle style = AppStyle.classic,
  }) =>
      _build(languageCode, AppColors.lightScheme(), Brightness.light, style);

  static ThemeData darkFor(
    String languageCode, {
    AppStyle style = AppStyle.classic,
  }) =>
      _build(languageCode, AppColors.darkScheme(), Brightness.dark, style);

  static ThemeData _build(
    String languageCode,
    ColorScheme scheme,
    Brightness brightness,
    AppStyle style,
  ) {
    final fontFamily = AppFonts.familyFor(languageCode);
    final isDark = brightness == Brightness.dark;
    final surfaceStyle = KitSurfaceStyle.forStyle(style);
    final glass = surfaceStyle.isGlass;
    // Softly translucent chrome for the glass skin so the ambient aurora
    // reads through. Kept subtle where blur is unavailable (theme-level fills).
    Color glassy(Color base, double alpha) =>
        glass ? base.withValues(alpha: alpha) : base;
    final textTheme = AppTypography.textTheme(fontFamily).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
      fontFamily: fontFamily,
    );
    final background =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final outline = isDark ? AppColors.darkOutline : AppColors.lightOutline;
    final surfaceAlt =
        isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt;
    final appBarColor = isDark ? background : AppColors.lightAppBar;
    final navColor = isDark ? scheme.surface : AppColors.lightNav;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: fontFamily,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      scaffoldBackgroundColor: background,
      splashFactory: InkSparkle.splashFactory,
      hoverColor: scheme.primary.withValues(alpha: isDark ? 0.08 : 0.04),
      highlightColor: scheme.primary.withValues(alpha: isDark ? 0.10 : 0.06),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      extensions: [surfaceStyle],
      cardTheme: CardThemeData(
        color: glassy(scheme.surface, surfaceStyle.surfaceAlpha),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(color: outline),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: glassy(appBarColor, 0.6),
        surfaceTintColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: scheme.primary,
          fontFamily: fontFamily,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: glassy(navColor, 0.82),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 68,
        indicatorColor: scheme.primary.withValues(alpha: isDark ? 0.36 : 0.22),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelMedium?.copyWith(
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: glassy(
          isDark ? surfaceAlt : AppColors.lightSurface,
          0.7,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: glassy(surfaceAlt, 0.55),
        selectedColor: scheme.secondary.withValues(alpha: isDark ? 0.28 : 0.22),
        side: BorderSide(color: outline),
        labelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? surfaceAlt : AppColors.brand,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? AppColors.darkOnSurface : Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: scheme.onPrimary,
          backgroundColor: scheme.primary,
          textStyle: textTheme.labelLarge?.copyWith(fontFamily: fontFamily),
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: textTheme.labelLarge?.copyWith(fontFamily: fontFamily),
          minimumSize: const Size(48, 48),
          side: BorderSide(color: outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      ),
      dividerColor: outline,
    );
  }
}
