import 'package:core/core.dart' show AppRoutes, buildRoutePage, buildTabPage;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/assets_page.dart';
import '../presentation/pages/profile_page.dart';

/// Primary destination — lives inside the app shell (bottom navigation).
///
/// Public for now; TODO(auth): redirect to sign-in when AuthSession is empty.
List<RouteBase> buildProfileRoutes(Ref ref) {
  return [
    GoRoute(
      path: AppRoutes.profile.path,
      name: AppRoutes.profile.name,
      pageBuilder: (context, state) =>
          buildTabPage(state: state, child: const ProfilePage()),
    ),
  ];
}

/// Nested profile screens pushed over the shell.
List<RouteBase> buildProfileOverlayRoutes(Ref ref) {
  return [
    GoRoute(
      path: AppRoutes.profileAssets.path,
      name: AppRoutes.profileAssets.name,
      pageBuilder: (context, state) =>
          buildRoutePage(state: state, child: const AssetsPage()),
    ),
  ];
}
