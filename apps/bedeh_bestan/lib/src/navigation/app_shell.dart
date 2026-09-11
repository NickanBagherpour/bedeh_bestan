import 'package:core/core.dart' show AppRoute, AppRoutes;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:translations/translations.dart' show Translations;

/// A single primary destination in the bottom navigation bar.
class _Destination {
  const _Destination({
    required this.route,
    required this.labelOf,
    required this.icon,
    required this.selectedIcon,
  });

  final AppRoute route;
  final String Function(Translations t) labelOf;
  final IconData icon;
  final IconData selectedIcon;
}

const List<_Destination> _destinations = [
  _Destination(
    route: AppRoutes.home,
    labelOf: _homeLabel,
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
  ),
  _Destination(
    route: AppRoutes.money,
    labelOf: _moneyLabel,
    icon: Icons.account_balance_wallet_outlined,
    selectedIcon: Icons.account_balance_wallet_rounded,
  ),
  _Destination(
    route: AppRoutes.calendar,
    labelOf: _calendarLabel,
    icon: Icons.calendar_month_outlined,
    selectedIcon: Icons.calendar_month_rounded,
  ),
  _Destination(
    route: AppRoutes.notes,
    labelOf: _notesLabel,
    icon: Icons.sticky_note_2_outlined,
    selectedIcon: Icons.sticky_note_2_rounded,
  ),
];

String _homeLabel(Translations t) => t.app.nav.home;
String _moneyLabel(Translations t) => t.app.nav.money;
String _calendarLabel(Translations t) => t.app.nav.calendar;
String _notesLabel(Translations t) => t.app.nav.notes;

/// Persistent navigation chrome shared by the four primary destinations.
///
/// Owned by the app (not a feature), mirroring the devportal `AppShell`
/// pattern but using a bottom navigation bar for a mobile-first product.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return AppRoutes.indexOfPath(location);
  }

  void _onDestinationSelected(BuildContext context, int index) {
    final route = _destinations[index].route;
    final current = GoRouterState.of(context).uri.path;
    if (route.path != current) context.go(route.path);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(context);
    final t = Translations.of(context);

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) =>
            _onDestinationSelected(context, index),
        destinations: [
          for (final destination in _destinations)
            NavigationDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: destination.labelOf(t),
            ),
        ],
      ),
    );
  }
}
