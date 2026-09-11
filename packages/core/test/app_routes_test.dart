import 'package:core/core.dart' show AppRoutes;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('nested money paths stay on the accounts tab', () {
    expect(AppRoutes.fromPath('/money/item/abc'), AppRoutes.money);
    expect(AppRoutes.fromPath('/money/new'), AppRoutes.money);
    expect(AppRoutes.indexOfPath('/money/item/abc/edit'), 1);
    expect(AppRoutes.moneyItemPath('x'), '/money/item/x');
    expect(AppRoutes.moneyNewPath(direction: 'pay'), '/money/new?direction=pay');
  });
}
