import '../../application/notification_times.dart';

/// Platform scheduler for reminder notices. Tests and web use [Noop].
abstract interface class ReminderNotificationClient {
  Future<void> initialize();

  Future<void> replaceAll(List<ReminderNotice> notices);
}

final class NoopReminderNotificationClient
    implements ReminderNotificationClient {
  const NoopReminderNotificationClient();

  @override
  Future<void> initialize() async {}

  @override
  Future<void> replaceAll(List<ReminderNotice> notices) async {}
}
