import 'package:core/core.dart' show CalendarType;
import 'package:feature_home/src/application/home_dashboard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart';

void main() {
  final now = DateTime(2026, 9, 11);

  MoneyItem money({
    required String id,
    required String partyId,
    required MoneyDirection direction,
    required DateTime due,
    int total = 1000,
    int paid = 0,
    MoneySchedule schedule = MoneySchedule.oneTime,
    int? installmentCount,
    int? installmentAmount,
  }) {
    return MoneyItem(
      id: id,
      partyId: partyId,
      direction: direction,
      title: id,
      totalAmount: total,
      paidAmount: paid,
      schedule: schedule,
      installmentCount: installmentCount,
      installmentAmount: installmentAmount,
      startDate: due,
      nextDueDate: due,
      createdAt: now,
      updatedAt: now,
    );
  }

  test('splits overdue, this week, and party balances', () {
    final ali = Party(
      id: 'ali',
      name: 'علی',
      kind: PartyKind.person,
      createdAt: now,
      updatedAt: now,
    );
    final shop = Party(
      id: 'shop',
      name: 'فروشگاه',
      kind: PartyKind.shop,
      createdAt: now,
      updatedAt: now,
    );

    final dashboard = buildHomeDashboard(
      items: [
        money(
          id: 'overdue',
          partyId: shop.id,
          direction: MoneyDirection.pay,
          due: now.subtract(const Duration(days: 3)),
          total: 800,
        ),
        money(
          id: 'week',
          partyId: ali.id,
          direction: MoneyDirection.receive,
          due: now.add(const Duration(days: 2)),
          total: 2500,
        ),
        money(
          id: 'later',
          partyId: ali.id,
          direction: MoneyDirection.receive,
          due: now.add(const Duration(days: 20)),
          total: 400,
        ),
        money(
          id: 'done',
          partyId: shop.id,
          direction: MoneyDirection.pay,
          due: now,
          total: 100,
          paid: 100,
        ),
      ],
      parties: [ali, shop],
      payments: const [],
      now: now,
      calendar: CalendarType.gregorian,
    );

    expect(dashboard.overdue.map((row) => row.id), ['overdue']);
    expect(dashboard.dueThisWeek.map((row) => row.id), ['week']);
    expect(dashboard.balances, hasLength(2));
    final aliBalance = dashboard.balances.firstWhere((row) => row.partyId == ali.id);
    expect(aliBalance.receiveRemaining, 2900);
    expect(aliBalance.payRemaining, 0);
    final shopBalance =
        dashboard.balances.firstWhere((row) => row.partyId == shop.id);
    expect(shopBalance.payRemaining, 800);
  });

  test('period report uses calendar month and payment dates', () {
    final shop = Party(
      id: 'shop',
      name: 'فروشگاه',
      kind: PartyKind.shop,
      createdAt: now,
      updatedAt: now,
    );

    final openPay = money(
      id: 'open-pay',
      partyId: shop.id,
      direction: MoneyDirection.pay,
      due: DateTime(2026, 9, 20),
      total: 5000,
      paid: 1000,
    );
    final laterPay = money(
      id: 'later-pay',
      partyId: shop.id,
      direction: MoneyDirection.pay,
      due: DateTime(2026, 10, 5),
      total: 2000,
    );
    final receive = money(
      id: 'receive',
      partyId: shop.id,
      direction: MoneyDirection.receive,
      due: DateTime(2026, 9, 15),
      total: 800,
    );

    final dashboard = buildHomeDashboard(
      items: [openPay, laterPay, receive],
      parties: [shop],
      payments: [
        MoneyPayment(
          id: 'p1',
          moneyItemId: openPay.id,
          amount: 1000,
          paidAt: DateTime(2026, 9, 2),
        ),
        MoneyPayment(
          id: 'p2',
          moneyItemId: receive.id,
          amount: 300,
          paidAt: DateTime(2026, 9, 8),
        ),
        MoneyPayment(
          id: 'p3',
          moneyItemId: openPay.id,
          amount: 50,
          paidAt: DateTime(2026, 8, 30),
        ),
      ],
      now: now,
      calendar: CalendarType.gregorian,
    );

    expect(dashboard.report.paidOut, 1000);
    expect(dashboard.report.paidIn, 300);
    expect(dashboard.report.remainingPay, 6000);
    expect(dashboard.report.remainingReceive, 800);
    expect(dashboard.report.duePayByPeriodEnd, 4000);
    expect(dashboard.report.dueReceiveByPeriodEnd, 800);
    expect(dashboard.dueThisWeek.map((row) => row.id), ['receive']);
    expect(dashboard.dueThisMonth.map((row) => row.id), ['open-pay']);
    expect(dashboard.dueThisMonth.single.suggestedAmount, 4000);
    expect(dashboard.report.periodStart, DateTime(2026, 9, 1));
    expect(dashboard.report.periodEnd, DateTime(2026, 9, 30));
    expect(dashboard.weekRange.start, DateTime(2026, 9, 11));
    expect(dashboard.weekRange.endInclusive, DateTime(2026, 9, 17));
  });

  test('jalali month lists items in Shahrivar not Mehr', () {
    final shop = Party(
      id: 'shop',
      name: 'فروشگاه',
      kind: PartyKind.shop,
      createdAt: now,
      updatedAt: now,
    );
    final dashboard = buildHomeDashboard(
      items: [
        money(
          id: 'in-month',
          partyId: shop.id,
          direction: MoneyDirection.pay,
          due: DateTime(2026, 9, 20),
          total: 1000,
        ),
        money(
          id: 'next-month',
          partyId: shop.id,
          direction: MoneyDirection.pay,
          due: DateTime(2026, 10, 5),
          total: 500,
        ),
      ],
      parties: [shop],
      payments: const [],
      now: now,
      calendar: CalendarType.jalali,
    );
    expect(dashboard.dueThisMonth.map((row) => row.id), ['in-month']);
    expect(dashboard.report.remainingPay, 1500);
  });

  test('section collapse defaults follow the spec thresholds', () {
    expect(homeSectionExpandedByDefault(5), isTrue);
    expect(homeSectionExpandedByDefault(6), isFalse);
    expect(homeBalancesCollapsedByDefault(4), isFalse);
    expect(homeBalancesCollapsedByDefault(5), isTrue);
  });

  test('week and month due amounts use current installment not remaining', () {
    final shop = Party(
      id: 'shop',
      name: 'فروشگاه',
      kind: PartyKind.shop,
      createdAt: now,
      updatedAt: now,
    );
    final dashboard = buildHomeDashboard(
      items: [
        money(
          id: 'week-installment',
          partyId: shop.id,
          direction: MoneyDirection.pay,
          due: now.add(const Duration(days: 1)),
          total: 10000000,
          schedule: MoneySchedule.installment,
          installmentCount: 10,
          installmentAmount: 1000000,
        ),
        money(
          id: 'month-installment',
          partyId: shop.id,
          direction: MoneyDirection.receive,
          due: DateTime(2026, 9, 25),
          total: 5000000,
          schedule: MoneySchedule.installment,
          installmentCount: 5,
          installmentAmount: 1000000,
        ),
      ],
      parties: [shop],
      payments: const [],
      now: now,
      calendar: CalendarType.gregorian,
    );

    expect(dashboard.dueThisWeek.single.id, 'week-installment');
    expect(dashboard.dueThisWeek.single.remainingAmount, 10000000);
    expect(dashboard.dueThisWeek.single.suggestedAmount, 1000000);
    expect(dashboard.dueThisMonth.single.id, 'month-installment');
    expect(dashboard.dueThisMonth.single.remainingAmount, 5000000);
    expect(dashboard.dueThisMonth.single.suggestedAmount, 1000000);
    expect(dashboard.report.duePayByPeriodEnd, 1000000);
    expect(dashboard.report.dueReceiveByPeriodEnd, 1000000);
    expect(dashboard.report.remainingPay, 10000000);
    expect(dashboard.report.remainingReceive, 5000000);
  });
}
