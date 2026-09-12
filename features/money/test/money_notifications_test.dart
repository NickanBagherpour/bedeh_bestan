import 'package:feature_money/src/application/money_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart';

void main() {
  final now = DateTime(2026, 9, 12, 12);

  MoneyItem item({
    required String id,
    required DateTime due,
    int total = 1000,
    int paid = 0,
  }) {
    return MoneyItem(
      id: id,
      partyId: 'p',
      direction: MoneyDirection.pay,
      title: 'title-$id',
      totalAmount: total,
      paidAmount: paid,
      schedule: MoneySchedule.oneTime,
      startDate: due,
      nextDueDate: due,
      createdAt: now,
      updatedAt: now,
    );
  }

  List<ScheduledNoticeStub> build(
    List<MoneyItem> items, {
    bool dayBefore = true,
  }) {
    return upcomingMoneyNotices(
      items: items,
      now: now,
      dayBefore: dayBefore,
      dueTitle: (item) => 'due',
      dueSoonTitle: (item) => 'soon',
      body: (item) => item.title,
    ).map((n) => (title: n.title, at: n.at, route: n.route)).toList();
  }

  test('schedules due-date and day-before notices at 09:00', () {
    final notices = build([
      item(id: 'a', due: DateTime(2026, 9, 20)),
    ]);
    expect(notices, [
      (title: 'soon', at: DateTime(2026, 9, 19, 9), route: '/money/item/a'),
      (title: 'due', at: DateTime(2026, 9, 20, 9), route: '/money/item/a'),
    ]);
  });

  test('skips settled items and past due dates', () {
    final notices = build([
      item(id: 'settled', due: DateTime(2026, 9, 20), paid: 1000),
      item(id: 'past', due: DateTime(2026, 9, 1)),
    ]);
    expect(notices, isEmpty);
  });

  test('can disable the day-before notice', () {
    final notices = build(
      [item(id: 'a', due: DateTime(2026, 9, 20))],
      dayBefore: false,
    );
    expect(notices.map((n) => n.title), ['due']);
  });

  test('ignores items beyond the horizon', () {
    final notices = build([
      item(id: 'far', due: DateTime(2027, 6, 1)),
    ]);
    expect(notices, isEmpty);
  });
}

typedef ScheduledNoticeStub = ({String title, DateTime at, String route});
