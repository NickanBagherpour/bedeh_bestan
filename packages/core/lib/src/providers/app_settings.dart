import 'dart:ui' show Locale;

import 'package:flutter/material.dart' show TextDirection, ThemeMode;

import '../utils/calendar_type.dart';
import '../utils/currency.dart';

/// Persisted app-wide UI settings.
///
/// BedeBestan is RTL-first Persian; the default calendar is Jalali.
final class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('fa'),
    this.direction = TextDirection.rtl,
    this.calendar = CalendarPreference.jalali,
    this.currency = AppCurrency.toman,
  });

  final ThemeMode themeMode;
  final Locale locale;
  final TextDirection direction;
  final CalendarPreference calendar;
  final AppCurrency currency;

  CalendarType get resolvedCalendar => calendarTypeFor(calendar);

  AppSettings copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    TextDirection? direction,
    CalendarPreference? calendar,
    AppCurrency? currency,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      direction: direction ?? this.direction,
      calendar: calendar ?? this.calendar,
      currency: currency ?? this.currency,
    );
  }
}

abstract final class AppSettingsKeys {
  static const themeMode = 'app.settings.themeMode';
  static const locale = 'app.settings.locale';
  static const calendar = 'app.settings.calendar';
  static const currency = 'app.settings.currency';

  static const List<String> all = [themeMode, locale, calendar, currency];
}
