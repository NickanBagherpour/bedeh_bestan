import 'package:feature_calendar/calendar.dart'
    show ReminderNotice, ReminderNotificationClient;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

final class PluginReminderNotifications
    implements ReminderNotificationClient {
  PluginReminderNotifications({
    required this.channelName,
    required this.channelDescription,
    this.onTap,
  });

  final String channelName;
  final String channelDescription;
  final void Function(String reminderId)? onTap;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _ready = false;

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
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(_channel);
      await androidPlugin?.requestNotificationsPermission();
      await androidPlugin?.requestExactAlarmsPermission();
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
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
  Future<void> replaceAll(List<ReminderNotice> notices) async {
    if (!_ready) return;
    await _plugin.cancelAll();
    for (final notice in notices) {
      try {
        await _plugin.zonedSchedule(
          id: notice.id,
          title: notice.title,
          body: notice.body.isEmpty ? null : notice.body,
          scheduledDate: tz.TZDateTime.from(notice.at, tz.local),
          notificationDetails: _details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: notice.reminderId,
        );
      } catch (_) {
        try {
          await _plugin.zonedSchedule(
            id: notice.id,
            title: notice.title,
            body: notice.body.isEmpty ? null : notice.body,
            scheduledDate: tz.TZDateTime.from(notice.at, tz.local),
            notificationDetails: _details,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            payload: notice.reminderId,
          );
        } catch (_) {}
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
