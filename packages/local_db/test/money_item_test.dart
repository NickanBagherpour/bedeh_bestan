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

    final variable = installment.copyWith(
      totalAmount: 6000,
      paidAmount: 0,
      installmentCount: 3,
      installmentAmount: 2000,
      installments: [
        MoneyInstallment(
          id: '1',
          moneyItemId: 'x',
          index: 1,
          dueDate: now,
          amount: 3500,
        ),
        MoneyInstallment(
          id: '2',
          moneyItemId: 'x',
          index: 2,
          dueDate: now.add(const Duration(days: 30)),
          amount: 1500,
        ),
        MoneyInstallment(
          id: '3',
          moneyItemId: 'x',
          index: 3,
          dueDate: now.add(const Duration(days: 60)),
          amount: 1000,
        ),
      ],
    );
    expect(variable.suggestedQuickPaymentAmount(), 3500);
    expect(
      variable.copyWith(periodsPaid: 1, paidAmount: 3500)
          .suggestedQuickPaymentAmount(),
      1500,
    );
  });

  test('addCalendarMonths clamps the day', () {
    expect(addCalendarMonths(DateTime(2026, 1, 31), 1), DateTime(2026, 2, 28));
  });
}
