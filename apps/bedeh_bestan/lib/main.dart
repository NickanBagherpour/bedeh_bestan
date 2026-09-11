import 'package:core/core.dart'
    show
        AppStorage,
        appStorageProvider,
        initialAppSettingsProvider,
        loadAppSettings,
        sharedPreferencesProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translations/translations.dart'
    show
        LocaleSettings,
        TranslationProvider,
        appLocaleFromLanguageCode,
        useAppDefaultLocale;

import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final storage = AppStorage(preferences: preferences);
  final initialSettings = loadAppSettings(storage: storage);

  await useAppDefaultLocale();
  await LocaleSettings.setLocale(
    appLocaleFromLanguageCode(initialSettings.locale.languageCode),
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        appStorageProvider.overrideWithValue(storage),
        initialAppSettingsProvider.overrideWithValue(initialSettings),
      ],
      child: TranslationProvider(child: const BedeBestanApp()),
    ),
  );
}
