import 'package:core/core.dart' show CalendarType, DateRange, dateOnly, monthBounds;
import 'package:local_db/local_db.dart'
    show AssetAccount, MoneyDirection, MoneyItem, MoneyPayment, MoneyStatus, Party;

/// Direction filter for the period report hub.
enum MoneyReportDirectionFilter { all, pay, receive }

/// One money item with a due date inside the selected range.
final class MoneyReportItemRow {
  const MoneyReportItemRow({
    required this.id,
    required this.title,
    required this.partyId,
    required this.partyName,
    required this.direction,
    required this.dueDate,
    required this.suggestedAmount,
    required this.remainingAmount,
    required this.status,
  });

  final String id;
  final String title;
  final String partyId;
  final String partyName;
  final MoneyDirection direction;
  final DateTime dueDate;
  final int suggestedAmount;
  final int remainingAmount;
  final MoneyStatus status;
}

/// Open pay/receive remaining aggregated for one party.
final class MoneyReportPartyRow {
  const MoneyReportPartyRow({
    required this.partyId,
    required this.partyName,
    required this.payRemaining,
    required this.receiveRemaining,
  });

  final String partyId;
  final String partyName;
  final int payRemaining;
  final int receiveRemaining;

  int get absMax =>
      payRemaining > receiveRemaining ? payRemaining : receiveRemaining;
}

/// One payment that falls inside the selected range.
final class MoneyReportPaymentRow {
  const MoneyReportPaymentRow({
    required this.id,
    required this.moneyItemId,
    required this.itemTitle,
    required this.partyId,
    required this.partyName,
    required this.direction,
    required this.amount,
    required this.paidAt,
  });

  final String id;
  final String moneyItemId;
  final String itemTitle;
  final String partyId;
  final String partyName;
  final MoneyDirection direction;
  final int amount;
  final DateTime paidAt;
}

/// Filtered period overview derived from existing money + asset rows.
final class MoneyPeriodReport {
  const MoneyPeriodReport({
    required this.rangeStart,
    required this.rangeEnd,
    required this.duePayInPeriod,
    required this.dueReceiveInPeriod,
    required this.settledPayInPeriod,
    required this.settledReceiveInPeriod,
    required this.openPayRemaining,
    required this.openReceiveRemaining,
    required this.assetsTotal,
    required this.approxNetWorth,
    required this.itemsInPeriod,
    required this.partyBalances,
    required this.paymentsInPeriod,
  });

  final DateTime rangeStart;
  final DateTime rangeEnd;

  /// Suggested dues still open whose [MoneyItem.nextDueDate] falls in range.
  final int duePayInPeriod;
  final int dueReceiveInPeriod;

  /// Sum of [MoneyPayment.amount] with [MoneyPayment.paidAt] in range.
  final int settledPayInPeriod;
  final int settledReceiveInPeriod;

  /// All open remaining (not limited to the period), after party/direction filters.
  final int openPayRemaining;
  final int openReceiveRemaining;

  /// Sum of manual [AssetAccount.balance] values.
  final int assetsTotal;

  /// Approximate net worth: assets − open pay + open receive.
  final int approxNetWorth;

  final List<MoneyReportItemRow> itemsInPeriod;
  final List<MoneyReportPartyRow> partyBalances;
  final List<MoneyReportPaymentRow> paymentsInPeriod;
}

/// Default range for the report hub: the current calendar month.
DateRange defaultMoneyReportRange(DateTime now, CalendarType calendar) =>
    monthBounds(now, calendar);

bool _matchesDirection(MoneyItem item, MoneyReportDirectionFilter filter) {
  return switch (filter) {
    MoneyReportDirectionFilter.all => true,
    MoneyReportDirectionFilter.pay => item.direction == MoneyDirection.pay,
    MoneyReportDirectionFilter.receive =>
      item.direction == MoneyDirection.receive,
  };
}

bool _inInclusiveRange(DateTime value, DateTime start, DateTime end) {
  final day = dateOnly(value);
  return !day.isBefore(dateOnly(start)) && !day.isAfter(dateOnly(end));
}

/// Builds a [MoneyPeriodReport] from in-memory fixtures. Pure; unit-tested.
///
/// [rangeStart]/[rangeEnd] are inclusive calendar days. Party / direction
/// filters apply to items and to payments that belong to those items. Assets
/// are always global (not party-scoped).
MoneyPeriodReport buildMoneyPeriodReport({
  required List<MoneyItem> items,
  required List<MoneyPayment> payments,
  required List<Party> parties,
  required List<AssetAccount> assets,
  required DateTime rangeStart,
  required DateTime rangeEnd,
  required DateTime now,
  String? partyId,
  MoneyReportDirectionFilter direction = MoneyReportDirectionFilter.all,
}) {
  final start = dateOnly(rangeStart);
  final end = dateOnly(rangeEnd);
  final names = {for (final party in parties) party.id: party.name};
  final scopedItems = [
    for (final item in items)
      if ((partyId == null || item.partyId == partyId) &&
          _matchesDirection(item, direction))
        item,
  ];
  final byId = {for (final item in scopedItems) item.id: item};

  var duePay = 0;
  var dueReceive = 0;
  var openPay = 0;
  var openReceive = 0;
  final itemRows = <MoneyReportItemRow>[];

  for (final item in scopedItems) {
    if (item.isSettled) continue;

    if (item.direction == MoneyDirection.pay) {
      openPay += item.remainingAmount;
    } else {
      openReceive += item.remainingAmount;
    }

    if (!_inInclusiveRange(item.nextDueDate, start, end)) continue;

    final suggested =
        item.suggestedQuickPaymentAmount() ?? item.remainingAmount;
    if (item.direction == MoneyDirection.pay) {
      duePay += suggested;
    } else {
      dueReceive += suggested;
    }
    itemRows.add(
      MoneyReportItemRow(
        id: item.id,
        title: item.title,
        partyId: item.partyId,
        partyName: names[item.partyId] ?? item.partyId,
        direction: item.direction,
        dueDate: item.nextDueDate,
        suggestedAmount: suggested,
        remainingAmount: item.remainingAmount,
        status: item.statusOn(now),
      ),
    );
  }
  itemRows.sort((a, b) => a.dueDate.compareTo(b.dueDate));

  var settledPay = 0;
  var settledReceive = 0;
  final paymentRows = <MoneyReportPaymentRow>[];
  for (final payment in payments) {
    final item = byId[payment.moneyItemId];
    if (item == null) continue;
    if (!_inInclusiveRange(payment.paidAt, start, end)) continue;
    if (item.direction == MoneyDirection.pay) {
      settledPay += payment.amount;
    } else {
      settledReceive += payment.amount;
    }
    paymentRows.add(
      MoneyReportPaymentRow(
        id: payment.id,
        moneyItemId: item.id,
        itemTitle: item.title,
        partyId: item.partyId,
        partyName: names[item.partyId] ?? item.partyId,
        direction: item.direction,
        amount: payment.amount,
        paidAt: payment.paidAt,
      ),
    );
  }
  paymentRows.sort((a, b) {
    final byDate = a.paidAt.compareTo(b.paidAt);
    return byDate != 0 ? byDate : a.id.compareTo(b.id);
  });

  final payByParty = <String, int>{};
  final receiveByParty = <String, int>{};
  for (final item in scopedItems) {
    if (item.isSettled) continue;
    if (item.direction == MoneyDirection.pay) {
      payByParty[item.partyId] =
          (payByParty[item.partyId] ?? 0) + item.remainingAmount;
    } else {
      receiveByParty[item.partyId] =
          (receiveByParty[item.partyId] ?? 0) + item.remainingAmount;
    }
  }

  final partyBalances = <MoneyReportPartyRow>[];
  for (final party in parties) {
    if (partyId != null && party.id != partyId) continue;
    final owe = payByParty[party.id] ?? 0;
    final owed = receiveByParty[party.id] ?? 0;
    if (owe == 0 && owed == 0) continue;
    partyBalances.add(
      MoneyReportPartyRow(
        partyId: party.id,
        partyName: party.name,
        payRemaining: owe,
        receiveRemaining: owed,
      ),
    );
  }
  partyBalances.sort((a, b) => b.absMax.compareTo(a.absMax));

  var assetsTotal = 0;
  for (final asset in assets) {
    assetsTotal += asset.balance;
  }

  return MoneyPeriodReport(
    rangeStart: start,
    rangeEnd: end,
    duePayInPeriod: duePay,
    dueReceiveInPeriod: dueReceive,
    settledPayInPeriod: settledPay,
    settledReceiveInPeriod: settledReceive,
    openPayRemaining: openPay,
    openReceiveRemaining: openReceive,
    assetsTotal: assetsTotal,
    approxNetWorth: assetsTotal - openPay + openReceive,
    itemsInPeriod: itemRows,
    partyBalances: partyBalances,
    paymentsInPeriod: paymentRows,
  );
}
