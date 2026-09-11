import 'package:core/core.dart'
    show
        AppCurrency,
        CalendarType,
        GroupedAmountFormatter,
        formatStoredMoney,
        groupAmount,
        monthBounds,
        parseStoredAmount,
        parseTomanInput,
        weekBounds;
import 'package:flutter_test/flutter_test.dart';
import 'package:shamsi_date/shamsi_date.dart';

void main() {
  test('parseTomanInput accepts Persian digits and grouping', () {
    expect(parseTomanInput('۱٬۲۰۰٬۰۰۰'), 1200000);
    expect(parseTomanInput('2500000'), 2500000);
    expect(parseTomanInput('  '), isNull);
  });

  test('groupAmount uses locale separators', () {
    expect(groupAmount(1200000, persianDigits: true), '۱٬۲۰۰٬۰۰۰');
    expect(groupAmount(1200000, persianDigits: false), '1,200,000');
  });

  test('rial display is ten times stored toman', () {
    expect(AppCurrency.rial.toDisplay(60_000_000), 600_000_000);
    expect(parseStoredAmount('۶۰۰٬۰۰۰٬۰۰۰', AppCurrency.rial), 60_000_000);
    expect(
      formatStoredMoney(
        60_000_000,
        currency: AppCurrency.rial,
        currencyLabel: 'ریال',
        persianDigits: true,
      ),
      '۶۰۰٬۰۰۰٬۰۰۰ ریال',
    );
  });

  test('GroupedAmountFormatter groups while typing', () {
    const formatter = GroupedAmountFormatter(persianDigits: false);
    final result = formatter.formatEditUpdate(
      TextEditingValue.empty,
      const TextEditingValue(text: '1200000'),
    );
    expect(result.text, '1,200,000');
  });

  test('monthBounds follow Jalali and Gregorian independently', () {
    final now = DateTime(2026, 9, 11);
    final gregorian = monthBounds(now, CalendarType.gregorian);
    expect(gregorian.start, DateTime(2026, 9, 1));
    expect(gregorian.endInclusive, DateTime(2026, 9, 30));

    final j = Jalali.fromDateTime(now);
    final jalali = monthBounds(now, CalendarType.jalali);
    expect(jalali.start, dateOnlyOf(Jalali(j.year, j.month, 1).toDateTime()));
    expect(
      jalali.endInclusive,
      dateOnlyOf(Jalali(j.year, j.month, j.monthLength).toDateTime()),
    );
  });

  test('weekBounds start Saturday for Jalali and Monday for Gregorian', () {
    final friday = DateTime(2026, 9, 11);
    expect(friday.weekday, DateTime.friday);
    final jalali = weekBounds(friday, CalendarType.jalali);
    expect(jalali.start.weekday, DateTime.saturday);
    expect(jalali.endInclusive.weekday, DateTime.friday);
    final gregorian = weekBounds(friday, CalendarType.gregorian);
    expect(gregorian.start.weekday, DateTime.monday);
    expect(gregorian.endInclusive.weekday, DateTime.sunday);
  });
}

DateTime dateOnlyOf(DateTime value) =>
    DateTime(value.year, value.month, value.day);
