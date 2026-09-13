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

  test('installment range schedules each unpaid قسط', () {
    final loan = MoneyItem(
      id: 'loan',
      partyId: 'p',
      direction: MoneyDirection.pay,
      title: 'loan',
      totalAmount: 300,
      paidAmount: 0,
      schedule: MoneySchedule.installment,
      installmentCount: 3,
      installmentAmount: 100,
      startDate: DateTime(2026, 10, 1),
      nextDueDate: DateTime(2026, 10, 1),
      createdAt: now,
      updatedAt: now,
    );
    final notices = upcomingMoneyNotices(
      items: [loan],
      now: now,
      appPolicy: policy,
      calendar: CalendarType.gregorian,
      dueTitle: (_) => 'due',
      dueSoonTitle: (_) => 'soon',
      body: (item, {installmentIndex}) => '${item.title}-$installmentIndex',
    );
    expect(notices, hasLength(9));
    expect(
      notices.where((n) => n.body == 'loan-1').map((n) => n.at),
      [
        DateTime(2026, 9, 24, 9),
        DateTime(2026, 9, 29, 9),
        DateTime(2026, 10, 1, 9),
      ],
    );
  });

  test('item exact override ignores global range', () {
    final notices = upcomingMoneyNotices(
      items: [
        item(id: 'a', due: DateTime(2026, 9, 20)).copyWith(
          reminderPolicy: 'exactDay',
        ),
      ],
      now: now,
      appPolicy: policy,
      calendar: CalendarType.gregorian,
      dueTitle: (_) => 'due',
      dueSoonTitle: (_) => 'soon',
      body: (item, {installmentIndex}) => item.title,
    );
    expect(notices, hasLength(1));
    expect(notices.single.at, DateTime(2026, 9, 20, 9));
  });

  test('custom range one day before includes due day', () {
    final notices = upcomingMoneyNotices(
      items: [
        item(id: 'a', due: DateTime(2026, 9, 20)).copyWith(
          reminderPolicy: 'customRange',
          reminderDaysBeforeJson: '[1]',
        ),
      ],
      now: now,
      appPolicy: policy,
      calendar: CalendarType.gregorian,
      dueTitle: (_) => 'due',
      dueSoonTitle: (_) => 'soon',
      body: (item, {installmentIndex}) => item.title,
    );
    expect(notices.map((n) => n.at), [
      DateTime(2026, 9, 19, 9),
      DateTime(2026, 9, 20, 9),
    ]);
  });

  test('snooze drops earlier instants and adds tomorrow morning', () {
    final notices = upcomingMoneyNotices(
      items: [item(id: 'a', due: DateTime(2026, 9, 20))],
      now: now,
      appPolicy: policy,
      calendar: CalendarType.gregorian,
      dueTitle: (_) => 'due',
      dueSoonTitle: (_) => 'soon',
      body: (item, {installmentIndex}) => item.title,
      snoozeUntil: { 'a': DateTime(2026, 9, 13, 9) },
    );
    expect(notices.map((n) => n.at), [
      DateTime(2026, 9, 13, 9),
      DateTime(2026, 9, 18, 9),
      DateTime(2026, 9, 20, 9),
    ]);
    expect(notices.where((n) => n.at == DateTime(2026, 9, 13, 9)), hasLength(1));
  });
}
