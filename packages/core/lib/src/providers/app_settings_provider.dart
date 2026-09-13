import 'dart:ui' show Locale;

import 'package:flutter/material.dart' show TextDirection, ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/app_storage.dart';
import '../storage/storage_providers.dart';
import '../reminders/reminder_schedule_policy.dart';
import '../utils/app_style.dart';
import '../utils/calendar_type.dart';
import '../utils/currency.dart';
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

  Future<void> setAppStyle(AppStyle style) async {
    state = state.copyWith(appStyle: style);
    await ref
        .read(appStorageProvider)
        .writeString(AppSettingsKeys.appStyle, style.name);
  }

  Future<void> setLocale(Locale locale) async {
    final direction = directionForLocale(locale);
    final nextCurrency =
        state.currency == defaultCurrencyForLocale(state.locale.languageCode)
            ? defaultCurrencyForLocale(locale.languageCode)
            : state.currency;
    final persistCurrency = nextCurrency != state.currency;
    state = state.copyWith(
      locale: locale,
      direction: direction,
      currency: nextCurrency,
    );
    await ref
        .read(appStorageProvider)
        .writeString(AppSettingsKeys.locale, locale.languageCode);
    if (persistCurrency) {
      await ref
          .read(appStorageProvider)
          .writeString(AppSettingsKeys.currency, nextCurrency.name);
    }
  }

  Future<void> setCalendar(CalendarPreference calendar) async {
    state = state.copyWith(calendar: calendar);
    await ref
        .read(appStorageProvider)
        .writeString(AppSettingsKeys.calendar, calendar.name);
  }

  Future<void> setCurrency(AppCurrency currency) async {
    state = state.copyWith(currency: currency);
    await ref
        .read(appStorageProvider)
        .writeString(AppSettingsKeys.currency, currency.name);
  }

  Future<void> setMoneyReminderMode(MoneyReminderMode mode) async {
    state = state.copyWith(moneyReminderMode: mode);
    await ref
        .read(appStorageProvider)
        .writeString(AppSettingsKeys.moneyReminderMode, mode.name);
  }

  Future<void> setMoneyReminderDaysBefore(List<int> days) async {
    final sorted = normalizeDaysBefore(days);
    state = state.copyWith(moneyReminderDaysBefore: sorted);
    await ref.read(appStorageProvider).writeString(
          AppSettingsKeys.moneyReminderDaysBefore,
          encodeDaysBeforeJson(sorted),
        );
  }

  Future<void> reloadFromStorage() async {
    state = loadAppSettings(storage: ref.read(appStorageProvider));
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
    appStyle: _enumByName(
          AppStyle.values,
          storage.readString(AppSettingsKeys.appStyle),
        ) ??
        AppStyle.classic,
    locale: locale,
    direction: directionForLocale(locale),
    calendar: _enumByName(
          CalendarPreference.values,
          storage.readString(AppSettingsKeys.calendar),
        ) ??
        CalendarPreference.jalali,
    currency: _enumByName(
          AppCurrency.values,
          storage.readString(AppSettingsKeys.currency),
        ) ??
        defaultCurrencyForLocale(locale.languageCode),
    moneyReminderMode: _enumByName(
          MoneyReminderMode.values,
          storage.readString(AppSettingsKeys.moneyReminderMode),
        ) ??
        MoneyReminderMode.range,
    moneyReminderDaysBefore: _loadReminderDays(storage),
  );
}

List<int> _loadReminderDays(AppStorage storage) {
  final raw = storage.readString(AppSettingsKeys.moneyReminderDaysBefore);
  if (raw == null || raw.trim().isEmpty) {
    return ReminderSchedulePolicy.defaultDaysBefore;
  }
  return decodeDaysBeforeJson(raw);
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
