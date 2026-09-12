import 'package:local_db/local_db.dart' show MoneyDirection, MoneyItem;

import 'money_query.dart';

/// Localized, pre-formatted labels for a shareable party statement.
///
/// Kept as plain strings so [buildPartyStatement] stays pure and unit-testable
/// without a `BuildContext` / slang. The page fills these from `t.money.*`.
final class PartyStatementLabels {
  const PartyStatementLabels({
    required this.netBalance,
    required this.accounts,
    required this.transactions,
    required this.balance,
    required this.noAccounts,
    required this.noTransactions,
    required this.directionPay,
    required this.directionReceive,
    required this.owedToMe,
    required this.iOwe,
    required this.settled,
  });

  final String netBalance;
  final String accounts;
  final String transactions;
  final String balance;
  final String noAccounts;
  final String noTransactions;
  final String directionPay;
  final String directionReceive;
  final String owedToMe;
  final String iOwe;
  final String settled;

  String directionLabel(MoneyDirection direction) =>
      direction == MoneyDirection.pay ? directionPay : directionReceive;

  /// طلب (positive) / بدهی (negative) / تسویه (zero) for a signed net.
  String stateLabel(int net) {
    if (net > 0) return owedToMe;
    if (net < 0) return iOwe;
    return settled;
  }
}

/// Builds a human-readable statement for a party, ready for the OS share sheet.
///
/// Header (name · kind, net balance), the per-account lines, and the running
/// ledger. All amounts/dates arrive pre-formatted via [fmtMoney] / [fmtDate]
/// so the caller controls currency, calendar, locale and Persian digits. Pure;
/// unit-tested.
String buildPartyStatement({
  required String partyName,
  required String kindLabel,
  required List<MoneyItem> items,
  required List<PartyLedgerEntry> ledger,
  required PartyStatementLabels labels,
  required String Function(int storedToman) fmtMoney,
  required String Function(DateTime date) fmtDate,
}) {
  final net = partyNetBalance(items);
  final lines = <String>[
    '$partyName · $kindLabel',
    '${labels.netBalance}: ${fmtMoney(net.abs())} (${labels.stateLabel(net)})',
    '',
    '${labels.accounts}:',
  ];

  if (items.isEmpty) {
    lines.add(labels.noAccounts);
  } else {
    for (final item in items) {
      lines.add(
        '• ${item.title} — '
        '${labels.directionLabel(item.direction)}: '
        '${fmtMoney(item.remainingAmount)}',
      );
    }
  }

  lines
    ..add('')
    ..add('${labels.transactions}:');

  if (ledger.isEmpty) {
    lines.add(labels.noTransactions);
  } else {
    for (final entry in ledger) {
      lines.add(
        '• ${fmtDate(entry.payment.paidAt)} — '
        '${labels.directionLabel(entry.direction)} '
        '${fmtMoney(entry.payment.amount)} '
        '(${labels.balance}: ${fmtMoney(entry.balanceAfter.abs())})',
      );
    }
  }

  return lines.join('\n');
}
