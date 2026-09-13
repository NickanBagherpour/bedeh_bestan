import 'package:core/core.dart' show AppRoutes, buildRoutePage, buildTabPage;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/calendar_page.dart';
import '../presentation/pages/reminder_detail_page.dart';
import '../presentation/pages/reminder_form_page.dart';

List<RouteBase> buildCalendarRoutes(Ref ref) {
  return [
    GoRoute(
      path: AppRoutes.calendar.path,
      name: AppRoutes.calendar.name,
      pageBuilder: (context, state) =>
          buildTabPage(state: state, child: const CalendarPage()),
    ),
  ];
}

/// Form / detail sit above [AppShell] so the bottom nav is hidden.
List<RouteBase> buildCalendarOverlayRoutes(Ref ref) {
  return [
    GoRoute(
      path: AppRoutes.calendarNew.path,
      name: AppRoutes.calendarNew.name,
      pageBuilder: (context, state) {
        return buildRoutePage(
          state: state,
          child: ReminderFormPage(initialDay: _dayQuery(state)),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.calendarItem.path,
      name: AppRoutes.calendarItem.name,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return buildRoutePage(
          state: state,
          child: ReminderDetailPage(reminderId: id),
        );
      },
      routes: [
        GoRoute(
          path: 'edit',
          name: AppRoutes.calendarEdit.name,
          pageBuilder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return buildRoutePage(
              state: state,
              child: ReminderFormPage(reminderId: id),
            );
          },
        ),
      ],
    ),
  ];
}

DateTime? _dayQuery(GoRouterState state) {
  final raw = state.uri.queryParameters['day'];
  if (raw == null || raw.isEmpty) return null;
  final parts = raw.split('-');
  if (parts.length != 3) return null;
  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);
  if (year == null || month == null || day == null) return null;
  return DateTime(year, month, day);
}
