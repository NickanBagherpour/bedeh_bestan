import 'package:core/core.dart'
    show
        AppStorage,
        appStorageProvider,
        initialAppSettingsProvider,
        loadAppSettings,
        sharedPreferencesProvider;
import 'package:feature_calendar/calendar.dart'
    show reminderNotificationClientProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart'
    show AppDatabase, appDatabaseProvider, seedDemoData;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translations/translations.dart'
    show
        LocaleSettings,
        TranslationProvider,
        appLocaleFromLanguageCode,
        t,
        useAppDefaultLocale;

import 'src/app.dart';
import 'src/notifications/pending_reminder.dart';
import 'src/notifications/plugin_reminder_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final storage = AppStorage(preferences: preferences);
  final initialSettings = loadAppSettings(storage: storage);

  final database = AppDatabase.open();
  await seedDemoData(database);

  await useAppDefaultLocale();
  await LocaleSettings.setLocale(
    appLocaleFromLanguageCode(initialSettings.locale.languageCode),
  );

  final tapSink = NotificationTapSink();
  final notifications = PluginReminderNotifications(
    channelName: t.calendar.title,
    channelDescription: t.app.appName,
    onTap: tapSink.emit,
  );
  await notifications.initialize();

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(preferences),
      appStorageProvider.overrideWithValue(storage),
      initialAppSettingsProvider.overrideWithValue(initialSettings),
      appDatabaseProvider.overrideWithValue(database),
      reminderNotificationClientProvider.overrideWithValue(notifications),
    ],
  );
  tapSink.attach(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: TranslationProvider(child: const BedeBestanApp()),
    ),
  );
}
