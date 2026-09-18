import 'package:core/core.dart'
    show NotificationScheduler, ScheduledNotice, encodeNoticePayload;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Platform local-notification scheduler. Notices are grouped so reminders and
/// money due dates can be replaced independently without clobbering each other.
/// [onTap] receives the raw payload. Web / unsupported → no-op.
final class PluginNotifications implements NotificationScheduler {
  PluginNotifications({
    required this.channelName,
    required this.channelDescription,
    this.payActionLabel = 'Paid',
    this.snoozeActionLabel = 'Tomorrow',
    this.onTap,
  });

  final String channelName;
  final String channelDescription;
  final String payActionLabel;
  final String snoozeActionLabel;
  final void Function(String payload, {String? actionId})? onTap;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _ready = false;

  /// OS ids currently scheduled per group, so a group can be replaced without
  /// touching notices owned by other groups.
  final Map<String, Set<int>> _scheduled = {};

  /// New id so devices that created a silent `reminders` channel get sound.
  static const _channelId = 'reminders_v2';
  static const _androidIcon = 'ic_stat_notify';
  static const _moneyCategory = 'money_due';

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

  List<DarwinNotificationCategory> get _darwinCategories => [
        DarwinNotificationCategory(
          _moneyCategory,
          actions: [
            DarwinNotificationAction.plain('pay', payActionLabel),
            DarwinNotificationAction.plain('snooze', snoozeActionLabel),
          ],
        ),
      ];

  @override
  Future<void> initialize({
    bool cancelExisting = true,
    DidReceiveBackgroundNotificationResponseCallback? onBackground,
  }) async {
    if (kIsWeb || !_supported) return;
    try {
      tzdata.initializeTimeZones();
      _setLocalLocation();
      const android = AndroidInitializationSettings(_androidIcon);
      final darwin = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        defaultPresentSound: true,
        notificationCategories: _darwinCategories,
      );
      const linux = LinuxInitializationSettings(defaultActionName: 'Open');
      final settings = InitializationSettings(
        android: android,
        iOS: darwin,
        macOS: darwin,
        linux: linux,
      );
      await _plugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: _onResponse,
        onDidReceiveBackgroundNotificationResponse: onBackground,
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
      if (cancelExisting) {
        await _plugin.cancelAll();
        await _clearPersistedGroups();
      }
      final launch = await _plugin.getNotificationAppLaunchDetails();
      final response = launch?.notificationResponse;
      final payload = response?.payload;
      if (launch?.didNotificationLaunchApp == true &&
          payload != null &&
          payload.isNotEmpty) {
        onTap?.call(payload, actionId: response?.actionId);
      }
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  @override
  Future<void> replaceGroup(String group, List<ScheduledNotice> notices) async {
    if (!_ready) return;
    final previous = _scheduled[group] ?? await _loadGroupIds(group);
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
    await _saveGroupIds(group, current);
  }

  NotificationDetails _detailsFor(ScheduledNotice notice) {
    if (!notice.enablePaymentActions) return _details;
    final pay = notice.payActionLabel ?? payActionLabel;
    final snooze = notice.snoozeActionLabel ?? snoozeActionLabel;
    return NotificationDetails(
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
        actions: [
          AndroidNotificationAction(
            'pay',
            pay,
            showsUserInterface: false,
          ),
          AndroidNotificationAction(
            'snooze',
            snooze,
            showsUserInterface: false,
          ),
        ],
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        categoryIdentifier: _moneyCategory,
      ),
      macOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        categoryIdentifier: _moneyCategory,
      ),
    );
  }

  Future<bool> _schedule(ScheduledNotice notice) async {
    final when = tz.TZDateTime.from(notice.at, tz.local);
    final body = notice.body.isEmpty ? null : notice.body;
    final details = _detailsFor(notice);
    final payload = encodeNoticePayload(
      route: notice.route,
      moneyItemId: notice.moneyItemId,
    );
    try {
      await _plugin.zonedSchedule(
        id: notice.id,
        title: notice.title,
        body: body,
        scheduledDate: when,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
      return true;
    } catch (_) {
      try {
        await _plugin.zonedSchedule(
          id: notice.id,
          title: notice.title,
          body: body,
          scheduledDate: when,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: payload,
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
    onTap?.call(payload, actionId: response.actionId);
  }

  void _setLocalLocation() {
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Tehran'));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
  }

  Future<Set<int>> _loadGroupIds(String group) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(_groupKey(group)) ?? const [];
      return {
        for (final id in raw)
          if (int.tryParse(id) != null) int.parse(id),
      };
    } catch (_) {
      return {};
    }
  }

  Future<void> _saveGroupIds(String group, Set<int> ids) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _groupKey(group),
        [for (final id in ids) '$id'],
      );
    } catch (_) {}
  }

  Future<void> _clearPersistedGroups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      for (final key in prefs.getKeys()) {
        if (key.startsWith('notify.group.')) {
          await prefs.remove(key);
        }
      }
    } catch (_) {}
    _scheduled.clear();
  }

  String _groupKey(String group) => 'notify.group.$group';

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
