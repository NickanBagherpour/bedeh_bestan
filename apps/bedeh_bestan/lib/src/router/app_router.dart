import 'package:core/core.dart' show AppRoutes;
import 'package:feature_calendar/calendar.dart'
    show buildCalendarOverlayRoutes, buildCalendarRoutes;
import 'package:feature_home/home.dart' show buildHomeRoutes;
import 'package:feature_money/money.dart'
    show buildMoneyOverlayRoutes, buildMoneyRoutes;
import 'package:feature_notes/notes.dart' show buildNotesRoutes;
import 'package:feature_settings/settings.dart' show buildSettingsRoutes;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../navigation/app_shell.dart';

/// Single composition point for the app's routes.
///
/// Each feature owns `build<Name>Routes`. The four primary destinations live
/// inside one [ShellRoute] so they share [AppShell] chrome.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home.path,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          ...buildHomeRoutes(ref),
          ...buildMoneyRoutes(ref),
          ...buildCalendarRoutes(ref),
          ...buildNotesRoutes(ref),
        ],
      ),
      ...buildMoneyOverlayRoutes(ref),
      ...buildCalendarOverlayRoutes(ref),
      ...buildSettingsRoutes(ref),
    ],
  );
});
