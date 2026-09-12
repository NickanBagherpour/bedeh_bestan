import 'package:feature_money/src/application/money_query.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart';

void main() {
  final now = DateTime(2026, 9, 12);

  MoneyItem item({
    MoneySchedule schedule = MoneySchedule.installment,
    int total = 3000,
    int paid = 0,
    int? installmentAmount = 1000,
    int? installmentCount = 3,
  }) {
    return MoneyItem(
      id: 'i',
      partyId: 'p',
      direction: MoneyDirection.pay,
      title: 'i',
      totalAmount: total,
      paidAmount: paid,
      schedule: schedule,
      startDate: now,
      nextDueDate: now,
      createdAt: now,
      updatedAt: now,
      installmentCount: installmentCount,
      installmentAmount: installmentAmount,
    );
  }

  test('suggests the installment amount for an unsettled installment item', () {
    expect(installmentPrefillAmount(item()), 1000);
  });

  test('caps the suggestion at the remaining balance', () {
    // Two قسط paid (2000), remaining 1000, but 500 left is less than one قسط.
    final almostDone = item(total: 2500, paid: 2000, installmentAmount: 1000);
    expect(installmentPrefillAmount(almostDone), 500);
  });

  test('returns null for settled items', () {
    expect(installmentPrefillAmount(item(paid: 3000)), isNull);
  });

  test('returns null for one-time items', () {
    expect(installmentPrefillAmount(item(schedule: MoneySchedule.oneTime)), isNull);
  });

  test('returns null when no installment amount is stored', () {
    expect(installmentPrefillAmount(item(installmentAmount: null)), isNull);
  });
}
