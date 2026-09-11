import 'package:core/core.dart' show CalendarType;
import 'package:feature_calendar/src/application/notification_times.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart' show Reminder, RepeatRule;

void main() {
  final now = DateTime(2026, 9, 11, 12);

  Reminder reminder({
    required String id,
    required DateTime start,
    RepeatRule rule = RepeatRule.none,
    bool allDay = false,
    bool notifyOnTime = true,
    bool notifyDayBefore = false,
    String? body,
  }) {
    return Reminder(
      id: id,
      title: id,
      body: body,
      startAt: start,
      allDay: allDay,
      repeatRule: rule,
      notifyOnTime: notifyOnTime,
      notifyDayBefore: notifyDayBefore,
      createdAt: now,
      updatedAt: now,
    );
  }

  test('on-time notice uses the occurrence clock and skips the past', () {
    final notices = upcomingNotices(
      reminders: [
        reminder(id: 'past', start: now.subtract(const Duration(hours: 1))),
        reminder(id: 'soon', start: now.add(const Duration(hours: 2))),
      ],
      now: now,
      calendar: CalendarType.gregorian,
      dayBeforeBody: (item) => 'tomorrow ${item.title}',
    );
    expect(notices, hasLength(1));
    expect(notices.single.reminderId, 'soon');
    expect(notices.single.at, now.add(const Duration(hours: 2)));
    expect(notices.single.kind, ReminderNoticeKind.onTime);
  });

  test('all-day fires at 09:00 and day-before is the previous morning', () {
    final day = DateTime(2026, 9, 20);
    final notices = upcomingNotices(
      reminders: [
        reminder(
          id: 'insure',
          start: day,
          allDay: true,
          notifyDayBefore: true,
        ),
      ],
      now: now,
      calendar: CalendarType.gregorian,
      dayBeforeBody: (item) => 'tomorrow ${item.title}',
    );
    expect(
      notices.map((item) => (item.kind, item.at)),
      [
        (ReminderNoticeKind.dayBefore, DateTime(2026, 9, 19, 9)),
        (ReminderNoticeKind.onTime, DateTime(2026, 9, 20, 9)),
      ],
    );
    expect(notices.first.body, 'tomorrow insure');
  });

  test('flags and weekly repeats limit to the horizon', () {
    final start = DateTime(2026, 9, 12, 10);
    final silent = upcomingNotices(
      reminders: [
        reminder(
          id: 'off',
          start: start,
          notifyOnTime: false,
          notifyDayBefore: false,
        ),
      ],
      now: now,
      calendar: CalendarType.gregorian,
      dayBeforeBody: (item) => item.title,
    );
    expect(silent, isEmpty);

    final weekly = upcomingNotices(
      reminders: [
        reminder(id: 'week', start: start, rule: RepeatRule.weekly),
      ],
      now: now,
      calendar: CalendarType.gregorian,
      dayBeforeBody: (item) => item.title,
      horizon: const Duration(days: 21),
    );
    expect(weekly.map((item) => item.at), [
      DateTime(2026, 9, 12, 10),
      DateTime(2026, 9, 19, 10),
      DateTime(2026, 9, 26, 10),
    ]);
  });
}
