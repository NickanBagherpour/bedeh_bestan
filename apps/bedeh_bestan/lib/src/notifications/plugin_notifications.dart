import 'package:core/core.dart' show NotificationScheduler, ScheduledNotice;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Platform local-notification scheduler. Notices are grouped so reminders and
/// money due dates can be replaced independently without clobbering each other.
/// [onTap] receives the notice's in-app route. Web / unsupported → no-op.
final class PluginNotifications implements NotificationScheduler {
  PluginNotifications({
    required this.channelName,
    required this.channelDescription,
    this.onTap,
  });

  final String channelName;
  final String channelDescription;
  final void Function(String route)? onTap;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _ready = false;

  /// OS ids currently scheduled per group, so a group can be replaced without
  /// touching notices owned by other groups.
  final Map<String, Set<int>> _scheduled = {};

  /// New id so devices that created a silent `reminders` channel get sound.
  static const _channelId = 'reminders_v2';
  static const _androidIcon = 'ic_stat_notify';

  AndroidNotificationChannel get _channel => AndroidNotificationChannel(
    _channelId,
    channelName,
    description: channelDescription,
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  NotificationDetails get _details => NotificationDetails(
    android: AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      audioAttributesUsage: AudioAttributesUsage.notificationEvent,
      icon: _androidIcon,
    ),
    iOS: const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
    macOS: const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  @override
  Future<void> initialize() async {
    if (kIsWeb || !_supported) return;
    try {
      tzdata.initializeTimeZones();
      _setLocalLocation();
      const android = AndroidInitializationSettings(_androidIcon);
      const darwin = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        defaultPresentSound: true,
      );
      const linux = LinuxInitializationSettings(defaultActionName: 'Open');
      const settings = InitializationSettings(
        android: android,
        iOS: darwin,
        macOS: darwin,
        linux: linux,
      );
      await _plugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: _onResponse,
      );
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidPlugin?.createNotificationChannel(_channel);
      await androidPlugin?.requestNotificationsPermission();
      await androidPlugin?.requestExactAlarmsPermission();
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      // Clear any stale scheduled notices from a previous run; the sync
      // providers immediately reschedule the current set per group.
      await _plugin.cancelAll();
      final launch = await _plugin.getNotificationAppLaunchDetails();
      final payload = launch?.notificationResponse?.payload;
      if (launch?.didNotificationLaunchApp == true &&
          payload != null &&
          payload.isNotEmpty) {
        onTap?.call(payload);
      }
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  @override
  Future<void> replaceGroup(String group, List<ScheduledNotice> notices) async {
    if (!_ready) return;
    final previous = _scheduled[group] ?? const <int>{};
    for (final id in previous) {
      try {
        await _plugin.cancel(id: id);
      } catch (_) {}
    }
    final current = <int>{};
    for (final notice in notices) {
      if (await _schedule(notice)) current.add(notice.id);
    }
    _scheduled[group] = current;
  }

  Future<bool> _schedule(ScheduledNotice notice) async {
    final when = tz.TZDateTime.from(notice.at, tz.local);
    final body = notice.body.isEmpty ? null : notice.body;
    try {
      await _plugin.zonedSchedule(
        id: notice.id,
        title: notice.title,
        body: body,
        scheduledDate: when,
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: notice.route,
      );
      return true;
    } catch (_) {
      try {
        await _plugin.zonedSchedule(
          id: notice.id,
          title: notice.title,
          body: body,
          scheduledDate: when,
          notificationDetails: _details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: notice.route,
        );
        return true;
      } catch (_) {
        return false;
      }
    }
  }

  void _onResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    onTap?.call(payload);
  }

  void _setLocalLocation() {
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Tehran'));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
  }

  bool get _supported {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
        return true;
      case TargetPlatform.fuchsia:
      case TargetPlatform.windows:
        return false;
    }
  }
}
