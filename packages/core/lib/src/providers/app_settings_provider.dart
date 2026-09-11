import 'dart:ui' show Locale;

import 'package:flutter/material.dart' show TextDirection, ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/app_storage.dart';
import '../storage/storage_providers.dart';
import '../utils/calendar_type.dart';
import 'app_settings.dart';

/// Seed UI preferences before first frame. Override in `main.dart`.
final initialAppSettingsProvider = Provider<AppSettings>((ref) {
  return const AppSettings();
});

final appSettingsProvider =
    NotifierProvider<AppSettingsController, AppSettings>(
  AppSettingsController.new,
);

final class AppSettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.watch(initialAppSettingsProvider);

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await ref
        .read(appStorageProvider)
        .writeString(AppSettingsKeys.themeMode, mode.name);
  }

  Future<void> setLocale(Locale locale) async {
    final direction = directionForLocale(locale);
    state = state.copyWith(locale: locale, direction: direction);
    await ref
        .read(appStorageProvider)
        .writeString(AppSettingsKeys.locale, locale.languageCode);
  }

  Future<void> setCalendar(CalendarPreference calendar) async {
    state = state.copyWith(calendar: calendar);
    await ref
        .read(appStorageProvider)
        .writeString(AppSettingsKeys.calendar, calendar.name);
  }
}

/// Loads persisted settings at startup (call before building the container).
AppSettings loadAppSettings({required AppStorage storage}) {
  final localeCode = storage.readString(AppSettingsKeys.locale);
  final locale =
      localeCode != null && localeCode.isNotEmpty ? Locale(localeCode) : const Locale('fa');
  return AppSettings(
    themeMode:
        _enumByName(ThemeMode.values, storage.readString(AppSettingsKeys.themeMode)) ??
            ThemeMode.system,
    locale: locale,
    direction: directionForLocale(locale),
    calendar: _enumByName(
          CalendarPreference.values,
          storage.readString(AppSettingsKeys.calendar),
        ) ??
        CalendarPreference.jalali,
  );
}

TextDirection directionForLocale(Locale locale) {
  return switch (locale.languageCode) {
    'fa' || 'ar' || 'ur' => TextDirection.rtl,
    _ => TextDirection.ltr,
  };
}

T? _enumByName<T extends Enum>(List<T> values, String? name) {
  if (name == null) return null;
  for (final value in values) {
    if (value.name == name) return value;
  }
  return null;
}
