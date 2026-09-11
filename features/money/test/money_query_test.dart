import 'package:feature_money/src/application/money_query.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart';

void main() {
  final now = DateTime(2026, 9, 11);

  MoneyItem item({
    required String id,
    required DateTime due,
    MoneyDirection direction = MoneyDirection.pay,
    int paid = 0,
  }) {
    return MoneyItem(
      id: id,
      partyId: 'p',
      direction: direction,
      title: id,
      totalAmount: 1000,
      paidAmount: paid,
      schedule: MoneySchedule.oneTime,
      startDate: due,
      nextDueDate: due,
      createdAt: now,
      updatedAt: now,
    );
  }

  test('sorts overdue first and hides settled', () {
    final overdue = item(id: 'o', due: now.subtract(const Duration(days: 2)));
    final today = item(id: 't', due: now);
    final upcoming = item(id: 'u', due: now.add(const Duration(days: 3)));
    final settled = item(id: 's', due: now, paid: 1000);
    final receive = item(
      id: 'r',
      due: now.add(const Duration(days: 1)),
      direction: MoneyDirection.receive,
    );

    final visible = visibleMoneyItems(
      items: [upcoming, settled, overdue, receive, today],
      filter: MoneyListFilter.all,
      hideSettled: true,
      now: now,
    );
    expect(visible.map((row) => row.id), ['o', 't', 'r', 'u']);

    final onlyReceive = visibleMoneyItems(
      items: [upcoming, receive, overdue],
      filter: MoneyListFilter.receive,
      hideSettled: true,
      now: now,
    );
    expect(onlyReceive.map((row) => row.id), ['r']);
  });
}
