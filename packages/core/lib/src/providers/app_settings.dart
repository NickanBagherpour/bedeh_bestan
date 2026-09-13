import 'dart:ui' show Locale;

import 'package:flutter/material.dart' show TextDirection, ThemeMode;

import '../reminders/reminder_schedule_policy.dart';
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
    this.moneyReminderMode = MoneyReminderMode.range,
    this.moneyReminderDaysBefore = ReminderSchedulePolicy.defaultDaysBefore,
  });

  final ThemeMode themeMode;
  final Locale locale;
  final TextDirection direction;
  final CalendarPreference calendar;
  final AppCurrency currency;
  final MoneyReminderMode moneyReminderMode;
  final List<int> moneyReminderDaysBefore;

  CalendarType get resolvedCalendar => calendarTypeFor(calendar);

  ReminderSchedulePolicy get moneyReminderPolicy => ReminderSchedulePolicy(
        mode: moneyReminderMode,
        daysBefore: moneyReminderDaysBefore,
      );

  AppSettings copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    TextDirection? direction,
    CalendarPreference? calendar,
    AppCurrency? currency,
    MoneyReminderMode? moneyReminderMode,
    List<int>? moneyReminderDaysBefore,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      direction: direction ?? this.direction,
      calendar: calendar ?? this.calendar,
      currency: currency ?? this.currency,
      moneyReminderMode: moneyReminderMode ?? this.moneyReminderMode,
      moneyReminderDaysBefore:
          moneyReminderDaysBefore ?? this.moneyReminderDaysBefore,
    );
  }
}

abstract final class AppSettingsKeys {
  static const themeMode = 'app.settings.themeMode';
  static const locale = 'app.settings.locale';
  static const calendar = 'app.settings.calendar';
  static const currency = 'app.settings.currency';
  static const moneyReminderMode = 'app.settings.moneyReminderMode';
  static const moneyReminderDaysBefore = 'app.settings.moneyReminderDaysBefore';

  static const List<String> all = [
    themeMode,
    locale,
    calendar,
    currency,
    moneyReminderMode,
    moneyReminderDaysBefore,
  ];
}
