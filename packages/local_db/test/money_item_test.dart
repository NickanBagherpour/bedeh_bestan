import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart';

void main() {
  final now = DateTime(2026, 9, 11, 12);

  MoneyItem item({
    required DateTime due,
    int total = 1000,
    int paid = 0,
  }) {
    return MoneyItem(
      id: 'x',
      partyId: 'p',
      direction: MoneyDirection.pay,
      title: 't',
      totalAmount: total,
      paidAmount: paid,
      schedule: MoneySchedule.oneTime,
      startDate: due,
      nextDueDate: due,
      createdAt: now,
      updatedAt: now,
    );
  }

  test('status is derived from due date and remaining', () {
    expect(item(due: now, paid: 1000).statusOn(now), MoneyStatus.settled);
    expect(item(due: now).statusOn(now), MoneyStatus.dueToday);
    expect(
      item(due: now.subtract(const Duration(days: 1))).statusOn(now),
      MoneyStatus.overdue,
    );
    expect(
      item(due: now.add(const Duration(days: 1))).statusOn(now),
      MoneyStatus.upcoming,
    );
  });

  test('suggested quick payment is remaining or one installment', () {
    expect(item(due: now, paid: 1000).suggestedQuickPaymentAmount(), isNull);
    expect(item(due: now).suggestedQuickPaymentAmount(), 1000);
    final installment = MoneyItem(
      id: 'x',
      partyId: 'p',
      direction: MoneyDirection.pay,
      title: 't',
      totalAmount: 5000,
      paidAmount: 0,
      schedule: MoneySchedule.installment,
      installmentCount: 5,
      installmentAmount: 1000,
      startDate: now,
      nextDueDate: now,
      createdAt: now,
      updatedAt: now,
    );
    expect(installment.suggestedQuickPaymentAmount(), 1000);
    expect(
      installment.copyWith(paidAmount: 4200).suggestedQuickPaymentAmount(),
      800,
    );
  });

  test('addCalendarMonths clamps the day', () {
    expect(addCalendarMonths(DateTime(2026, 1, 31), 1), DateTime(2026, 2, 28));
  });
}
