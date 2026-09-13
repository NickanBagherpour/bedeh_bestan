import 'package:feature_profile/src/application/assets_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('net worth is assets plus طلب minus بدهی', () {
    expect(
      computeNetWorth(totalAssets: 100, openPay: 40, openReceive: 10),
      70,
    );
  });

  test('utilization is debts over assets', () {
    expect(
      debtUtilization(totalAssets: 200, openPay: 50),
      0.25,
    );
    expect(debtUtilization(totalAssets: 0, openPay: 50), isNull);
  });
}
