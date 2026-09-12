final class MoneyPayment {
  const MoneyPayment({
    required this.id,
    required this.moneyItemId,
    required this.amount,
    required this.paidAt,
    this.note,
  });

  final String id;
  final String moneyItemId;
  final int amount;
  final DateTime paidAt;
  final String? note;
}
