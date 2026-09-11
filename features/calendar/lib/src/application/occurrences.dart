import 'package:core/core.dart' show CalendarType, dateOnly, shiftCalendarMonths;
import 'package:local_db/local_db.dart' show Reminder, RepeatRule;

final class CalendarOccurrence {
  const CalendarOccurrence({required this.reminder, required this.at});

  final Reminder reminder;
  final DateTime at;
}

List<CalendarOccurrence> expandOccurrences({
  required List<Reminder> reminders,
  required DateTime rangeStart,
  required DateTime rangeEnd,
  required CalendarType calendar,
}) {
  final start = dateOnly(rangeStart);
  final end = dateOnly(rangeEnd);
  final out = <CalendarOccurrence>[];
  for (final reminder in reminders) {
    for (final at in occurrenceTimes(
      reminder,
      start: start,
      end: end,
      calendar: calendar,
    )) {
      out.add(CalendarOccurrence(reminder: reminder, at: at));
    }
  }
  out.sort((a, b) {
    final byTime = a.at.compareTo(b.at);
    if (byTime != 0) return byTime;
    return a.reminder.title.compareTo(b.reminder.title);
  });
  return out;
}

List<DateTime> occurrenceTimes(
  Reminder reminder, {
  required DateTime start,
  required DateTime end,
  required CalendarType calendar,
}) {
  final origin = reminder.startAt;
  if (dateOnly(origin).isAfter(end)) return const [];

  switch (reminder.repeatRule) {
    case RepeatRule.none:
      final day = dateOnly(origin);
      if (!day.isBefore(start) && !day.isAfter(end)) return [origin];
      return const [];
    case RepeatRule.daily:
      return _stepDays(origin, start, end, 1);
    case RepeatRule.weekly:
      return _stepDays(origin, start, end, 7);
    case RepeatRule.everyNDays:
      final n = reminder.repeatEveryN ?? 0;
      if (n < 1) return const [];
      return _stepDays(origin, start, end, n);
    case RepeatRule.monthly:
      return _stepMonths(origin, start, end, 1, calendar);
    case RepeatRule.yearly:
      return _stepMonths(origin, start, end, 12, calendar);
  }
}

List<DateTime> _stepDays(
  DateTime origin,
  DateTime start,
  DateTime end,
  int step,
) {
  var cursor = origin;
  if (dateOnly(cursor).isBefore(start)) {
    final gap = start.difference(dateOnly(cursor)).inDays;
    final steps = (gap + step - 1) ~/ step;
    cursor = DateTime(
      origin.year,
      origin.month,
      origin.day,
      origin.hour,
      origin.minute,
      origin.second,
      origin.millisecond,
      origin.microsecond,
    ).add(Duration(days: steps * step));
  }
  final out = <DateTime>[];
  while (!dateOnly(cursor).isAfter(end)) {
    if (!dateOnly(cursor).isBefore(start)) out.add(cursor);
    cursor = cursor.add(Duration(days: step));
    if (out.length > 62) break;
  }
  return out;
}

List<DateTime> _stepMonths(
  DateTime origin,
  DateTime start,
  DateTime end,
  int monthStep,
  CalendarType calendar,
) {
  var cursor = origin;
  var guard = 0;
  while (dateOnly(cursor).isBefore(start) && guard < 240) {
    cursor = shiftCalendarMonths(cursor, monthStep, calendar);
    guard++;
  }
  final out = <DateTime>[];
  while (!dateOnly(cursor).isAfter(end) && guard < 260) {
    if (!dateOnly(cursor).isBefore(start)) out.add(cursor);
    cursor = shiftCalendarMonths(cursor, monthStep, calendar);
    guard++;
  }
  return out;
}
