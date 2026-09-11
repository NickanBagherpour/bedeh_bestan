import 'package:core/core.dart' show AppRoutes, buildRoutePage;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/money_page.dart';

List<RouteBase> buildMoneyRoutes(Ref ref) {
  return [
    GoRoute(
      path: AppRoutes.money.path,
      name: AppRoutes.money.name,
      pageBuilder: (context, state) =>
          buildRoutePage(state: state, child: const MoneyPage()),
    ),
  ];
}
