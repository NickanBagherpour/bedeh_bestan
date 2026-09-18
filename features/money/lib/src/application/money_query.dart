import 'package:core/core.dart' show CalendarType, shiftCalendarMonths;
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
/// Uses the current unpaid قسط amount when stored rows exist; otherwise the
/// uniform [MoneyItem.installmentAmount]. Capped at remaining. `null` for
/// one-time / settled items or when no amount can be derived.
int? installmentPrefillAmount(MoneyItem item) {
  if (item.schedule != MoneySchedule.installment) return null;
  if (item.isSettled) return null;
  final each = item.installments.isNotEmpty
      ? item.currentInstallmentAmount()
      : item.installmentAmount;
  if (each == null || each <= 0) return null;
  final remaining = item.remainingAmount;
  return each < remaining ? each : remaining;
}

/// State of one installment row relative to progress.
enum InstallmentState { paid, due, upcoming }

/// One row of an installment (قسطی) schedule.
final class InstallmentRow {
  const InstallmentRow({
    required this.index,
    required this.dueDate,
    required this.amount,
    required this.state,
  });

  /// 1-based قسط number.
  final int index;

  /// Due date of this قسط in the active calendar.
  final DateTime dueDate;

  /// Amount for this قسط, stored Toman.
  final int amount;

  final InstallmentState state;
}

/// Editable draft row while creating / editing a قسطی account.
final class InstallmentDraftRow {
  const InstallmentDraftRow({
    required this.index,
    required this.dueDate,
    required this.amount,
    this.id,
  });

  final String? id;
  final int index;
  final DateTime dueDate;
  final int amount;

  InstallmentDraftRow copyWith({
    String? id,
    int? index,
    DateTime? dueDate,
    int? amount,
  }) {
    return InstallmentDraftRow(
      id: id ?? this.id,
      index: index ?? this.index,
      dueDate: dueDate ?? this.dueDate,
      amount: amount ?? this.amount,
    );
  }
}

/// Equal monthly draft schedule from count / default amount / first due.
///
/// Pure; used by the money form before save. Unit-tested.
List<InstallmentDraftRow> buildEqualInstallmentDraft({
  required int count,
  required int amount,
  required DateTime startDate,
  required CalendarType calendar,
  List<InstallmentDraftRow>? previous,
}) {
  if (count <= 0 || amount <= 0) return const [];
  return [
    for (var i = 0; i < count; i++)
      InstallmentDraftRow(
        id: previous != null && i < previous.length ? previous[i].id : null,
        index: i + 1,
        dueDate: shiftCalendarMonths(startDate, i, calendar),
        amount: amount,
      ),
  ];
}

/// Sum of draft قسط amounts (stored Toman).
int installmentDraftTotal(Iterable<InstallmentDraftRow> rows) {
  var sum = 0;
  for (final row in rows) {
    sum += row.amount;
  }
  return sum;
}

/// Per-قسط schedule for an installment [item] in [calendar].
///
/// When [MoneyItem.installments] is non-empty, uses stored amounts and due
/// dates. Otherwise generates equal monthly rows from count /
/// [MoneyItem.installmentAmount] (or total/count). The first [periodsPaid]
/// rows are [InstallmentState.paid], the next unpaid one is
/// [InstallmentState.due], and the rest are [InstallmentState.upcoming].
/// Empty for non-installment items or when the count is missing. Pure;
/// unit-tested.
List<InstallmentRow> installmentSchedule(MoneyItem item, CalendarType calendar) {
  if (item.schedule != MoneySchedule.installment) return const [];

  if (item.installments.isNotEmpty) {
    final sorted = [...item.installments]
      ..sort((a, b) => a.index.compareTo(b.index));
    return [
      for (var i = 0; i < sorted.length; i++)
        InstallmentRow(
          index: sorted[i].index,
          dueDate: sorted[i].dueDate,
          amount: sorted[i].amount,
          state: i < item.periodsPaid
              ? InstallmentState.paid
              : (i == item.periodsPaid
                    ? InstallmentState.due
                    : InstallmentState.upcoming),
        ),
    ];
  }

  final count = item.installmentCount;
  if (count == null || count <= 0) return const [];
  final each = item.installmentAmount ?? (item.totalAmount / count).round();
  final rows = <InstallmentRow>[];
  for (var i = 0; i < count; i++) {
    final state = i < item.periodsPaid
        ? InstallmentState.paid
        : (i == item.periodsPaid
              ? InstallmentState.due
              : InstallmentState.upcoming);
    rows.add(
      InstallmentRow(
        index: i + 1,
        dueDate: shiftCalendarMonths(item.startDate, i, calendar),
        amount: each,
        state: state,
      ),
    );
  }
  return rows;
}

/// Collapse the schedule UI when there are more than this many قسط rows.
const installmentScheduleCollapseThreshold = 5;

/// Rows to render in the installment schedule list.
///
/// When [expanded] is false and there are more than
/// [installmentScheduleCollapseThreshold] rows, paid قسط‌ها are omitted (the
/// UI shows a count summary) and at most the next 5 unpaid rows (due +
/// upcoming) are returned. Smaller schedules and the expanded view return
/// every row. Pure; unit-tested.
List<InstallmentRow> visibleInstallmentRows(
  List<InstallmentRow> rows, {
  required bool expanded,
}) {
  if (expanded || rows.length <= installmentScheduleCollapseThreshold) {
    return rows;
  }
  final unpaid = <InstallmentRow>[];
  for (final row in rows) {
    if (row.state == InstallmentState.paid) continue;
    unpaid.add(row);
    if (unpaid.length == installmentScheduleCollapseThreshold) break;
  }
  return unpaid;
}

/// Amount to record when settling one schedule row (stored Toman).
///
/// One full قسط, capped at remaining so a last odd قسط never overpays.
int installmentRowSettleAmount(InstallmentRow row, int remainingAmount) {
  if (remainingAmount <= 0) return 0;
  return row.amount < remainingAmount ? row.amount : remainingAmount;
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
