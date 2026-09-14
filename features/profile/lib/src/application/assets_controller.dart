import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart'
    show AssetAccount, AssetAccountKind, newEntityId;

import '../data/assets_repository_provider.dart';

final assetsControllerProvider =
    NotifierProvider<AssetsController, AssetsState>(AssetsController.new);

final class AssetsState {
  const AssetsState({
    this.accounts = const [],
    this.loading = true,
  });

  final List<AssetAccount> accounts;
  final bool loading;

  /// Total money across all accounts. Zero when nothing has been added.
  int get total => accounts.fold<int>(0, (sum, a) => sum + a.balance);
}

final class AssetsController extends Notifier<AssetsState> {
  @override
  AssetsState build() {
    final repo = ref.watch(assetsRepositoryProvider);
    final sub = repo.watchAccounts().listen((accounts) {
      state = AssetsState(accounts: accounts, loading: false);
    });
    ref.onDispose(sub.cancel);
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
    final existing = id == null ? null : await repo.get(id);
    await repo.upsert(
      AssetAccount(
        id: id ?? newEntityId('asset'),
        name: name.trim(),
        kind: kind,
        balance: balance,
        note: note?.trim().isEmpty == true ? null : note?.trim(),
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      ),
    );
  }

  Future<void> deleteAccount(String id) =>
      ref.read(assetsRepositoryProvider).delete(id);
}
