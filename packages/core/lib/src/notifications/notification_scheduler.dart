import 'scheduled_notice.dart';

/// Platform scheduler for local notifications. Web and tests use [Noop].
///
/// Notices belong to a named [group] (e.g. `reminders`, `money`). Replacing a
/// group cancels only that group's previous notices, so independent sources
/// never clobber one another.
abstract interface class NotificationScheduler {
  Future<void> initialize();

  Future<void> replaceGroup(String group, List<ScheduledNotice> notices);
}

/// No-op scheduler used on web and in tests.
final class NoopNotificationScheduler implements NotificationScheduler {
  const NoopNotificationScheduler();

  @override
  Future<void> initialize() async {}

  @override
  Future<void> replaceGroup(String group, List<ScheduledNotice> notices) async {}
}
