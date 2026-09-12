import 'package:feature_money/src/application/money_query.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart';

void main() {
  final now = DateTime(2026, 9, 11);

  MoneyItem item({
    required String id,
    required MoneyDirection direction,
    required int total,
    int paid = 0,
  }) {
    return MoneyItem(
      id: id,
      partyId: 'p',
      direction: direction,
      title: id,
      totalAmount: total,
      paidAmount: paid,
      schedule: MoneySchedule.oneTime,
      startDate: now,
      nextDueDate: now,
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

  group('partyNetBalance', () {
    test('is receivable-minus-payable on remaining amounts', () {
      final items = [
        // They owe me 2000 remaining (3000 total, 1000 received).
        item(
          id: 'r',
          direction: MoneyDirection.receive,
          total: 3000,
          paid: 1000,
        ),
        // I owe them 500 remaining (800 total, 300 paid).
        item(id: 'd', direction: MoneyDirection.pay, total: 800, paid: 300),
      ];
      // 2000 - 500 = 1500 (party owes me).
      expect(partyNetBalance(items), 1500);
    });

    test('is zero when fully settled both ways', () {
      final items = [
        item(id: 'r', direction: MoneyDirection.receive, total: 500, paid: 500),
        item(id: 'd', direction: MoneyDirection.pay, total: 900, paid: 900),
      ];
      expect(partyNetBalance(items), 0);
    });

    test('is negative when I owe more', () {
      final items = [
        item(id: 'd', direction: MoneyDirection.pay, total: 1000),
      ];
      expect(partyNetBalance(items), -1000);
    });
  });

  group('partyLedger', () {
    test('running balance is chronological and reconciles to net', () {
      final receivable =
          item(id: 'r', direction: MoneyDirection.receive, total: 3000, paid: 1000);
      final payable =
          item(id: 'd', direction: MoneyDirection.pay, total: 800, paid: 300);
      final items = [receivable, payable];
      final payments = [
        // Out of order on purpose to prove sorting by paidAt.
        pay(id: 'p2', itemId: 'd', amount: 300, at: DateTime(2026, 2, 1)),
        pay(id: 'p1', itemId: 'r', amount: 1000, at: DateTime(2026, 1, 1)),
      ];

      final ledger = partyLedger(items: items, payments: payments);

      // Start = 3000 (receivable) - 800 (payable) = 2200.
      // p1 (receipt 1000 on receivable): 2200 - 1000 = 1200.
      // p2 (payment 300 on payable): 1200 + 300 = 1500.
      expect(ledger.map((e) => e.payment.id), ['p1', 'p2']);
      expect(ledger[0].balanceAfter, 1200);
      expect(ledger[1].balanceAfter, 1500);
      expect(ledger[0].direction, MoneyDirection.receive);
      expect(ledger[1].direction, MoneyDirection.pay);

      // Final running balance equals the current net position.
      expect(ledger.last.balanceAfter, partyNetBalance(items));
    });

    test('ignores payments for other parties/accounts', () {
      final items = [
        item(id: 'r', direction: MoneyDirection.receive, total: 1000, paid: 400),
      ];
      final payments = [
        pay(id: 'mine', itemId: 'r', amount: 400, at: DateTime(2026, 1, 1)),
        pay(id: 'other', itemId: 'x', amount: 999, at: DateTime(2026, 1, 2)),
      ];

      final ledger = partyLedger(items: items, payments: payments);

      expect(ledger, hasLength(1));
      expect(ledger.single.payment.id, 'mine');
      // Start 1000, receipt 400 -> 600 = net (remaining).
      expect(ledger.single.balanceAfter, 600);
      expect(ledger.single.balanceAfter, partyNetBalance(items));
    });

    test('is empty when there are no payments', () {
      final items = [
        item(id: 'r', direction: MoneyDirection.receive, total: 1000),
      ];
      expect(partyLedger(items: items, payments: const []), isEmpty);
    });
  });
}
