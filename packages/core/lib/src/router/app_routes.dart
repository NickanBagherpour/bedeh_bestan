/// Single route definition — paths live ONLY here.
final class AppRoute {
  const AppRoute({required this.name, required this.path});

  final String name;
  final String path;
}

/// Central route registry for BedeBestan.
///
/// The four primary destinations map to the bottom navigation bar:
/// خانه | حساب | تقویم | یادداشت.
abstract final class AppRoutes {
  static const home = AppRoute(name: 'home', path: '/');
  static const money = AppRoute(name: 'money', path: '/money');
  static const calendar = AppRoute(name: 'calendar', path: '/calendar');
  static const notes = AppRoute(name: 'notes', path: '/notes');

  /// Primary destinations in bottom-nav order.
  static const List<AppRoute> primary = [home, money, calendar, notes];

  static const List<AppRoute> all = [home, money, calendar, notes];

  /// Looks up a route by exact [path]; falls back to [home].
  static AppRoute fromPath(String path) {
    final normalized = path.isEmpty ? '/' : path;
    for (final route in all) {
      if (route.path == normalized) return route;
    }
    return home;
  }

  /// Index of [path] within [primary] (for the bottom navigation bar).
  static int indexOfPath(String path) {
    final route = fromPath(path);
    final index = primary.indexOf(route);
    return index < 0 ? 0 : index;
  }
}
