import 'dart:ui' show Locale;

import 'package:flutter/material.dart' show TextDirection, ThemeMode;

import '../reminders/reminder_schedule_policy.dart';
import '../utils/app_style.dart';
import '../utils/calendar_type.dart';
import '../utils/currency.dart';

/// Persisted app-wide UI settings.
///
/// BedeBestan is RTL-first Persian; the default calendar is Jalali.
final class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.appStyle = AppStyle.classic,
    this.locale = const Locale('fa'),
    this.direction = TextDirection.rtl,
    this.calendar = CalendarPreference.jalali,
    this.currency = AppCurrency.toman,
    this.moneyReminderMode = MoneyReminderMode.range,
    this.moneyReminderDaysBefore = ReminderSchedulePolicy.defaultDaysBefore,
    this.showCalendarEvents = true,
    this.showCalendarBirthdays = true,
    this.showCalendarMoney = true,
  });

  final ThemeMode themeMode;
  final AppStyle appStyle;
  final Locale locale;
  final TextDirection direction;
  final CalendarPreference calendar;
  final AppCurrency currency;
  final MoneyReminderMode moneyReminderMode;
  final List<int> moneyReminderDaysBefore;
  final bool showCalendarEvents;
  final bool showCalendarBirthdays;
  final bool showCalendarMoney;

  CalendarType get resolvedCalendar => calendarTypeFor(calendar);

  ReminderSchedulePolicy get moneyReminderPolicy => ReminderSchedulePolicy(
        mode: moneyReminderMode,
        daysBefore: moneyReminderDaysBefore,
      );

  AppSettings copyWith({
    ThemeMode? themeMode,
    AppStyle? appStyle,
    Locale? locale,
    TextDirection? direction,
    CalendarPreference? calendar,
    AppCurrency? currency,
    MoneyReminderMode? moneyReminderMode,
    List<int>? moneyReminderDaysBefore,
    bool? showCalendarEvents,
    bool? showCalendarBirthdays,
    bool? showCalendarMoney,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      appStyle: appStyle ?? this.appStyle,
      locale: locale ?? this.locale,
      direction: direction ?? this.direction,
      calendar: calendar ?? this.calendar,
      currency: currency ?? this.currency,
      moneyReminderMode: moneyReminderMode ?? this.moneyReminderMode,
      moneyReminderDaysBefore:
          moneyReminderDaysBefore ?? this.moneyReminderDaysBefore,
      showCalendarEvents: showCalendarEvents ?? this.showCalendarEvents,
      showCalendarBirthdays:
          showCalendarBirthdays ?? this.showCalendarBirthdays,
      showCalendarMoney: showCalendarMoney ?? this.showCalendarMoney,
    );
  }
}

abstract final class AppSettingsKeys {
  static const themeMode = 'app.settings.themeMode';
  static const appStyle = 'app.settings.appStyle';
  static const locale = 'app.settings.locale';
  static const calendar = 'app.settings.calendar';
  static const currency = 'app.settings.currency';
  static const moneyReminderMode = 'app.settings.moneyReminderMode';
  static const moneyReminderDaysBefore = 'app.settings.moneyReminderDaysBefore';
  static const showCalendarEvents = 'app.settings.showCalendarEvents';
  static const showCalendarBirthdays = 'app.settings.showCalendarBirthdays';
  static const showCalendarMoney = 'app.settings.showCalendarMoney';

  static const List<String> all = [
    themeMode,
    appStyle,
    locale,
    calendar,
    currency,
    moneyReminderMode,
    moneyReminderDaysBefore,
    showCalendarEvents,
    showCalendarBirthdays,
    showCalendarMoney,
  ];
}
