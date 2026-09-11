import 'package:local_db/local_db.dart' show MoneyDirection, MoneyItem, MoneyStatus;

enum MoneyListFilter { all, pay, receive }

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
