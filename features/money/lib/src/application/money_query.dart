import 'package:local_db/local_db.dart'
    show MoneyDirection, MoneyItem, MoneyPayment, MoneySchedule, MoneyStatus;

enum MoneyListFilter { all, pay, receive }

/// +1 for طلب (receivable, they owe me), -1 for بدهی (I owe them).
///
/// Used so a party's balance is a single signed number: positive means the
/// party owes me, negative means I owe the party.
int directionSign(MoneyDirection direction) =>
    direction == MoneyDirection.receive ? 1 : -1;

/// Net position for a party across [items], in stored Toman.
///
/// Sum of outstanding طلب minus outstanding بدهی. Positive → the party owes me,
/// negative → I owe the party, zero → settled. Pure; unit-tested.
int partyNetBalance(Iterable<MoneyItem> items) {
  var net = 0;
  for (final item in items) {
    net += directionSign(item.direction) * item.remainingAmount;
  }
  return net;
}

/// One chronological row of a party's running-balance ledger.
final class PartyLedgerEntry {
  const PartyLedgerEntry({
    required this.payment,
    required this.direction,
    required this.balanceAfter,
  });

  /// The payment / receipt this row represents.
  final MoneyPayment payment;

  /// Direction of the account the payment belongs to (drives its color).
  final MoneyDirection direction;

  /// Signed net position (stored Toman) right after this entry, using the same
  /// sign convention as [partyNetBalance]. The last entry equals the current
  /// [partyNetBalance] of the same accounts.
  final int balanceAfter;
}

/// Chronological running-balance ledger for a party.
///
/// Only payments belonging to one of [items] are included, sorted by `paidAt`
/// (ties broken by id for stability). The balance starts from the accounts'
/// original totals and each payment moves it toward the current net, so the
/// final entry equals [partyNetBalance]. Pure; unit-tested.
List<PartyLedgerEntry> partyLedger({
  required List<MoneyItem> items,
  required List<MoneyPayment> payments,
}) {
  final byItem = {for (final item in items) item.id: item};
  final relevant = [
    for (final payment in payments)
      if (byItem.containsKey(payment.moneyItemId)) payment,
  ]..sort((a, b) {
      final byDate = a.paidAt.compareTo(b.paidAt);
      return byDate != 0 ? byDate : a.id.compareTo(b.id);
    });

  var running = 0;
  for (final item in items) {
    running += directionSign(item.direction) * item.totalAmount;
  }

  final entries = <PartyLedgerEntry>[];
  for (final payment in relevant) {
    final item = byItem[payment.moneyItemId]!;
    // A payment reduces the outstanding on its account, moving the party's net
    // toward zero from whichever side that account sits on.
    running -= directionSign(item.direction) * payment.amount;
    entries.add(
      PartyLedgerEntry(
        payment: payment,
        direction: item.direction,
        balanceAfter: running,
      ),
    );
  }
  return entries;
}

/// Suggested payment prefill (stored Toman) for an installment item.
///
/// Returns the per-installment amount, capped at the remaining balance so the
/// final قسط never over-fills. `null` for one-time items, settled items, or
/// installment items without a stored installment amount (no forced prefill).
int? installmentPrefillAmount(MoneyItem item) {
  if (item.schedule != MoneySchedule.installment) return null;
  if (item.isSettled) return null;
  final each = item.installmentAmount;
  if (each == null || each <= 0) return null;
  final remaining = item.remainingAmount;
  return each < remaining ? each : remaining;
}

int moneyStatusRank(MoneyStatus status) {
  return switch (status) {
    MoneyStatus.overdue => 0,
    MoneyStatus.dueToday => 1,
    MoneyStatus.upcoming => 2,
    MoneyStatus.settled => 3,
  };
}

List<MoneyItem> visibleMoneyItems({
  required List<MoneyItem> items,
  required MoneyListFilter filter,
  required bool hideSettled,
  required DateTime now,
}) {
  final filtered = items.where((item) {
    if (hideSettled && item.isSettled) return false;
    return switch (filter) {
      MoneyListFilter.all => true,
      MoneyListFilter.pay => item.direction == MoneyDirection.pay,
      MoneyListFilter.receive => item.direction == MoneyDirection.receive,
    };
  }).toList();
  filtered.sort((a, b) {
    final rank = moneyStatusRank(a.statusOn(now)).compareTo(
      moneyStatusRank(b.statusOn(now)),
    );
    if (rank != 0) return rank;
    return a.nextDueDate.compareTo(b.nextDueDate);
  });
  return filtered;
}
