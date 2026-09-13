import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart'
    show AssetAccount, AssetAccountKind, MoneyDirection, MoneyItem, newEntityId;

import '../data/assets_repository_provider.dart';

final assetsControllerProvider =
    NotifierProvider<AssetsController, AssetsState>(AssetsController.new);

final class AssetsState {
  const AssetsState({
    this.accounts = const [],
    this.openPay = 0,
    this.openReceive = 0,
    this.loading = true,
  });

  final List<AssetAccount> accounts;
  final int openPay;
  final int openReceive;
  final bool loading;

  int get totalAssets =>
      accounts.fold<int>(0, (sum, a) => sum + a.balance);

  int get netWorth => totalAssets + openReceive - openPay;
}

final class AssetsController extends Notifier<AssetsState> {
  @override
  AssetsState build() {
    final repo = ref.watch(assetsRepositoryProvider);
    var accounts = <AssetAccount>[];
    var items = <MoneyItem>[];

    void emit() {
      var pay = 0;
      var receive = 0;
      for (final item in items) {
        if (item.isSettled) continue;
        if (item.direction == MoneyDirection.pay) {
          pay += item.remainingAmount;
        } else {
          receive += item.remainingAmount;
        }
      }
      state = AssetsState(
        accounts: accounts,
        openPay: pay,
        openReceive: receive,
        loading: false,
      );
    }

    final aSub = repo.watchAccounts().listen((value) {
      accounts = value;
      emit();
    });
    final mSub = repo.watchMoneyItems().listen((value) {
      items = value;
      emit();
    });
    ref.onDispose(() {
      aSub.cancel();
      mSub.cancel();
    });
    return const AssetsState();
  }

  Future<void> saveAccount({
    String? id,
    required String name,
    required AssetAccountKind kind,
    required int balance,
    String? note,
  }) async {
    final repo = ref.read(assetsRepositoryProvider);
    final now = DateTime.now();
    await repo.upsert(
      AssetAccount(
        id: id ?? newEntityId('asset'),
        name: name.trim(),
        kind: kind,
        balance: balance,
        note: note?.trim().isEmpty == true ? null : note?.trim(),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> deleteAccount(String id) =>
      ref.read(assetsRepositoryProvider).delete(id);
}
