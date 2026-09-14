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
  static const parties = AppRoute(name: 'parties', path: '/money/parties');
  static const partyNew = AppRoute(name: 'partyNew', path: '/money/parties/new');
  static const partyItem = AppRoute(
    name: 'partyItem',
    path: '/money/parties/:id',
  );
  static const partyEdit = AppRoute(
    name: 'partyEdit',
    path: '/money/parties/:id/edit',
  );
  static const calendar = AppRoute(name: 'calendar', path: '/calendar');
  static const calendarNew = AppRoute(name: 'calendarNew', path: '/calendar/new');
  static const calendarItem = AppRoute(
    name: 'calendarItem',
    path: '/calendar/item/:id',
  );
  static const calendarEdit = AppRoute(
    name: 'calendarEdit',
    path: '/calendar/item/:id/edit',
  );
  static const notes = AppRoute(name: 'notes', path: '/notes');
  static const notesNew = AppRoute(name: 'notesNew', path: '/notes/new');
  static const notesItem = AppRoute(name: 'notesItem', path: '/notes/item/:id');
  static const notesEdit = AppRoute(
    name: 'notesEdit',
    path: '/notes/item/:id/edit',
  );
  static const settings = AppRoute(name: 'settings', path: '/settings');
  static const profile = AppRoute(name: 'profile', path: '/profile');
  static const profileAssets =
      AppRoute(name: 'profileAssets', path: '/profile/assets');

  /// Primary destinations in bottom-nav order.
  static const List<AppRoute> primary = [home, money, calendar, notes, profile];

  static const List<AppRoute> all = [
    home,
    money,
    moneyNew,
    moneyItem,
    moneyEdit,
    parties,
    partyNew,
    partyItem,
    partyEdit,
    calendar,
    calendarNew,
    calendarItem,
    calendarEdit,
    notes,
    notesNew,
    notesItem,
    notesEdit,
    settings,
    profile,
    profileAssets,
  ];

  static String moneyItemPath(String id) => '/money/item/$id';

  static String moneyEditPath(String id) => '/money/item/$id/edit';

  static String partyItemPath(String id) => '/money/parties/$id';

  static String partyEditPath(String id) => '/money/parties/$id/edit';

  static String moneyNewPath({String? direction}) {
    if (direction == null || direction.isEmpty) return moneyNew.path;
    return '${moneyNew.path}?direction=$direction';
  }

  static String reminderPath(String id) => '/calendar/item/$id';

  static String reminderEditPath(String id) => '/calendar/item/$id/edit';

  static String reminderNewPath({DateTime? day}) {
    if (day == null) return calendarNew.path;
    final y = day.year.toString().padLeft(4, '0');
    final m = day.month.toString().padLeft(2, '0');
    final d = day.day.toString().padLeft(2, '0');
    return '${calendarNew.path}?day=$y-$m-$d';
  }

  static String notePath(String id) => '/notes/item/$id';

  static String noteEditPath(String id) => '/notes/item/$id/edit';

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
    if (normalized == calendar.path ||
        normalized.startsWith('${calendar.path}/')) {
      return calendar;
    }
    if (normalized == notes.path ||
        normalized.startsWith('${notes.path}/')) {
      return notes;
    }
    if (normalized == profile.path ||
        normalized.startsWith('${profile.path}/')) {
      return profile;
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
