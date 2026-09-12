import 'package:local_db/local_db.dart'
    show MoneyDirection, MoneyItem, MoneySchedule, MoneyStatus;

enum MoneyListFilter { all, pay, receive }

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
