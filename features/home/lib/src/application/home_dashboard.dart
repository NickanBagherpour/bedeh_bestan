import 'package:core/core.dart' show CalendarType, dateOnly, monthBounds;
import 'package:local_db/local_db.dart'
    show MoneyDirection, MoneyItem, MoneyPayment, MoneyStatus, Party;

final class HomeDueRow {
  const HomeDueRow({
    required this.id,
    required this.title,
    required this.partyName,
    required this.direction,
    required this.remainingAmount,
    required this.dueDate,
    required this.status,
  });

  final String id;
  final String title;
  final String partyName;
  final MoneyDirection direction;
  final int remainingAmount;
  final DateTime dueDate;
  final MoneyStatus status;
}

final class HomePartyBalance {
  const HomePartyBalance({
    required this.partyId,
    required this.partyName,
    required this.payRemaining,
    required this.receiveRemaining,
  });

  final String partyId;
  final String partyName;
  final int payRemaining;
  final int receiveRemaining;
}

final class HomePeriodReport {
  const HomePeriodReport({
    required this.paidOut,
    required this.paidIn,
    required this.remainingPay,
    required this.remainingReceive,
    required this.duePayByPeriodEnd,
    required this.dueReceiveByPeriodEnd,
    required this.periodStart,
    required this.periodEnd,
  });

  final int paidOut;
  final int paidIn;
  final int remainingPay;
  final int remainingReceive;
  final int duePayByPeriodEnd;
  final int dueReceiveByPeriodEnd;
  final DateTime periodStart;
  final DateTime periodEnd;
}

final class HomeDashboard {
  const HomeDashboard({
    required this.dueThisWeek,
    required this.dueThisMonth,
    required this.overdue,
    required this.balances,
    required this.report,
  });

  final List<HomeDueRow> dueThisWeek;
  final List<HomeDueRow> dueThisMonth;
  final List<HomeDueRow> overdue;
  final List<HomePartyBalance> balances;
  final HomePeriodReport report;
}

bool isDueThisWeek(DateTime due, DateTime now) {
  final today = dateOnly(now);
  final end = today.add(const Duration(days: 6));
  final day = dateOnly(due);
  return !day.isBefore(today) && !day.isAfter(end);
}

bool isDueInMonth(DateTime due, DateTime monthStart, DateTime monthEnd) {
  final day = dateOnly(due);
  return !day.isBefore(monthStart) && !day.isAfter(monthEnd);
}

HomePeriodReport buildHomePeriodReport({
  required List<MoneyItem> items,
  required List<MoneyPayment> payments,
  required DateTime now,
  required CalendarType calendar,
}) {
  final month = monthBounds(now, calendar);
  final today = dateOnly(now);
  final byId = {for (final item in items) item.id: item};

  var paidOut = 0;
  var paidIn = 0;
  for (final payment in payments) {
    final paidDay = dateOnly(payment.paidAt);
    if (paidDay.isBefore(month.start) || paidDay.isAfter(today)) continue;
    final item = byId[payment.moneyItemId];
    if (item == null) continue;
    if (item.direction == MoneyDirection.pay) {
      paidOut += payment.amount;
    } else {
      paidIn += payment.amount;
    }
  }

  var remainingPay = 0;
  var remainingReceive = 0;
  var duePayByPeriodEnd = 0;
  var dueReceiveByPeriodEnd = 0;
  for (final item in items) {
    if (item.isSettled) continue;
    final due = dateOnly(item.nextDueDate);
    final inMonth =
        !due.isBefore(today) && !due.isAfter(month.endInclusive);
    if (item.direction == MoneyDirection.pay) {
      remainingPay += item.remainingAmount;
      if (inMonth) duePayByPeriodEnd += item.remainingAmount;
    } else {
      remainingReceive += item.remainingAmount;
      if (inMonth) dueReceiveByPeriodEnd += item.remainingAmount;
    }
  }

  return HomePeriodReport(
    paidOut: paidOut,
    paidIn: paidIn,
    remainingPay: remainingPay,
    remainingReceive: remainingReceive,
    duePayByPeriodEnd: duePayByPeriodEnd,
    dueReceiveByPeriodEnd: dueReceiveByPeriodEnd,
    periodStart: month.start,
    periodEnd: month.endInclusive,
  );
}

HomeDashboard buildHomeDashboard({
  required List<MoneyItem> items,
  required List<Party> parties,
  required List<MoneyPayment> payments,
  required DateTime now,
  required CalendarType calendar,
}) {
  final names = {for (final party in parties) party.id: party.name};
  final month = monthBounds(now, calendar);
  HomeDueRow rowFor(MoneyItem item) {
    return HomeDueRow(
      id: item.id,
      title: item.title,
      partyName: names[item.partyId] ?? item.partyId,
      direction: item.direction,
      remainingAmount: item.remainingAmount,
      dueDate: item.nextDueDate,
      status: item.statusOn(now),
    );
  }

  final overdue = items
      .where((item) => item.statusOn(now) == MoneyStatus.overdue)
      .map(rowFor)
      .toList()
    ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

  final dueThisWeek = items
      .where(
        (item) =>
            !item.isSettled &&
            item.statusOn(now) != MoneyStatus.overdue &&
            isDueThisWeek(item.nextDueDate, now),
      )
      .map(rowFor)
      .toList()
    ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

  final dueThisMonth = items
      .where(
        (item) =>
            !item.isSettled &&
            item.statusOn(now) != MoneyStatus.overdue &&
            !isDueThisWeek(item.nextDueDate, now) &&
            isDueInMonth(item.nextDueDate, month.start, month.endInclusive),
      )
      .map(rowFor)
      .toList()
    ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

  final pay = <String, int>{};
  final receive = <String, int>{};
  for (final item in items) {
    if (item.isSettled) continue;
    if (item.direction == MoneyDirection.pay) {
      pay[item.partyId] = (pay[item.partyId] ?? 0) + item.remainingAmount;
    } else {
      receive[item.partyId] =
          (receive[item.partyId] ?? 0) + item.remainingAmount;
    }
  }

  final balances = <HomePartyBalance>[];
  for (final party in parties) {
    final owe = pay[party.id] ?? 0;
    final owed = receive[party.id] ?? 0;
    if (owe == 0 && owed == 0) continue;
    balances.add(
      HomePartyBalance(
        partyId: party.id,
        partyName: party.name,
        payRemaining: owe,
        receiveRemaining: owed,
      ),
    );
  }
  balances.sort((a, b) {
    final maxA = a.payRemaining > a.receiveRemaining
        ? a.payRemaining
        : a.receiveRemaining;
    final maxB = b.payRemaining > b.receiveRemaining
        ? b.payRemaining
        : b.receiveRemaining;
    return maxB.compareTo(maxA);
  });

  return HomeDashboard(
    dueThisWeek: dueThisWeek,
    dueThisMonth: dueThisMonth,
    overdue: overdue,
    balances: balances,
    report: buildHomePeriodReport(
      items: items,
      payments: payments,
      now: now,
      calendar: calendar,
    ),
  );
}

/// Default expanded when row count is at or below this threshold.
bool homeSectionExpandedByDefault(int rowCount, {int threshold = 5}) {
  return rowCount <= threshold;
}

bool homeBalancesCollapsedByDefault(int count) => count > 4;
