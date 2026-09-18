import 'package:feature_profile/src/application/assets_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart' show AssetAccount, AssetAccountKind;

void main() {
  AssetAccount account(int balance) => AssetAccount(
        id: 'a$balance',
        name: 'account',
        kind: AssetAccountKind.cash,
        balance: balance,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );

  test('total is zero when there are no accounts', () {
    expect(const AssetsState().total, 0);
  });

  test('total is the sum of every account balance', () {
    final state = AssetsState(
      accounts: [account(100), account(50), account(25)],
      loading: false,
    );
    expect(state.total, 175);
  });
}
