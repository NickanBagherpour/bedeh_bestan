import 'package:core/core.dart' show CalendarType, monthBounds;
import 'package:feature_money/src/application/money_period_report.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart';

void main() {
  final now = DateTime(2026, 9, 11);

  MoneyItem item({
    required String id,
    required String partyId,
    required MoneyDirection direction,
    required DateTime due,
    required int total,
    int paid = 0,
    MoneySchedule schedule = MoneySchedule.oneTime,
    int? installmentCount,
    int? installmentAmount,
    int periodsPaid = 0,
    DateTime? start,
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
      periodsPaid: periodsPaid,
      startDate: start ?? due,
      nextDueDate: due,
      createdAt: now,
      updatedAt: now,
    );
  }

  MoneyPayment pay({
    required String id,
    required String itemId,
    required int amount,
    required DateTime at,
  }) {
    return MoneyPayment(
      id: id,
      moneyItemId: itemId,
      amount: amount,
      paidAt: at,
    );
  }

  Party party(String id, String name) => Party(
        id: id,
        name: name,
        kind: PartyKind.person,
        createdAt: now,
        updatedAt: now,
      );

  AssetAccount asset(int balance) => AssetAccount(
        id: 'a$balance',
        name: 'cash',
        kind: AssetAccountKind.cash,
        balance: balance,
        createdAt: now,
        updatedAt: now,
      );

  test('default range is the current calendar month', () {
    final gregorian = defaultMoneyReportRange(now, CalendarType.gregorian);
    expect(gregorian.start, DateTime(2026, 9, 1));
    expect(gregorian.endInclusive, DateTime(2026, 9, 30));

    final jalali = defaultMoneyReportRange(now, CalendarType.jalali);
    final expected = monthBounds(now, CalendarType.jalali);
    expect(jalali.start, expected.start);
    expect(jalali.endInclusive, expected.endInclusive);
    expect(jalali.containsDate(now), isTrue);
  });

  test('summaries match fixture for gregorian September', () {
    final ali = party('ali', 'Ali');
    final shop = party('shop', 'Shop');
    final openPay = item(
      id: 'open-pay',
      partyId: shop.id,
      direction: MoneyDirection.pay,
      due: DateTime(2026, 9, 20),
      total: 5000,
      paid: 1000,
    );
    final laterPay = item(
      id: 'later-pay',
      partyId: shop.id,
      direction: MoneyDirection.pay,
      due: DateTime(2026, 10, 5),
      total: 2000,
    );
    final receive = item(
      id: 'receive',
      partyId: ali.id,
      direction: MoneyDirection.receive,
      due: DateTime(2026, 9, 15),
      total: 800,
    );
    final installment = item(
      id: 'inst',
      partyId: ali.id,
      direction: MoneyDirection.pay,
      due: DateTime(2026, 9, 5),
      total: 3000,
      paid: 1000,
      schedule: MoneySchedule.installment,
      installmentCount: 3,
      installmentAmount: 1000,
      periodsPaid: 1,
      start: DateTime(2026, 8, 5),
    );

    final report = buildMoneyPeriodReport(
      items: [openPay, laterPay, receive, installment],
      payments: [
        pay(id: 'p1', itemId: openPay.id, amount: 1000, at: DateTime(2026, 9, 2)),
        pay(id: 'p2', itemId: receive.id, amount: 300, at: DateTime(2026, 9, 8)),
        pay(id: 'p3', itemId: openPay.id, amount: 50, at: DateTime(2026, 8, 30)),
        // Boundary: last day of range inclusive.
        pay(id: 'p4', itemId: installment.id, amount: 1000, at: DateTime(2026, 9, 30)),
      ],
      parties: [ali, shop],
      assets: [asset(10000), asset(2500)],
      rangeStart: DateTime(2026, 9, 1),
      rangeEnd: DateTime(2026, 9, 30),
      now: now,
    );

    // Due in September: open-pay 4000, receive 800, installment قسط 1000.
    expect(report.duePayInPeriod, 5000);
    expect(report.dueReceiveInPeriod, 800);
    // Settled in September: 1000 + 300 + 1000 (p3 is August).
    expect(report.settledPayInPeriod, 2000);
    expect(report.settledReceiveInPeriod, 300);
    // Open remaining across all (laterPay included): 4000+2000+2000 pay, 800 receive.
    expect(report.openPayRemaining, 8000);
    expect(report.openReceiveRemaining, 800);
    expect(report.assetsTotal, 12500);
    expect(report.approxNetWorth, 12500 - 8000 + 800);
    expect(report.itemsInPeriod.map((r) => r.id), ['inst', 'receive', 'open-pay']);
    expect(report.paymentsInPeriod.map((r) => r.id), ['p1', 'p2', 'p4']);
    expect(report.partyBalances, hasLength(2));
    expect(report.partyBalances.first.partyId, shop.id);
  });

  test('party and direction filters scope items and payments', () {
    final ali = party('ali', 'Ali');
    final shop = party('shop', 'Shop');
    final payItem = item(
      id: 'pay',
      partyId: shop.id,
      direction: MoneyDirection.pay,
      due: DateTime(2026, 9, 10),
      total: 1000,
    );
    final receiveItem = item(
      id: 'recv',
      partyId: ali.id,
      direction: MoneyDirection.receive,
      due: DateTime(2026, 9, 12),
      total: 500,
    );

    final report = buildMoneyPeriodReport(
      items: [payItem, receiveItem],
      payments: [
        pay(id: 'p1', itemId: payItem.id, amount: 200, at: DateTime(2026, 9, 3)),
        pay(id: 'p2', itemId: receiveItem.id, amount: 100, at: DateTime(2026, 9, 4)),
      ],
      parties: [ali, shop],
      assets: const [],
      rangeStart: DateTime(2026, 9, 1),
      rangeEnd: DateTime(2026, 9, 30),
      now: now,
      partyId: ali.id,
      direction: MoneyReportDirectionFilter.receive,
    );

    expect(report.duePayInPeriod, 0);
    expect(report.dueReceiveInPeriod, 500);
    expect(report.settledPayInPeriod, 0);
    expect(report.settledReceiveInPeriod, 100);
    expect(report.openPayRemaining, 0);
    expect(report.openReceiveRemaining, 500);
    expect(report.itemsInPeriod, hasLength(1));
    expect(report.paymentsInPeriod.single.id, 'p2');
    expect(report.partyBalances.single.partyId, ali.id);
  });

  test('Jalali month edges include boundary dues and payments', () {
    final range = defaultMoneyReportRange(now, CalendarType.jalali);
    final ali = party('ali', 'Ali');
    final onStart = item(
      id: 'start',
      partyId: ali.id,
      direction: MoneyDirection.receive,
      due: range.start,
      total: 100,
    );
    final onEnd = item(
      id: 'end',
      partyId: ali.id,
      direction: MoneyDirection.pay,
      due: range.endInclusive,
      total: 200,
    );
    final outside = item(
      id: 'out',
      partyId: ali.id,
      direction: MoneyDirection.pay,
      due: range.endInclusive.add(const Duration(days: 1)),
      total: 50,
    );

    final report = buildMoneyPeriodReport(
      items: [onStart, onEnd, outside],
      payments: [
        pay(id: 'ps', itemId: onStart.id, amount: 10, at: range.start),
        pay(id: 'pe', itemId: onEnd.id, amount: 20, at: range.endInclusive),
        pay(
          id: 'po',
          itemId: outside.id,
          amount: 5,
          at: range.endInclusive.add(const Duration(days: 1)),
        ),
      ],
      parties: [ali],
      assets: const [],
      rangeStart: range.start,
      rangeEnd: range.endInclusive,
      now: now,
    );

    expect(report.dueReceiveInPeriod, 100);
    expect(report.duePayInPeriod, 200);
    expect(report.settledReceiveInPeriod, 10);
    expect(report.settledPayInPeriod, 20);
    expect(report.itemsInPeriod.map((r) => r.id), ['start', 'end']);
    expect(report.paymentsInPeriod.map((r) => r.id), ['ps', 'pe']);
  });
}
