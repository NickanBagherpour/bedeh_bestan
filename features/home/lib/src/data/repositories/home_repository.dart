import 'package:local_db/local_db.dart'
    show
        AppDatabase,
        MoneyItem,
        MoneyPayment,
        Party,
        PaymentException,
        PaymentFailure;

final class HomeRepository {
  HomeRepository({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  Stream<List<MoneyItem>> watchItems() => _database.watchMoneyItems();

  Stream<List<Party>> watchParties() => _database.watchParties();

  Stream<List<MoneyPayment>> watchPayments() => _database.watchPayments();

  Future<MoneyItem?> getItem(String id) => _database.getMoneyItem(id);

  Future<MoneyItem> recordPayment({
    required String moneyItemId,
    required int amount,
  }) {
    return _database.recordPayment(moneyItemId: moneyItemId, amount: amount);
  }

  /// User-facing error key for [PaymentException], if any.
  static String? paymentErrorKey(Object error) {
    if (error is PaymentException) {
      return switch (error.failure) {
        PaymentFailure.missingItem => 'money.missingItem',
        PaymentFailure.settled => 'money.settled',
        PaymentFailure.nonPositive => 'money.invalidAmount',
        PaymentFailure.exceedsRemaining => 'money.exceedsRemaining',
      };
    }
    return 'money.saveError';
  }
}
