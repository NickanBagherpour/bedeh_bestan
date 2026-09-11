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
  static const moneyNew = AppRoute(name: 'moneyNew', path: '/money/new');
  static const moneyItem = AppRoute(name: 'moneyItem', path: '/money/item/:id');
  static const moneyEdit = AppRoute(
    name: 'moneyEdit',
    path: '/money/item/:id/edit',
  );
  static const calendar = AppRoute(name: 'calendar', path: '/calendar');
  static const notes = AppRoute(name: 'notes', path: '/notes');

  /// Primary destinations in bottom-nav order.
  static const List<AppRoute> primary = [home, money, calendar, notes];

  static const List<AppRoute> all = [
    home,
    money,
    moneyNew,
    moneyItem,
    moneyEdit,
    calendar,
    notes,
  ];

  static String moneyItemPath(String id) => '/money/item/$id';

  static String moneyEditPath(String id) => '/money/item/$id/edit';

  static String moneyNewPath({String? direction}) {
    if (direction == null || direction.isEmpty) return moneyNew.path;
    return '${moneyNew.path}?direction=$direction';
  }

  /// Looks up a route by exact [path]; nested money paths stay on Accounts.
  static AppRoute fromPath(String path) {
    final normalized = path.isEmpty ? '/' : path;
    for (final route in primary) {
      if (route.path == normalized) return route;
    }
    if (normalized == money.path ||
        normalized.startsWith('${money.path}/')) {
      return money;
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
