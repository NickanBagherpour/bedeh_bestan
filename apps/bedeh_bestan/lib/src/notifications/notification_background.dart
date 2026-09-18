import 'dart:async' show unawaited;

import 'package:core/core.dart'
    show AppStorage, decodeNoticePayload, loadAppSettings;
import 'package:feature_money/money.dart'
    show applyMoneyNotificationAction, syncMoneyNoticesNow;
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_db/local_db.dart' show AppDatabase;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translations/translations.dart'
    show LocaleSettings, appLocaleFromLanguageCode, t, useAppDefaultLocale;

import 'plugin_notifications.dart';

/// Top-level isolate callback for Android notification actions.
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  unawaited(handleBackgroundNotificationResponse(response));
}

@pragma('vm:entry-point')
Future<void> handleBackgroundNotificationResponse(
  NotificationResponse response,
) async {
  WidgetsFlutterBinding.ensureInitialized();
  final payload = response.payload;
  final actionId = response.actionId;
  if (payload == null || payload.isEmpty) return;
  if (actionId == null || actionId.isEmpty) return;

  final decoded = decodeNoticePayload(payload);
  final itemId = decoded.moneyItemId;
  if (itemId == null) return;

  final preferences = await SharedPreferences.getInstance();
  final storage = AppStorage(preferences: preferences);
  final settings = loadAppSettings(storage: storage);
  await useAppDefaultLocale();
  await LocaleSettings.setLocale(
    appLocaleFromLanguageCode(settings.locale.languageCode),
  );

  final database = AppDatabase.open();
  try {
    await applyMoneyNotificationAction(
      database: database,
      storage: storage,
      actionId: actionId,
      moneyItemId: itemId,
    );
    final notifications = PluginNotifications(
      channelName: t.calendar.title,
      channelDescription: t.app.appName,
      payActionLabel: t.money.notificationActionMarkPaid,
      snoozeActionLabel: t.money.notificationActionRemindTomorrow,
    );
    await notifications.initialize(cancelExisting: false);
    await syncMoneyNoticesNow(
      database: database,
      storage: storage,
      scheduler: notifications,
      appPolicy: settings.moneyReminderPolicy,
      calendar: settings.resolvedCalendar,
    );
  } catch (_) {
  } finally {
    await database.close();
  }
}
