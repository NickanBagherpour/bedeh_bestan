import 'package:local_db/local_db.dart'
    show AppDatabase, AssetAccount, MoneyItem;

final class AssetsRepository {
  AssetsRepository({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  Stream<List<AssetAccount>> watchAccounts() => _database.watchAssetAccounts();

  Stream<List<MoneyItem>> watchMoneyItems() => _database.watchMoneyItems();

  Future<void> upsert(AssetAccount account) =>
      _database.upsertAssetAccount(account);

  Future<void> delete(String id) => _database.deleteAssetAccount(id);
}
