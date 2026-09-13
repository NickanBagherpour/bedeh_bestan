import 'dart:convert';

import 'package:core/core.dart'
    show
        AppRoutes,
        CalendarType,
        ReminderSchedulePolicy,
        ScheduledNotice,
        decodeDaysBeforeJson,
        moneyItemReminderPolicyFromStorage,
        notificationId,
        resolveMoneyReminderPolicy,
        snoozeUntilTomorrow;
import 'package:local_db/local_db.dart' show MoneyItem, MoneySchedule;

import 'money_query.dart';

const moneySnoozeUntilKey = 'app.money.snoozeUntilJson';

Map<String, DateTime> decodeSnoozeUntilJson(String? raw) {
  if (raw == null || raw.trim().isEmpty) return {};
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return {};
    final out = <String, DateTime>{};
    for (final entry in decoded.entries) {
      final millis = entry.value;
      if (millis is! num) continue;
      final at = DateTime.fromMillisecondsSinceEpoch(millis.toInt());
      out['${entry.key}'] = at;
    }
    return out;
  } catch (_) {
    return {};
  }
}

String encodeSnoozeUntilJson(Map<String, DateTime> map) {
  return jsonEncode({
    for (final entry in map.entries)
      if (entry.key.isNotEmpty) entry.key: entry.value.millisecondsSinceEpoch,
  });
}

/// Builds all money due notices using app + per-item reminder policy.
List<ScheduledNotice> upcomingMoneyNotices({
  required List<MoneyItem> items,
  required DateTime now,
  required ReminderSchedulePolicy appPolicy,
  required CalendarType calendar,
  required String Function(MoneyItem item) dueTitle,
  required String Function(MoneyItem item) dueSoonTitle,
  required String Function(MoneyItem item, {int? installmentIndex}) body,
  String payActionLabel = '',
  String snoozeActionLabel = '',
  Map<String, DateTime> snoozeUntil = const {},
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
    final until = snoozeUntil[item.id];
    final snoozeAt =
        until != null && until.isAfter(now) && !until.isAfter(end) ? until : null;

    void addNotice({
      required DateTime at,
      required bool isDueDay,
      int? installmentIndex,
      int variant = 0,
      String? keySuffix,
    }) {
      out.add(
        ScheduledNotice(
          id: notificationId(
            group: 'money',
            key: '${item.id}:${keySuffix ?? installmentIndex ?? 'one'}',
            at: at,
            variant: variant,
          ),
          at: at,
          title: isDueDay ? dueTitle(item) : dueSoonTitle(item),
          body: body(item, installmentIndex: installmentIndex),
          route: route,
          moneyItemId: item.id,
          enablePaymentActions: true,
          payActionLabel: payActionLabel,
          snoozeActionLabel: snoozeActionLabel,
        ),
      );
    }

    void addForDue(DateTime dueDate, {int? installmentIndex}) {
      var variant = 0;
      for (final at in policy.instantsForDueDate(dueDate, now)) {
        if (at.isAfter(end)) continue;
        if (snoozeAt != null && !at.isAfter(snoozeAt)) continue;
        final isDueDay = at.day == dueDate.day &&
            at.month == dueDate.month &&
            at.year == dueDate.year;
        addNotice(
          at: at,
          isDueDay: isDueDay,
          installmentIndex: installmentIndex,
          variant: variant++,
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

    if (snoozeAt != null) {
      addNotice(
        at: snoozeAt,
        isDueDay: false,
        keySuffix: 'snooze',
      );
    }
  }

  out.sort((a, b) => a.at.compareTo(b.at));
  return out;
}

DateTime moneySnoozeInstant(DateTime now) => snoozeUntilTomorrow(now);
