import 'package:core/core.dart' show AppRoutes, buildRoutePage;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/calendar_page.dart';

List<RouteBase> buildCalendarRoutes(Ref ref) {
  return [
    GoRoute(
      path: AppRoutes.calendar.path,
      name: AppRoutes.calendar.name,
      pageBuilder: (context, state) =>
          buildRoutePage(state: state, child: const CalendarPage()),
    ),
  ];
}
