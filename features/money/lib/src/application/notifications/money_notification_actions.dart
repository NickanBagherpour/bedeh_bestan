import 'package:core/core.dart' show AppStorage;
import 'package:local_db/local_db.dart' show AppDatabase;

import '../money_notifications.dart';

enum MoneyNotificationActionResult { none, paid, snoozed, ignored }

/// Applies a shade action. Confirm is not required — the user tapped the button.
Future<MoneyNotificationActionResult> applyMoneyNotificationAction({
  required AppDatabase database,
  required AppStorage storage,
  required String actionId,
  required String moneyItemId,
  DateTime? now,
}) async {
  final clock = now ?? DateTime.now();
  if (actionId == 'pay') {
    final item = await database.getMoneyItem(moneyItemId);
    final amount = item?.suggestedQuickPaymentAmount();
    if (item == null || amount == null || amount <= 0) {
      await clearMoneySnooze(storage, moneyItemId);
      return MoneyNotificationActionResult.ignored;
    }
    await database.recordPayment(moneyItemId: moneyItemId, amount: amount);
    await clearMoneySnooze(storage, moneyItemId);
    return MoneyNotificationActionResult.paid;
  }
  if (actionId == 'snooze') {
    final item = await database.getMoneyItem(moneyItemId);
    if (item == null || item.isSettled) {
      await clearMoneySnooze(storage, moneyItemId);
      return MoneyNotificationActionResult.ignored;
    }
    await saveMoneySnooze(storage, moneyItemId, moneySnoozeInstant(clock));
    return MoneyNotificationActionResult.snoozed;
  }
  return MoneyNotificationActionResult.none;
}

Future<void> saveMoneySnooze(
  AppStorage storage,
  String itemId,
  DateTime until,
) async {
  final next = decodeSnoozeUntilJson(storage.readString(moneySnoozeUntilKey));
  next[itemId] = until;
  await storage.writeString(moneySnoozeUntilKey, encodeSnoozeUntilJson(next));
}

Future<void> clearMoneySnooze(AppStorage storage, String itemId) async {
  final next = decodeSnoozeUntilJson(storage.readString(moneySnoozeUntilKey));
  if (!next.containsKey(itemId)) return;
  next.remove(itemId);
  await storage.writeString(moneySnoozeUntilKey, encodeSnoozeUntilJson(next));
}
