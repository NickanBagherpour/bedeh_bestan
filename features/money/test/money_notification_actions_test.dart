import 'package:core/core.dart' show AppStorage;
import 'package:feature_money/src/application/money_notifications.dart';
import 'package:feature_money/src/application/notifications/money_notification_actions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart';
import 'package:local_db/memory.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;
  late AppStorage storage;
  final now = DateTime(2026, 9, 12, 12);

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    storage = AppStorage(preferences: prefs);
    db = openMemoryDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  Future<MoneyItem> insertOpen() async {
    final party = Party(
      id: 'p',
      name: 'علی',
      kind: PartyKind.person,
      createdAt: now,
      updatedAt: now,
    );
    await db.upsertParty(party);
    final item = MoneyItem(
      id: 'm1',
      partyId: party.id,
      direction: MoneyDirection.pay,
      title: 'قرض',
      totalAmount: 1000,
      paidAmount: 0,
      schedule: MoneySchedule.oneTime,
      startDate: now,
      nextDueDate: now.add(const Duration(days: 2)),
      createdAt: now,
      updatedAt: now,
    );
    await db.upsertMoneyItem(item);
    return item;
  }

  test('pay action records remaining and is ignored when settled', () async {
    await insertOpen();
    final paid = await applyMoneyNotificationAction(
      database: db,
      storage: storage,
      actionId: 'pay',
      moneyItemId: 'm1',
      now: now,
    );
    expect(paid, MoneyNotificationActionResult.paid);
    expect((await db.getMoneyItem('m1'))?.isSettled, isTrue);

    final again = await applyMoneyNotificationAction(
      database: db,
      storage: storage,
      actionId: 'pay',
      moneyItemId: 'm1',
      now: now,
    );
    expect(again, MoneyNotificationActionResult.ignored);
  });

  test('snooze action persists tomorrow 09:00', () async {
    await insertOpen();
    final result = await applyMoneyNotificationAction(
      database: db,
      storage: storage,
      actionId: 'snooze',
      moneyItemId: 'm1',
      now: now,
    );
    expect(result, MoneyNotificationActionResult.snoozed);
    final raw = storage.readString(moneySnoozeUntilKey);
    expect(raw, isNotNull);
    expect(raw, contains('m1'));
  });
}
