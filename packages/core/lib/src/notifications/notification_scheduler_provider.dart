import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notification_scheduler.dart';

/// The app overrides this with the platform scheduler; default is a no-op so
/// features and tests can depend on it without a plugin.
final notificationSchedulerProvider = Provider<NotificationScheduler>((ref) {
  return const NoopNotificationScheduler();
});

/// Stable notification id namespaced by [group] so independent sources (e.g.
/// reminders vs. money due dates) do not collide in the OS id space.
///
/// [key] identifies the owning entity, [at] the fire time (minute precision),
/// and [variant] disambiguates multiple notices for the same entity.
int notificationId({
  required String group,
  required String key,
  required DateTime at,
  required int variant,
}) {
  return Object.hash(
        group,
        key,
        at.millisecondsSinceEpoch ~/ 60000,
        variant,
      ) &
      0x7fffffff;
}
