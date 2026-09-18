import 'package:local_db/local_db.dart'
    show
        AppDatabase,
        AssetAccount,
        MoneyInstallment,
        MoneyItem,
        MoneyPayment,
        Party,
        PartyUsage,
        newEntityId;

final class MoneyRepository {
  MoneyRepository({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  Stream<List<MoneyItem>> watchItems() => _database.watchMoneyItems();

  Stream<List<Party>> watchParties() => _database.watchParties();

  Stream<List<MoneyPayment>> watchPayments() => _database.watchPayments();

  Stream<List<AssetAccount>> watchAssetAccounts() =>
      _database.watchAssetAccounts();

  Stream<List<MoneyPayment>> watchPaymentsFor(String moneyItemId) {
    return _database.watchPaymentsFor(moneyItemId);
  }

  Future<MoneyItem?> getItem(String id) => _database.getMoneyItem(id);

  Future<Party?> getParty(String id) => _database.getParty(id);

  Future<void> upsertParty(Party party) => _database.upsertParty(party);

  Future<PartyUsage> partyUsage(String id) => _database.partyUsage(id);

  Future<void> deleteParty(String id) => _database.deleteParty(id);

  Future<void> upsertItem(MoneyItem item) => _database.upsertMoneyItem(item);

  Future<void> replaceInstallments(
    String moneyItemId,
    List<MoneyInstallment> rows,
  ) {
    return _database.replaceInstallmentsFor(moneyItemId, rows);
  }

  Future<void> deleteItem(String id) => _database.deleteMoneyItem(id);

  Future<MoneyItem> recordPayment({
    required String moneyItemId,
    required int amount,
    DateTime? paidAt,
    String? note,
  }) {
    return _database.recordPayment(
      moneyItemId: moneyItemId,
      amount: amount,
      paidAt: paidAt,
      note: note,
    );
  }

  String nextId(String prefix) => newEntityId(prefix);
}
