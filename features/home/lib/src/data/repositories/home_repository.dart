import 'package:local_db/local_db.dart'
    show AppDatabase, MoneyItem, MoneyPayment, Party;

final class HomeRepository {
  HomeRepository({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  Stream<List<MoneyItem>> watchItems() => _database.watchMoneyItems();

  Stream<List<Party>> watchParties() => _database.watchParties();

  Stream<List<MoneyPayment>> watchPayments() => _database.watchPayments();
}
