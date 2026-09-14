import 'package:core/core.dart' show AppRoutes;
import 'package:feature_calendar/calendar.dart'
    show buildCalendarOverlayRoutes, buildCalendarRoutes;
import 'package:feature_home/home.dart' show buildHomeRoutes;
import 'package:feature_money/money.dart'
    show buildMoneyOverlayRoutes, buildMoneyRoutes;
import 'package:feature_notes/notes.dart'
    show buildNotesOverlayRoutes, buildNotesRoutes;
import 'package:feature_profile/profile.dart'
    show buildProfileOverlayRoutes, buildProfileRoutes;
import 'package:feature_settings/settings.dart' show buildSettingsRoutes;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../navigation/app_shell.dart';
import '../notifications/pending_notification.dart';

/// Single composition point for the app's routes.
///
/// Each feature owns `build<Name>Routes`. The four primary destinations live
/// inside one [ShellRoute] so they share [AppShell] chrome.
final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.home.path,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          ...buildHomeRoutes(ref),
          ...buildMoneyRoutes(ref),
          ...buildCalendarRoutes(ref),
          ...buildNotesRoutes(ref),
          ...buildProfileRoutes(ref),
        ],
      ),
      ...buildMoneyOverlayRoutes(ref),
      ...buildCalendarOverlayRoutes(ref),
      ...buildNotesOverlayRoutes(ref),
      ...buildSettingsRoutes(ref),
      ...buildProfileOverlayRoutes(ref),
    ],
  );
  ref.listen(
    pendingNotificationRouteProvider,
    (previous, next) {
      if (next == null || next.isEmpty) return;
      router.push(next);
      ref.read(pendingNotificationRouteProvider.notifier).set(null);
    },
    fireImmediately: true,
  );
  return router;
});
