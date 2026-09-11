import 'package:core/core.dart' show fromPersianDigits, parseTomanInput;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parseTomanInput accepts Persian digits and grouping', () {
    expect(parseTomanInput('۱٬۲۰۰٬۰۰۰'), 1200000);
    expect(parseTomanInput('2500000'), 2500000);
    expect(parseTomanInput('  '), isNull);
    expect(fromPersianDigits('۱۴۰۳'), '1403');
  });
}
