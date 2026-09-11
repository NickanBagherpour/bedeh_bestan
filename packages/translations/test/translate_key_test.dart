import 'package:flutter_test/flutter_test.dart';
import 'package:translations/translations.dart'
    show AppLocaleUtils, TranslationsLookup;

void main() {
  test('t.translate resolves app keys', () {
    final t = AppLocaleUtils.parse('en').buildSync();
    expect(t.translate('app.nav.home'), 'Home');
    expect(t.app.comingSoon, 'Coming soon');
  });

  test('t.translate falls back for unknown keys', () {
    final t = AppLocaleUtils.parse('en').buildSync();
    expect(t.translate('not.a.real.key'), 'not.a.real.key');
  });
}
