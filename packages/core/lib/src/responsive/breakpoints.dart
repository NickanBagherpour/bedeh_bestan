/// Layout breakpoints shared across the app.
abstract final class AppBreakpoints {
  static const double mobileMax = 720;
  static const double tabletMax = 1100;

  static bool isMobile(double width) => width <= mobileMax;
  static bool isTablet(double width) => width > mobileMax && width <= tabletMax;
  static bool isTabletUp(double width) => width > mobileMax;
  static bool isWide(double width) => width > tabletMax;
}
