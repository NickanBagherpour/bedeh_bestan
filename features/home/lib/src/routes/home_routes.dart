import 'package:core/core.dart' show AppRoutes, buildTabPage;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/home_page.dart';

/// Routes to nest inside the app [ShellRoute].
List<RouteBase> buildHomeRoutes(Ref ref) {
  return [
    GoRoute(
      path: AppRoutes.home.path,
      name: AppRoutes.home.name,
      pageBuilder: (context, state) =>
          buildTabPage(state: state, child: const HomePage()),
    ),
  ];
}
