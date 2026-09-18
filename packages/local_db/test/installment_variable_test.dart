import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart';
import 'package:local_db/memory.dart';

void main() {
  late AppDatabase db;
  final now = DateTime(2026, 9, 11, 12);

  setUp(() async {
    db = openMemoryDatabase();
    await seedDemoData(db, now: now);
  });

  tearDown(() async {
    await db.close();
  });

  test('persists variable installment rows and uses them for payment', () async {
    final party = Party(
      id: 'party-var',
      name: 'قسط متغیر',
      kind: PartyKind.person,
      createdAt: now,
      updatedAt: now,
    );
    await db.upsertParty(party);

    final start = DateTime(2026, 1, 10);
    final item = MoneyItem(
      id: 'money-var',
      partyId: party.id,
      direction: MoneyDirection.pay,
      title: 'وام',
      totalAmount: 6000,
      paidAmount: 0,
      schedule: MoneySchedule.installment,
      installmentCount: 3,
      installmentAmount: 2000,
      periodsPaid: 0,
      startDate: start,
      nextDueDate: start,
      createdAt: now,
      updatedAt: now,
    );
    await db.upsertMoneyItem(item);
    await db.replaceInstallmentsFor(item.id, [
      MoneyInstallment(
        id: 'inst-1',
        moneyItemId: item.id,
        index: 1,
        dueDate: start,
        amount: 3000,
      ),
      MoneyInstallment(
        id: 'inst-2',
        moneyItemId: item.id,
        index: 2,
        dueDate: DateTime(2026, 2, 10),
        amount: 2000,
      ),
      MoneyInstallment(
        id: 'inst-3',
        moneyItemId: item.id,
        index: 3,
        dueDate: DateTime(2026, 3, 10),
        amount: 1000,
      ),
    ]);

    final loaded = await db.getMoneyItem(item.id);
    expect(loaded?.installments, hasLength(3));
    expect(loaded?.suggestedQuickPaymentAmount(), 3000);

    final paid = await db.recordPayment(
      moneyItemId: item.id,
      amount: 3000,
      now: now,
    );
    expect(paid.periodsPaid, 1);
    expect(paid.nextDueDate, DateTime(2026, 2, 10));
    expect(paid.remainingAmount, 3000);
    expect(paid.suggestedQuickPaymentAmount(), 2000);
  });

  test('backup round-trips installment overrides', () async {
    final party = (await db.listParties()).first;
    final item = MoneyItem(
      id: 'money-backup-inst',
      partyId: party.id,
      direction: MoneyDirection.pay,
      title: 'پشتیبان قسط',
      totalAmount: 5000,
      paidAmount: 0,
      schedule: MoneySchedule.installment,
      installmentCount: 2,
      installmentAmount: 2500,
      startDate: now,
      nextDueDate: now,
      createdAt: now,
      updatedAt: now,
    );
    await db.upsertMoneyItem(item);
    await db.replaceInstallmentsFor(item.id, [
      MoneyInstallment(
        id: 'bi-1',
        moneyItemId: item.id,
        index: 1,
        dueDate: now,
        amount: 3500,
      ),
      MoneyInstallment(
        id: 'bi-2',
        moneyItemId: item.id,
        index: 2,
        dueDate: now.add(const Duration(days: 30)),
        amount: 1500,
      ),
    ]);

    final json = await db.exportBackupJson();
    final clone = openMemoryDatabase();
    addTearDown(clone.close);
    await clone.importBackupJson(json);
    final restored = await clone.getMoneyItem(item.id);
    expect(restored?.installments, hasLength(2));
    expect(restored?.installments.first.amount, 3500);
    expect(restored?.installments.last.amount, 1500);
  });
}
