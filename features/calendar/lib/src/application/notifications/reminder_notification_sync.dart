import 'package:core/core.dart' show appSettingsProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translations/translations.dart' show t;

import '../notification_times.dart';
import '../../data/notifications/reminder_notification_client.dart';
import '../../data/repositories/calendar_repository_provider.dart';

final reminderNotificationClientProvider =
    Provider<ReminderNotificationClient>((ref) {
  return const NoopReminderNotificationClient();
});

/// Keeps OS notifications in sync with local reminders. Watch from the app.
final reminderNotificationSyncProvider = Provider<bool>((ref) {
  final repo = ref.watch(calendarRepositoryProvider);
  final client = ref.watch(reminderNotificationClientProvider);
  final calendar = ref.watch(appSettingsProvider).resolvedCalendar;
  final sub = repo.watchReminders().listen((reminders) {
    final notices = upcomingNotices(
      reminders: reminders,
      now: DateTime.now(),
      calendar: calendar,
      dayBeforeBody: (reminder) =>
          t.calendar.notificationDayBefore(title: reminder.title),
    );
    client.replaceAll(notices);
  });
  ref.onDispose(sub.cancel);
  return true;
});
