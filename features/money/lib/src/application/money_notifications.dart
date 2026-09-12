import 'package:core/core.dart'
    show AppRoutes, ScheduledNotice, notificationId;
import 'package:local_db/local_db.dart' show MoneyItem;

/// Due-date notices for unsettled money items within [horizon].
///
/// Each unsettled item whose سررسید is still ahead gets a notice on the due
/// date at 09:00 and, when [dayBefore] is on, one the previous morning. Settled
/// items and past due dates are skipped so a paid بدهی/قسط never buzzes. Tapping
/// opens the money item via [AppRoutes.moneyItemPath]. Pure; unit-tested.
///
/// Reminders carry no reference to a money item, so cross-source dedup is not
/// possible; money notices live in their own group with a disjoint id space
/// (see [notificationId]) and never collide with calendar reminders.
List<ScheduledNotice> upcomingMoneyNotices({
  required List<MoneyItem> items,
  required DateTime now,
  required String Function(MoneyItem item) dueTitle,
  required String Function(MoneyItem item) dueSoonTitle,
  required String Function(MoneyItem item) body,
  Duration horizon = const Duration(days: 90),
  bool dayBefore = true,
}) {
  final end = now.add(horizon);
  final out = <ScheduledNotice>[];
  for (final item in items) {
    if (item.isSettled) continue;
    final due = DateTime(
      item.nextDueDate.year,
      item.nextDueDate.month,
      item.nextDueDate.day,
      9,
    );
    if (due.isAfter(end)) continue;
    final route = AppRoutes.moneyItemPath(item.id);
    if (due.isAfter(now)) {
      out.add(
        ScheduledNotice(
          id: notificationId(group: 'money', key: item.id, at: due, variant: 0),
          at: due,
          title: dueTitle(item),
          body: body(item),
          route: route,
        ),
      );
    }
    if (dayBefore) {
      final earlier = due.subtract(const Duration(days: 1));
      if (earlier.isAfter(now)) {
        out.add(
          ScheduledNotice(
            id: notificationId(
              group: 'money',
              key: item.id,
              at: earlier,
              variant: 1,
            ),
            at: earlier,
            title: dueSoonTitle(item),
            body: body(item),
            route: route,
          ),
        );
      }
    }
  }
  out.sort((a, b) => a.at.compareTo(b.at));
  return out;
}
