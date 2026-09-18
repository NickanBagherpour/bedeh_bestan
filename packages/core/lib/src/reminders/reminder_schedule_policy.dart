import 'dart:convert';

/// Global default: one fire on due day, or due day plus days-before offsets.
enum MoneyReminderMode { exactDay, range }

/// Per money item: follow app settings or override.
enum MoneyItemReminderPolicy { defaultPolicy, exactDay, customRange }

/// Resolved schedule used when building OS notifications.
final class ReminderSchedulePolicy {
  const ReminderSchedulePolicy({
    required this.mode,
    required this.daysBefore,
  });

  final MoneyReminderMode mode;

  /// Sorted unique positive offsets (e.g. 7, 2). Due day is always included in
  /// [range] mode regardless of this list.
  final List<int> daysBefore;

  static const defaultDaysBefore = [7, 2];

  static ReminderSchedulePolicy defaults() => const ReminderSchedulePolicy(
        mode: MoneyReminderMode.range,
        daysBefore: defaultDaysBefore,
      );

  static ReminderSchedulePolicy exactDay() => const ReminderSchedulePolicy(
        mode: MoneyReminderMode.exactDay,
        daysBefore: [],
      );

  /// All local 09:00 instants to fire for a due calendar day [dueDate].
  List<DateTime> instantsForDueDate(DateTime dueDate, DateTime now) {
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day, 9);
    final out = <DateTime>[];
    if (mode == MoneyReminderMode.exactDay) {
      if (due.isAfter(now)) out.add(due);
      return out;
    }
    for (final days in daysBefore) {
      if (days <= 0) continue;
      final at = due.subtract(Duration(days: days));
      if (at.isAfter(now)) out.add(at);
    }
    if (due.isAfter(now)) out.add(due);
    out.sort();
    return out;
  }
}

ReminderSchedulePolicy resolveMoneyReminderPolicy({
  required ReminderSchedulePolicy appDefault,
  required MoneyItemReminderPolicy itemPolicy,
  required List<int> itemCustomDaysBefore,
}) {
  switch (itemPolicy) {
    case MoneyItemReminderPolicy.exactDay:
      return ReminderSchedulePolicy.exactDay();
    case MoneyItemReminderPolicy.customRange:
      final days = itemCustomDaysBefore.isEmpty
          ? ReminderSchedulePolicy.defaultDaysBefore
          : [...itemCustomDaysBefore]..sort();
      return ReminderSchedulePolicy(
        mode: MoneyReminderMode.range,
        daysBefore: days,
      );
    case MoneyItemReminderPolicy.defaultPolicy:
      return appDefault;
  }
}

List<int> normalizeDaysBefore(Iterable<int> days) {
  final unique = <int>{
    for (final day in days)
      if (day > 0 && day <= 30) day,
  }.toList()
    ..sort();
  return unique;
}

List<int> decodeDaysBeforeJson(String? raw) {
  if (raw == null || raw.trim().isEmpty) return const [];
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return normalizeDaysBefore([
      for (final v in decoded)
        if (v is num) v.toInt(),
    ]);
  } catch (_) {
    return const [];
  }
}

String encodeDaysBeforeJson(List<int> days) {
  return jsonEncode(normalizeDaysBefore(days));
}

/// Next local 09:00 after today — used by «remind tomorrow».
DateTime snoozeUntilTomorrow(DateTime now) {
  final tomorrow = DateTime(now.year, now.month, now.day).add(
    const Duration(days: 1),
  );
  return DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9);
}

MoneyItemReminderPolicy moneyItemReminderPolicyFromStorage(String? raw) {
  return switch (raw) {
    'exactDay' => MoneyItemReminderPolicy.exactDay,
    'customRange' => MoneyItemReminderPolicy.customRange,
    _ => MoneyItemReminderPolicy.defaultPolicy,
  };
}

String moneyItemReminderPolicyToStorage(MoneyItemReminderPolicy policy) {
  return switch (policy) {
    MoneyItemReminderPolicy.exactDay => 'exactDay',
    MoneyItemReminderPolicy.customRange => 'customRange',
    MoneyItemReminderPolicy.defaultPolicy => 'default',
  };
}
