import 'package:core/core.dart'
    show
        appSettingsProvider,
        appStorageProvider,
        decodeNoticePayload,
        notificationSchedulerProvider;
import 'package:feature_money/money.dart'
    show
        MoneyNotificationActionResult,
        applyMoneyNotificationAction,
        moneySnoozeTickProvider,
        syncMoneyNoticesNow;
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
    final database = container.read(appDatabaseProvider);
    final storage = container.read(appStorageProvider);
    final result = await applyMoneyNotificationAction(
      database: database,
      storage: storage,
      actionId: actionId,
      moneyItemId: itemId,
    );
    if (result == MoneyNotificationActionResult.paid ||
        result == MoneyNotificationActionResult.snoozed) {
      final settings = container.read(appSettingsProvider);
      await syncMoneyNoticesNow(
        database: database,
        storage: storage,
        scheduler: container.read(notificationSchedulerProvider),
        appPolicy: settings.moneyReminderPolicy,
        calendar: settings.resolvedCalendar,
      );
    }
    if (result == MoneyNotificationActionResult.snoozed) {
      container.read(moneySnoozeTickProvider.notifier).bump();
    }
    return;
  }
  if (decoded.route.startsWith('/')) {
    container.read(pendingNotificationRouteProvider.notifier).set(decoded.route);
  }
}
