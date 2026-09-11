import 'dart:ui' show Locale;

import 'package:core/core.dart'
    show AppCurrency, AppSettings, CalendarPreference, appSettingsProvider;
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translations/translations.dart'
    show LocaleSettings, appLocaleFromLanguageCode;

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

final class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.watch(appSettingsProvider);

  Future<void> setThemeMode(ThemeMode mode) {
    return ref.read(appSettingsProvider.notifier).setThemeMode(mode);
  }

  Future<void> setLocale(Locale locale) async {
    await ref.read(appSettingsProvider.notifier).setLocale(locale);
    await LocaleSettings.setLocale(
      appLocaleFromLanguageCode(locale.languageCode),
    );
  }

  Future<void> setCalendar(CalendarPreference calendar) {
    return ref.read(appSettingsProvider.notifier).setCalendar(calendar);
  }

  Future<void> setCurrency(AppCurrency currency) {
    return ref.read(appSettingsProvider.notifier).setCurrency(currency);
  }
}
