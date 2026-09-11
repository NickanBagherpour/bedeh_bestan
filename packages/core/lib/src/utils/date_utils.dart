import 'package:shamsi_date/shamsi_date.dart';

import 'calendar_type.dart';

/// Persian month names (Jalali).
const List<String> jalaliMonthNames = [
  'فروردین',
  'اردیبهشت',
  'خرداد',
  'تیر',
  'مرداد',
  'شهریور',
  'مهر',
  'آبان',
  'آذر',
  'دی',
  'بهمن',
  'اسفند',
];

/// Persian weekday names, starting Saturday (Jalali week start).
const List<String> jalaliWeekdayNames = [
  'شنبه',
  'یکشنبه',
  'دوشنبه',
  'سه‌شنبه',
  'چهارشنبه',
  'پنجشنبه',
  'جمعه',
];

/// Converts a [DateTime] to Jalali.
Jalali toJalali(DateTime dateTime) => Jalali.fromDateTime(dateTime);

/// Converts a [Jalali] date to a Gregorian [DateTime].
DateTime fromJalali(Jalali jalali) => jalali.toDateTime();

/// Formats [dateTime] as a numeric date for the given [calendarType].
///
/// Jalali: `yyyy/MM/dd`. Gregorian: `yyyy-MM-dd`.
String formatDate(DateTime dateTime, CalendarType calendarType) {
  switch (calendarType) {
    case CalendarType.jalali:
      final j = toJalali(dateTime);
      final y = j.year.toString().padLeft(4, '0');
      final m = j.month.toString().padLeft(2, '0');
      final d = j.day.toString().padLeft(2, '0');
      return '$y/$m/$d';
    case CalendarType.gregorian:
      final y = dateTime.year.toString().padLeft(4, '0');
      final m = dateTime.month.toString().padLeft(2, '0');
      final d = dateTime.day.toString().padLeft(2, '0');
      return '$y-$m-$d';
  }
}

/// Human, calendar-aware long date, e.g. «۱۲ خرداد ۱۴۰۳».
String formatLongDate(DateTime dateTime, CalendarType calendarType) {
  switch (calendarType) {
    case CalendarType.jalali:
      final j = toJalali(dateTime);
      return '${j.day} ${jalaliMonthNames[j.month - 1]} ${j.year}';
    case CalendarType.gregorian:
      return formatDate(dateTime, calendarType);
  }
}

/// Clock time as `HH:mm`.
String formatTime(DateTime dateTime) {
  final h = dateTime.hour.toString().padLeft(2, '0');
  final m = dateTime.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

/// Calendar date with time stripped.
DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

/// Inclusive start/end dates (no time).
final class DateRange {
  const DateRange({required this.start, required this.endInclusive});

  final DateTime start;
  final DateTime endInclusive;

  bool containsDate(DateTime value) {
    final day = dateOnly(value);
    return !day.isBefore(start) && !day.isAfter(endInclusive);
  }
}

/// First and last day of the month that contains [now], in [calendar].
DateRange monthBounds(DateTime now, CalendarType calendar) {
  switch (calendar) {
    case CalendarType.jalali:
      final j = toJalali(now);
      return DateRange(
        start: dateOnly(Jalali(j.year, j.month, 1).toDateTime()),
        endInclusive: dateOnly(
          Jalali(j.year, j.month, j.monthLength).toDateTime(),
        ),
      );
    case CalendarType.gregorian:
      return DateRange(
        start: DateTime(now.year, now.month, 1),
        endInclusive: DateTime(now.year, now.month + 1, 0),
      );
  }
}

/// Week that contains [now]: Saturday–Friday (Jalali) or Monday–Sunday (Gregorian).
DateRange weekBounds(DateTime now, CalendarType calendar) {
  final today = dateOnly(now);
  switch (calendar) {
    case CalendarType.jalali:
      final sinceSaturday = (today.weekday + 1) % 7;
      final start = today.subtract(Duration(days: sinceSaturday));
      return DateRange(
        start: start,
        endInclusive: start.add(const Duration(days: 6)),
      );
    case CalendarType.gregorian:
      final sinceMonday = today.weekday - 1;
      final start = today.subtract(Duration(days: sinceMonday));
      return DateRange(
        start: start,
        endInclusive: start.add(const Duration(days: 6)),
      );
  }
}
