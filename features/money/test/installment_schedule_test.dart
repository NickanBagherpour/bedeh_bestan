import 'package:core/core.dart' show CalendarType;
import 'package:feature_money/src/application/money_query.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart';

void main() {
  final start = DateTime(2026, 1, 10);

  MoneyItem item({
    MoneySchedule schedule = MoneySchedule.installment,
    int total = 12000,
    int paid = 0,
    int? installmentAmount = 1000,
    int? installmentCount = 12,
    int periodsPaid = 0,
  }) {
    return MoneyItem(
      id: 'i',
      partyId: 'p',
      direction: MoneyDirection.pay,
      title: 'i',
      totalAmount: total,
      paidAmount: paid,
      schedule: schedule,
      startDate: start,
      nextDueDate: start,
      createdAt: start,
      updatedAt: start,
      installmentCount: installmentCount,
      installmentAmount: installmentAmount,
      periodsPaid: periodsPaid,
    );
  }

  test('builds one row per قسط with monthly Gregorian due dates', () {
    final rows = installmentSchedule(item(), CalendarType.gregorian);
    expect(rows, hasLength(12));
    expect(rows.first.index, 1);
    expect(rows.first.dueDate, DateTime(2026, 1, 10));
    expect(rows[1].dueDate, DateTime(2026, 2, 10));
    expect(rows.last.dueDate, DateTime(2026, 12, 10));
    expect(rows.every((row) => row.amount == 1000), isTrue);
  });

  test('marks paid, the current due قسط, then upcoming', () {
    final rows = installmentSchedule(
      item(paid: 3000, periodsPaid: 3),
      CalendarType.gregorian,
    );
    expect(
      rows.take(5).map((row) => row.state),
      [
        InstallmentState.paid,
        InstallmentState.paid,
        InstallmentState.paid,
        InstallmentState.due,
        InstallmentState.upcoming,
      ],
    );
  });

  test('shifts due dates in the Jalali calendar', () {
    final rows = installmentSchedule(item(), CalendarType.jalali);
    // One Jalali month after start; day-of-month stays the same in Jalali.
    expect(rows[1].dueDate.isAfter(rows.first.dueDate), isTrue);
    expect(rows.length, 12);
  });

  test('derives an equal amount when installmentAmount is missing', () {
    final rows = installmentSchedule(
      item(installmentAmount: null, total: 12000, installmentCount: 12),
      CalendarType.gregorian,
    );
    expect(rows.first.amount, 1000);
  });

  test('is empty for one-time items or a missing count', () {
    expect(
      installmentSchedule(
        item(schedule: MoneySchedule.oneTime),
        CalendarType.gregorian,
      ),
      isEmpty,
    );
    expect(
      installmentSchedule(item(installmentCount: null), CalendarType.gregorian),
      isEmpty,
    );
  });
}
