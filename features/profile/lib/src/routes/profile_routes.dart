import 'package:core/core.dart' show AppRoutes, buildRoutePage;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/assets_page.dart';
import '../presentation/pages/profile_page.dart';

List<RouteBase> buildProfileRoutes(Ref ref) {
  // TODO(auth): redirect to sign-in when AuthSession empty.
  return [
    GoRoute(
      path: AppRoutes.profile.path,
      name: AppRoutes.profile.name,
      pageBuilder: (context, state) =>
          buildRoutePage(state: state, child: const ProfilePage()),
    ),
    GoRoute(
      path: AppRoutes.profileAssets.path,
      name: AppRoutes.profileAssets.name,
      pageBuilder: (context, state) =>
          buildRoutePage(state: state, child: const AssetsPage()),
    ),
  ];
}
