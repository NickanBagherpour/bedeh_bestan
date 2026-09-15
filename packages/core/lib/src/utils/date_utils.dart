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

/// True when [a] and [b] fall on the same local calendar day.
bool isSameDate(DateTime a, DateTime b) {
  final left = dateOnly(a);
  final right = dateOnly(b);
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}

/// Day-of-month in the active calendar (Jalali 1–31, not Gregorian `DateTime.day`).
int calendarDayOfMonth(DateTime date, CalendarType calendar) {
  switch (calendar) {
    case CalendarType.jalali:
      return toJalali(date).day;
    case CalendarType.gregorian:
      return date.day;
  }
}

/// Weekday name for [date]. Language chooses the words; the instant chooses the day.
String formatWeekday(DateTime date, {required bool persian}) {
  final index = (date.weekday + 1) % 7; // Saturday = 0
  if (persian) return jalaliWeekdayNames[index];
  return gregorianWeekdayNamesEnSatFirst[index];
}

/// Saturday-first English weekday names.
const List<String> gregorianWeekdayNamesEnSatFirst = [
  'Saturday',
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
];

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

/// English Gregorian month names (January = index 0).
const List<String> gregorianMonthNamesEn = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Persian labels for Gregorian months.
const List<String> gregorianMonthNamesFa = [
  'ژانویه',
  'فوریه',
  'مارس',
  'آوریل',
  'مه',
  'ژوئن',
  'ژوئیه',
  'اوت',
  'سپتامبر',
  'اکتبر',
  'نوامبر',
  'دسامبر',
];

/// Human date for a heading, e.g. «۲۰ شهریور ۱۴۰۵» or «11 September 2026».
String formatHeadingDate(
  DateTime date,
  CalendarType calendar, {
  required bool persian,
}) {
  switch (calendar) {
    case CalendarType.jalali:
      return formatLongDate(date, calendar);
    case CalendarType.gregorian:
      final names = persian ? gregorianMonthNamesFa : gregorianMonthNamesEn;
      return '${date.day} ${names[date.month - 1]} ${date.year}';
  }
}

/// Month + year for a calendar header, e.g. «شهریور ۱۴۰۵» or «September 2026».
String formatMonthYear(
  DateTime date,
  CalendarType calendar, {
  required bool persian,
}) {
  switch (calendar) {
    case CalendarType.jalali:
      final j = toJalali(date);
      return '${jalaliMonthNames[j.month - 1]} ${j.year}';
    case CalendarType.gregorian:
      final names = persian ? gregorianMonthNamesFa : gregorianMonthNamesEn;
      return '${names[date.month - 1]} ${date.year}';
  }
}

/// Day + month without year, e.g. «۱۵ شهریور» or «15 September».
String formatDayMonth(
  DateTime date,
  CalendarType calendar, {
  required bool persian,
}) {
  switch (calendar) {
    case CalendarType.jalali:
      final j = toJalali(date);
      return '${j.day} ${jalaliMonthNames[j.month - 1]}';
    case CalendarType.gregorian:
      final names = persian ? gregorianMonthNamesFa : gregorianMonthNamesEn;
      return '${date.day} ${names[date.month - 1]}';
  }
}

bool _sameCalendarMonth(DateTime a, DateTime b, CalendarType calendar) {
  switch (calendar) {
    case CalendarType.jalali:
      final left = toJalali(a);
      final right = toJalali(b);
      return left.year == right.year && left.month == right.month;
    case CalendarType.gregorian:
      return a.year == b.year && a.month == b.month;
  }
}

/// From/to labels for a day range.
///
/// Same calendar month: [from] is the start day number and [to] is
/// day + month (e.g. `15` / `21 September`). Crossing months: both are
/// day + month.
({String from, String to}) formatRangeEnds(
  DateTime start,
  DateTime end,
  CalendarType calendar, {
  required bool persian,
}) {
  final to = formatDayMonth(end, calendar, persian: persian);
  if (_sameCalendarMonth(start, end, calendar)) {
    return (from: '${calendarDayOfMonth(start, calendar)}', to: to);
  }
  return (from: formatDayMonth(start, calendar, persian: persian), to: to);
}

/// Shifts [date] by [months] in the chosen calendar, clamping the day.
DateTime shiftCalendarMonths(
  DateTime date,
  int months,
  CalendarType calendar,
) {
  switch (calendar) {
    case CalendarType.gregorian:
      final shifted = date.month - 1 + months;
      final year = date.year + (shifted / 12).floor();
      var month = (shifted % 12) + 1;
      if (month <= 0) month += 12;
      final lastDay = DateTime(year, month + 1, 0).day;
      final day = date.day < lastDay ? date.day : lastDay;
      return DateTime(
        year,
        month,
        day,
        date.hour,
        date.minute,
        date.second,
        date.millisecond,
        date.microsecond,
      );
    case CalendarType.jalali:
      final j = toJalali(date);
      final total = j.year * 12 + (j.month - 1) + months;
      final year = (total / 12).floor();
      final month = (total % 12) + 1;
      final last = Jalali(year, month, 1).monthLength;
      final day = j.day < last ? j.day : last;
      final next = Jalali(year, month, day).toDateTime();
      return DateTime(
        next.year,
        next.month,
        next.day,
        date.hour,
        date.minute,
        date.second,
        date.millisecond,
        date.microsecond,
      );
  }
}

/// 5–6 week cells covering the month of [focus], padded to full weeks.
List<DateTime> monthGridCells(DateTime focus, CalendarType calendar) {
  final month = monthBounds(focus, calendar);
  var day = weekBounds(month.start, calendar).start;
  final cells = <DateTime>[];
  while (true) {
    cells.add(dateOnly(day));
    final coveredMonth = !dateOnly(day).isBefore(month.endInclusive);
    day = day.add(const Duration(days: 1));
    if (coveredMonth && cells.length % 7 == 0) break;
    if (cells.length >= 42) break;
  }
  return cells;
}
