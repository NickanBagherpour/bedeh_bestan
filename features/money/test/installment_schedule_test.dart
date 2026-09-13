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

  test('keeps the full list when there are 5 or fewer قسط‌ها', () {
    final rows = installmentSchedule(
      item(installmentCount: 5, installmentAmount: 1000, total: 5000),
      CalendarType.gregorian,
    );
    expect(rows, hasLength(5));
    expect(
      visibleInstallmentRows(rows, expanded: false),
      rows,
    );
  });

  test('collapsed long schedule hides paid rows and caps unpaid at 5', () {
    final rows = installmentSchedule(
      item(paid: 3000, periodsPaid: 3),
      CalendarType.gregorian,
    );
    expect(rows, hasLength(12));
    final visible = visibleInstallmentRows(rows, expanded: false);
    expect(visible, hasLength(5));
    expect(visible.first.state, InstallmentState.due);
    expect(
      visible.skip(1).every((row) => row.state == InstallmentState.upcoming),
      isTrue,
    );
    expect(visible.first.index, 4);
    expect(visible.last.index, 8);
  });

  test('expanded long schedule returns every row', () {
    final rows = installmentSchedule(item(), CalendarType.gregorian);
    expect(visibleInstallmentRows(rows, expanded: true), rows);
  });

  test('settle amount is one قسط, capped at remaining', () {
    final rows = installmentSchedule(
      item(total: 2500, paid: 2000, periodsPaid: 2, installmentCount: 3),
      CalendarType.gregorian,
    );
    final due = rows.firstWhere((row) => row.state == InstallmentState.due);
    expect(due.amount, 1000);
    expect(installmentRowSettleAmount(due, 500), 500);
    expect(installmentRowSettleAmount(due, 1000), 1000);
    expect(installmentRowSettleAmount(due, 0), 0);
  });
}
