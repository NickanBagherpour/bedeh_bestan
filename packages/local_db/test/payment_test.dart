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

  tearDown(() async {
    await db.close();
  });

  test('partial payment reduces remaining', () async {
    final updated = await db.recordPayment(
      moneyItemId: SeedIds.shopOverdue,
      amount: 100000,
      now: now,
    );
    expect(updated.paidAmount, 100000);
    expect(updated.remainingAmount, 750000);
    expect(updated.statusOn(now), MoneyStatus.overdue);

    final payments = await db.listPaymentsFor(SeedIds.shopOverdue);
    expect(payments, hasLength(1));
  });

  test('full installment payment advances period and due date', () async {
    final before = (await db.getMoneyItem(SeedIds.melliInstallment))!;
    expect(before.periodsPaid, 3);
    expect(before.nextDueDate, DateTime(2026, 9, 13));

    final updated = await db.recordPayment(
      moneyItemId: SeedIds.melliInstallment,
      amount: 5000000,
      now: now,
    );
    expect(updated.periodsPaid, 4);
    expect(updated.remainingAmount, 40000000);
    expect(updated.nextDueDate, DateTime(2026, 10, 13));
  });

  test('payment above remaining is rejected', () async {
    expect(
      () => db.recordPayment(
        moneyItemId: SeedIds.aliDue,
        amount: 9 * 1000 * 1000,
        now: now,
      ),
      throwsA(
        isA<PaymentException>().having(
          (error) => error.failure,
          'failure',
          PaymentFailure.exceedsRemaining,
        ),
      ),
    );
  });
}
