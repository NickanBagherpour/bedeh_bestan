import 'package:core/core.dart' show AppBreakpoints;

/// Spacing scale — use these instead of magic numbers.
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const double radiusSm = 8;
  static const double radiusMd = 14;
  static const double radiusLg = 22;
  static const double radiusXl = 28;

  /// Page side gutter: 16 on mobile, 24 on tablet/desktop.
  static double pageGutter(double width) =>
      AppBreakpoints.isMobile(width) ? md : lg;

  static const double maxContentWidth = 720;
}
