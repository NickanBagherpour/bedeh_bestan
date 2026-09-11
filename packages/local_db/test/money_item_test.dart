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
}
