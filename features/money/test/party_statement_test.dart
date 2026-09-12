import 'package:feature_money/src/application/money_query.dart';
import 'package:feature_money/src/application/party_statement.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart';

void main() {
  final now = DateTime(2026, 9, 11);

  MoneyItem item({
    required String id,
    required String title,
    required MoneyDirection direction,
    required int total,
    int paid = 0,
  }) {
    return MoneyItem(
      id: id,
      partyId: 'p',
      direction: direction,
      title: title,
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
    return MoneyPayment(id: id, moneyItemId: itemId, amount: amount, paidAt: at);
  }

  const labels = PartyStatementLabels(
    netBalance: 'Net balance',
    accounts: 'Accounts',
    transactions: 'Transactions',
    balance: 'Balance',
    noAccounts: 'No accounts yet.',
    noTransactions: 'No transactions yet.',
    directionPay: 'I owe',
    directionReceive: 'Owed to me',
    owedToMe: 'Owed to me',
    iOwe: 'I owe',
    settled: 'Settled',
  );

  String money(int v) => '$v T';
  String date(DateTime d) => '${d.year}-${d.month}-${d.day}';

  String build(List<MoneyItem> items, List<MoneyPayment> payments) {
    return buildPartyStatement(
      partyName: 'Ali',
      kindLabel: 'Person',
      items: items,
      ledger: partyLedger(items: items, payments: payments),
      labels: labels,
      fmtMoney: money,
      fmtDate: date,
    );
  }

  test('renders header, accounts and ledger with the right sign', () {
    final receivable = item(
      id: 'r',
      title: 'Loan',
      direction: MoneyDirection.receive,
      total: 3000,
      paid: 1000,
    );
    final payable = item(
      id: 'd',
      title: 'Rent',
      direction: MoneyDirection.pay,
      total: 800,
      paid: 300,
    );
    final text = build(
      [receivable, payable],
      [pay(id: 'p1', itemId: 'r', amount: 1000, at: DateTime(2026, 1, 1))],
    );

    // Header: name · kind and the net (2000 receivable - 500 payable = 1500).
    expect(text, contains('Ali · Person'));
    expect(text, contains('Net balance: 1500 T (Owed to me)'));
    // Account lines use the remaining amount and direction label.
    expect(text, contains('• Loan — Owed to me: 2000 T'));
    expect(text, contains('• Rent — I owe: 500 T'));
    // Ledger line uses the absolute balance-after.
    expect(text, contains('• 2026-1-1 — Owed to me 1000 T (Balance: 1200 T)'));
  });

  test('shows empty placeholders when there is nothing', () {
    final text = build(const [], const []);
    expect(text, contains('Net balance: 0 T (Settled)'));
    expect(text, contains('No accounts yet.'));
    expect(text, contains('No transactions yet.'));
  });
}
