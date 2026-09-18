import 'package:core/core.dart' show CalendarType, dateOnly;
import 'package:feature_calendar/src/application/occurrences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart';

void main() {
  final now = DateTime(2026, 9, 11, 10, 30);

  Reminder reminder({
    required RepeatRule rule,
    DateTime? start,
    int? everyN,
    bool allDay = false,
  }) {
    return Reminder(
      id: 'r-${rule.name}',
      title: rule.name,
      startAt: start ?? now,
      allDay: allDay,
      repeatRule: rule,
      repeatEveryN: everyN,
      notifyOnTime: true,
      notifyDayBefore: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  test('one-shot reminders only appear on their start day', () {
    final item = reminder(rule: RepeatRule.none);
    final hits = occurrenceTimes(
      item,
      start: DateTime(2026, 9, 1),
      end: DateTime(2026, 9, 30),
      calendar: CalendarType.gregorian,
    );
    expect(hits.map(dateOnly), [DateTime(2026, 9, 11)]);
    expect(
      occurrenceTimes(
        item,
        start: DateTime(2026, 8, 1),
        end: DateTime(2026, 8, 31),
        calendar: CalendarType.gregorian,
      ),
      isEmpty,
    );
  });

  test('weekly repeats keep the weekday inside the range', () {
    final item = reminder(rule: RepeatRule.weekly, start: DateTime(2026, 9, 4));
    final hits = occurrenceTimes(
      item,
      start: DateTime(2026, 9, 1),
      end: DateTime(2026, 9, 30),
      calendar: CalendarType.gregorian,
    );
    expect(hits.map(dateOnly), [
      DateTime(2026, 9, 4),
      DateTime(2026, 9, 11),
      DateTime(2026, 9, 18),
      DateTime(2026, 9, 25),
    ]);
  });

  test('monthly repeats honor Jalali months', () {
    final start = DateTime(2026, 8, 23); // 1 Shahrivar 1405
    final item = reminder(rule: RepeatRule.monthly, start: start);
    final hits = expandOccurrences(
      reminders: [item],
      rangeStart: DateTime(2026, 9, 1),
      rangeEnd: DateTime(2026, 9, 30),
      calendar: CalendarType.jalali,
    );
    expect(hits, hasLength(1));
    expect(hits.single.at.day, start.day);
  });

  test('every N days steps from the origin', () {
    final item = reminder(
      rule: RepeatRule.everyNDays,
      start: DateTime(2026, 9, 1),
      everyN: 3,
    );
    final hits = occurrenceTimes(
      item,
      start: DateTime(2026, 9, 1),
      end: DateTime(2026, 9, 10),
      calendar: CalendarType.gregorian,
    );
    expect(hits.map(dateOnly), [
      DateTime(2026, 9, 1),
      DateTime(2026, 9, 4),
      DateTime(2026, 9, 7),
      DateTime(2026, 9, 10),
    ]);
  });

  test('unsettled money due dates overlay on the calendar', () {
    final now = DateTime(2026, 9, 11);
    final open = MoneyItem(
      id: 'loan',
      partyId: 'shop',
      direction: MoneyDirection.pay,
      title: 'قسط فروشگاه',
      totalAmount: 5000,
      paidAmount: 0,
      schedule: MoneySchedule.installment,
      installmentCount: 5,
      installmentAmount: 1000,
      startDate: now,
      nextDueDate: DateTime(2026, 9, 20),
      createdAt: now,
      updatedAt: now,
    );
    final settled = open.copyWith(id: 'done', paidAmount: 5000);
    final hits = expandMoneyDueOccurrences(
      items: [open, settled],
      rangeStart: DateTime(2026, 9, 1),
      rangeEnd: DateTime(2026, 9, 30),
    );
    expect(hits, hasLength(1));
    expect(hits.single.id, 'loan');
    expect(hits.single.kind, CalendarEventKind.moneyPay);
    expect(hits.single.at, DateTime(2026, 9, 20));
    expect(
      includeCalendarOccurrence(
        hits.single,
        showEvents: true,
        showBirthdays: true,
        showMoney: false,
      ),
      isFalse,
    );
  });
}
