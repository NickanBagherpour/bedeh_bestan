import 'package:core/core.dart' show AppRoute, AppRoutes;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:translations/translations.dart' show Translations;
import 'package:ui_kit/ui_kit.dart'
    show
        AppGradients,
        AppHaptics,
        AppMotion,
        AppSpacing,
        KitScreenBackground;

/// A single primary destination in the bottom navigation bar.
class _Destination {
  const _Destination({
    required this.route,
    required this.labelOf,
    required this.icon,
    required this.selectedIcon,
    required this.gradient,
  });

  final AppRoute route;
  final String Function(Translations t) labelOf;
  final IconData icon;
  final IconData selectedIcon;
  final Gradient gradient;
}

const List<_Destination> _destinations = [
  _Destination(
    route: AppRoutes.home,
    labelOf: _homeLabel,
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
    gradient: AppGradients.brand,
  ),
  _Destination(
    route: AppRoutes.money,
    labelOf: _moneyLabel,
    icon: Icons.account_balance_wallet_outlined,
    selectedIcon: Icons.account_balance_wallet_rounded,
    gradient: AppGradients.receive,
  ),
  _Destination(
    route: AppRoutes.calendar,
    labelOf: _calendarLabel,
    icon: Icons.calendar_month_outlined,
    selectedIcon: Icons.calendar_month_rounded,
    gradient: AppGradients.reminder,
  ),
  _Destination(
    route: AppRoutes.notes,
    labelOf: _notesLabel,
    icon: Icons.sticky_note_2_outlined,
    selectedIcon: Icons.sticky_note_2_rounded,
    gradient: AppGradients.pay,
  ),
];

String _homeLabel(Translations t) => t.app.nav.home;
String _moneyLabel(Translations t) => t.app.nav.money;
String _calendarLabel(Translations t) => t.app.nav.calendar;
String _notesLabel(Translations t) => t.app.nav.notes;

/// Persistent navigation chrome shared by the four primary destinations.
///
/// Owned by the app (not a feature). Renders an ambient aurora background and
/// a floating, animated pill navigation bar for an expressive, unique feel.
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
    if (route.path != current) {
      AppHaptics.selection();
      context.go(route.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(context);
    final t = Translations.of(context);

    // The ambient aurora wraps the whole scaffold (which is transparent) so it
    // shows behind both the body and the floating nav bar. `extendBody` stays
    // off so each destination's FAB is inset above the nav bar instead of
    // sliding underneath it.
    return KitScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(bottom: false, child: child),
        bottomNavigationBar: _FloatingNavBar(
          selectedIndex: selectedIndex,
          onSelected: (index) => _onDestinationSelected(context, index),
          labels: [for (final d in _destinations) d.labelOf(t)],
        ),
      ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({
    required this.selectedIndex,
    required this.onSelected,
    required this.labels,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: isDark ? 0.92 : 0.96),
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            border: Border.all(color: theme.dividerColor),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.42)
                    : const Color(0x2A2A2870),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                for (var i = 0; i < _destinations.length; i++)
                  Expanded(
                    child: _NavItem(
                      destination: _destinations[i],
                      label: labels[i],
                      selected: i == selectedIndex,
                      onTap: () => onSelected(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final _Destination destination;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onColor = theme.colorScheme.onSurfaceVariant;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: AnimatedContainer(
          duration: AppMotion.normal,
          curve: AppMotion.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxs,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            gradient: selected ? destination.gradient : null,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            boxShadow: selected
                ? AppGradients.glow(
                    destination.gradient.colors.first,
                    strength: 0.34,
                  )
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: selected ? 1.12 : 1,
                duration: AppMotion.normal,
                curve: Curves.easeOutBack,
                child: Icon(
                  selected ? destination.selectedIcon : destination.icon,
                  size: 24,
                  color: selected ? Colors.white : onColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: selected ? Colors.white : onColor,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
