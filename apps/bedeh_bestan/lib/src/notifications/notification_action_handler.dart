import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart' show appDatabaseProvider;

import 'pending_notification.dart';

/// Handles notification payloads and action ids from the OS shade.
Future<void> handleNotificationPayload(
  ProviderContainer container,
  String payload, {
  String? actionId,
}) async {
  if (actionId == 'pay' && payload.startsWith('/money/item/')) {
    final itemId = payload.split('/').last;
    final db = container.read(appDatabaseProvider);
    final item = await db.getMoneyItem(itemId);
    final amount = item?.suggestedQuickPaymentAmount();
    if (item != null && amount != null && amount > 0) {
      await db.recordPayment(moneyItemId: itemId, amount: amount);
    }
    return;
  }
  if (actionId == 'snooze' && payload.startsWith('/money/item/')) {
    // Opens the item on next tap; full snooze reschedule is a follow-up.
    container.read(pendingNotificationRouteProvider.notifier).set(payload);
    return;
  }
  if (payload.startsWith('/')) {
    container.read(pendingNotificationRouteProvider.notifier).set(payload);
  }
}
