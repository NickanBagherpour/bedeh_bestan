import 'package:core/core.dart' show AppRoutes, buildRoutePage;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart' show MoneyDirection;

import '../presentation/pages/money_detail_page.dart';
import '../presentation/pages/money_form_page.dart';
import '../presentation/pages/money_page.dart';
import '../presentation/pages/party_detail_page.dart';
import '../presentation/pages/party_form_page.dart';
import '../presentation/pages/party_list_page.dart';

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

/// Form / detail sit above [AppShell] so the bottom nav is hidden.
List<RouteBase> buildMoneyOverlayRoutes(Ref ref) {
  return [
    GoRoute(
      path: AppRoutes.moneyNew.path,
      name: AppRoutes.moneyNew.name,
      pageBuilder: (context, state) {
        final raw = state.uri.queryParameters['direction'];
        final direction = switch (raw) {
          'pay' => MoneyDirection.pay,
          'receive' => MoneyDirection.receive,
          _ => null,
        };
        return buildRoutePage(
          state: state,
          child: MoneyFormPage(initialDirection: direction),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.moneyItem.path,
      name: AppRoutes.moneyItem.name,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return buildRoutePage(
          state: state,
          child: MoneyDetailPage(itemId: id),
        );
      },
      routes: [
        GoRoute(
          path: 'edit',
          name: AppRoutes.moneyEdit.name,
          pageBuilder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return buildRoutePage(
              state: state,
              child: MoneyFormPage(itemId: id),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.parties.path,
      name: AppRoutes.parties.name,
      pageBuilder: (context, state) =>
          buildRoutePage(state: state, child: const PartyListPage()),
    ),
    GoRoute(
      path: AppRoutes.partyNew.path,
      name: AppRoutes.partyNew.name,
      pageBuilder: (context, state) =>
          buildRoutePage(state: state, child: const PartyFormPage()),
    ),
    GoRoute(
      path: AppRoutes.partyItem.path,
      name: AppRoutes.partyItem.name,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return buildRoutePage(
          state: state,
          child: PartyDetailPage(partyId: id),
        );
      },
      routes: [
        GoRoute(
          path: 'edit',
          name: AppRoutes.partyEdit.name,
          pageBuilder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return buildRoutePage(
              state: state,
              child: PartyFormPage(partyId: id),
            );
          },
        ),
      ],
    ),
  ];
}
