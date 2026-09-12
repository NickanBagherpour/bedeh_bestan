import 'package:core/core.dart'
    show
        AppRoutes,
        ScheduledNotice,
        appSettingsProvider,
        notificationSchedulerProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translations/translations.dart' show t;

import '../notification_times.dart';
import '../../data/repositories/calendar_repository_provider.dart';

/// Keeps OS notifications in sync with local reminders. Watch from the app.
final reminderNotificationSyncProvider = Provider<bool>((ref) {
  final repo = ref.watch(calendarRepositoryProvider);
  final scheduler = ref.watch(notificationSchedulerProvider);
  final calendar = ref.watch(appSettingsProvider).resolvedCalendar;
  final sub = repo.watchReminders().listen((reminders) {
    final notices = upcomingNotices(
      reminders: reminders,
      now: DateTime.now(),
      calendar: calendar,
      dayBeforeBody: (reminder) =>
          t.calendar.notificationDayBefore(title: reminder.title),
    );
    scheduler.replaceGroup('reminders', [
      for (final notice in notices)
        ScheduledNotice(
          id: notice.id,
          at: notice.at,
          title: notice.title,
          body: notice.body,
          route: AppRoutes.reminderPath(notice.reminderId),
        ),
    ]);
  });
  ref.onDispose(sub.cancel);
  return true;
});
