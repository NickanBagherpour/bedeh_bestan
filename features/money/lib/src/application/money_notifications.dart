import 'package:core/core.dart'
    show
        AppRoutes,
        CalendarType,
        ReminderSchedulePolicy,
        ScheduledNotice,
        decodeDaysBeforeJson,
        moneyItemReminderPolicyFromStorage,
        notificationId,
        resolveMoneyReminderPolicy;
import 'package:local_db/local_db.dart' show MoneyItem, MoneySchedule;

import 'money_query.dart';

/// Builds all money due notices using app + per-item reminder policy.
List<ScheduledNotice> upcomingMoneyNotices({
  required List<MoneyItem> items,
  required DateTime now,
  required ReminderSchedulePolicy appPolicy,
  required CalendarType calendar,
  required String Function(MoneyItem item) dueTitle,
  required String Function(MoneyItem item) dueSoonTitle,
  required String Function(MoneyItem item, {int? installmentIndex}) body,
  Duration horizon = const Duration(days: 90),
}) {
  final end = now.add(horizon);
  final out = <ScheduledNotice>[];

  for (final item in items) {
    if (item.isSettled) continue;
    final policy = resolveMoneyReminderPolicy(
      appDefault: appPolicy,
      itemPolicy: moneyItemReminderPolicyFromStorage(item.reminderPolicy),
      itemCustomDaysBefore: decodeDaysBeforeJson(item.reminderDaysBeforeJson),
    );
    final route = AppRoutes.moneyItemPath(item.id);

    void addForDue(DateTime dueDate, {int? installmentIndex}) {
      var variant = 0;
      for (final at in policy.instantsForDueDate(dueDate, now)) {
        if (at.isAfter(end)) continue;
        final isDueDay = at.day == dueDate.day &&
            at.month == dueDate.month &&
            at.year == dueDate.year;
        out.add(
          ScheduledNotice(
            id: notificationId(
              group: 'money',
              key: '${item.id}:${installmentIndex ?? 'one'}',
              at: at,
              variant: variant++,
            ),
            at: at,
            title: isDueDay ? dueTitle(item) : dueSoonTitle(item),
            body: body(item, installmentIndex: installmentIndex),
            route: route,
            moneyItemId: item.id,
            enablePaymentActions: isDueDay,
          ),
        );
      }
    }

    if (item.schedule == MoneySchedule.installment) {
      for (final row in installmentSchedule(item, calendar)) {
        if (row.state == InstallmentState.paid) continue;
        addForDue(row.dueDate, installmentIndex: row.index);
      }
    } else {
      addForDue(item.nextDueDate);
    }
  }

  out.sort((a, b) => a.at.compareTo(b.at));
  return out;
}
