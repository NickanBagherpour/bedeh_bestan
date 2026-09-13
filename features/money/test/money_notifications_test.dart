import 'package:core/core.dart'
    show CalendarType, MoneyReminderMode, ReminderSchedulePolicy;
import 'package:feature_money/src/application/money_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart';

void main() {
  final now = DateTime(2026, 9, 12, 12);
  const policy = ReminderSchedulePolicy(
    mode: MoneyReminderMode.range,
    daysBefore: [7, 2],
  );

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

  List<({String title, DateTime at})> build(List<MoneyItem> items) {
    return upcomingMoneyNotices(
      items: items,
      now: now,
      appPolicy: policy,
      calendar: CalendarType.gregorian,
      dueTitle: (item) => 'due',
      dueSoonTitle: (item) => 'soon',
      body: (item, {installmentIndex}) => item.title,
    ).map((n) => (title: n.title, at: n.at)).toList();
  }

  test('schedules range offsets and due day at 09:00', () {
    final notices = build([
      item(id: 'a', due: DateTime(2026, 9, 20)),
    ]);
    expect(notices.map((n) => n.at), [
      DateTime(2026, 9, 13, 9),
      DateTime(2026, 9, 18, 9),
      DateTime(2026, 9, 20, 9),
    ]);
  });

  test('skips settled items and past due dates', () {
    final notices = build([
      item(id: 'settled', due: DateTime(2026, 9, 20), paid: 1000),
      item(id: 'past', due: DateTime(2026, 9, 1)),
    ]);
    expect(notices, isEmpty);
  });

  test('exact day policy fires once', () {
    final notices = upcomingMoneyNotices(
      items: [item(id: 'a', due: DateTime(2026, 9, 20))],
      now: now,
      appPolicy: ReminderSchedulePolicy.exactDay(),
      calendar: CalendarType.gregorian,
      dueTitle: (_) => 'due',
      dueSoonTitle: (_) => 'soon',
      body: (item, {installmentIndex}) => item.title,
    );
    expect(notices, hasLength(1));
    expect(notices.single.at, DateTime(2026, 9, 20, 9));
  });
}
