import 'package:core/core.dart' show CalendarType, dateOnly;
import 'package:local_db/local_db.dart' show Reminder;

import 'occurrences.dart';

enum ReminderNoticeKind { onTime, dayBefore }

final class ReminderNotice {
  const ReminderNotice({
    required this.id,
    required this.reminderId,
    required this.at,
    required this.title,
    required this.body,
    required this.kind,
  });

  final int id;
  final String reminderId;
  final DateTime at;
  final String title;
  final String body;
  final ReminderNoticeKind kind;
}

/// Local wall-clock time a reminder should fire for one occurrence.
DateTime noticeClockTime(Reminder reminder, DateTime occurrence) {
  if (reminder.allDay) {
    return DateTime(occurrence.year, occurrence.month, occurrence.day, 9);
  }
  return occurrence;
}

int reminderNoticeId({
  required String reminderId,
  required DateTime at,
  required ReminderNoticeKind kind,
}) {
  return Object.hash(
        reminderId,
        at.millisecondsSinceEpoch ~/ 60000,
        kind.index,
      ) &
      0x7fffffff;
}

/// Upcoming local notifications for [reminders] within [horizon].
List<ReminderNotice> upcomingNotices({
  required List<Reminder> reminders,
  required DateTime now,
  required CalendarType calendar,
  required String Function(Reminder reminder) dayBeforeBody,
  Duration horizon = const Duration(days: 90),
  int maxPerReminder = 8,
}) {
  final end = now.add(horizon);
  final out = <ReminderNotice>[];
  for (final reminder in reminders) {
    if (!reminder.notifyOnTime && !reminder.notifyDayBefore) continue;
    final times = occurrenceTimes(
      reminder,
      start: dateOnly(now).subtract(const Duration(days: 1)),
      end: dateOnly(end),
      calendar: calendar,
    );
    var added = 0;
    for (final occurrence in times) {
      if (added >= maxPerReminder) break;
      final fire = noticeClockTime(reminder, occurrence);
      if (reminder.notifyOnTime && fire.isAfter(now)) {
        out.add(
          ReminderNotice(
            id: reminderNoticeId(
              reminderId: reminder.id,
              at: fire,
              kind: ReminderNoticeKind.onTime,
            ),
            reminderId: reminder.id,
            at: fire,
            title: reminder.title,
            body: reminder.body ?? '',
            kind: ReminderNoticeKind.onTime,
          ),
        );
        added++;
      }
      if (added >= maxPerReminder) break;
      if (reminder.notifyDayBefore) {
        final earlier = fire.subtract(const Duration(days: 1));
        if (earlier.isAfter(now)) {
          out.add(
            ReminderNotice(
              id: reminderNoticeId(
                reminderId: reminder.id,
                at: earlier,
                kind: ReminderNoticeKind.dayBefore,
              ),
              reminderId: reminder.id,
              at: earlier,
              title: reminder.title,
              body: dayBeforeBody(reminder),
              kind: ReminderNoticeKind.dayBefore,
            ),
          );
          added++;
        }
      }
    }
  }
  out.sort((a, b) => a.at.compareTo(b.at));
  return out;
}
