import 'package:core/core.dart'
    show appStorageProvider, decodeNoticePayload;
import 'package:feature_money/money.dart'
    show
        MoneyNotificationActionResult,
        applyMoneyNotificationAction,
        moneySnoozeTickProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart' show appDatabaseProvider;

import 'pending_notification.dart';

/// Handles notification payloads and action ids from the OS shade.
Future<void> handleNotificationPayload(
  ProviderContainer container,
  String payload, {
  String? actionId,
}) async {
  final decoded = decodeNoticePayload(payload);
  final itemId = decoded.moneyItemId;
  if (actionId != null &&
      actionId.isNotEmpty &&
      itemId != null &&
      (actionId == 'pay' || actionId == 'snooze')) {
    final result = await applyMoneyNotificationAction(
      database: container.read(appDatabaseProvider),
      storage: container.read(appStorageProvider),
      actionId: actionId,
      moneyItemId: itemId,
    );
    if (result == MoneyNotificationActionResult.snoozed) {
      container.read(moneySnoozeTickProvider.notifier).bump();
    }
    return;
  }
  if (decoded.route.startsWith('/')) {
    container.read(pendingNotificationRouteProvider.notifier).set(decoded.route);
  }
}
