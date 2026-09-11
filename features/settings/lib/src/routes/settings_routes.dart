import 'package:core/core.dart' show AppRoutes, buildRoutePage;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/settings_page.dart';

List<RouteBase> buildSettingsRoutes(Ref ref) {
  return [
    GoRoute(
      path: AppRoutes.settings.path,
      name: AppRoutes.settings.name,
      pageBuilder: (context, state) =>
          buildRoutePage(state: state, child: const SettingsPage()),
    ),
  ];
}
