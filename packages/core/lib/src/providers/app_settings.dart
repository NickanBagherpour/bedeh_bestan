import 'dart:ui' show Locale;

import 'package:flutter/material.dart' show TextDirection, ThemeMode;

import '../utils/calendar_type.dart';

/// Persisted app-wide UI settings.
///
/// BedeBestan is RTL-first Persian; the default calendar is Jalali.
final class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('fa'),
    this.direction = TextDirection.rtl,
    this.calendar = CalendarPreference.jalali,
  });

  final ThemeMode themeMode;
  final Locale locale;
  final TextDirection direction;
  final CalendarPreference calendar;

  CalendarType get resolvedCalendar => calendarTypeFor(calendar);

  AppSettings copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    TextDirection? direction,
    CalendarPreference? calendar,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      direction: direction ?? this.direction,
      calendar: calendar ?? this.calendar,
    );
  }
}

abstract final class AppSettingsKeys {
  static const themeMode = 'app.settings.themeMode';
  static const locale = 'app.settings.locale';
  static const calendar = 'app.settings.calendar';
}
