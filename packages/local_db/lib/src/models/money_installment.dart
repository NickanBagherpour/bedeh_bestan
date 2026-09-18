/// One stored قسط row for an installment [MoneyItem].
///
/// When present, schedule / payment / prefill use these amounts and due dates
/// instead of equal splits from [MoneyItem.installmentAmount].
final class MoneyInstallment {
  const MoneyInstallment({
    required this.id,
    required this.moneyItemId,
    required this.index,
    required this.dueDate,
    required this.amount,
  });

  final String id;
  final String moneyItemId;

  /// 1-based قسط number.
  final int index;
  final DateTime dueDate;

  /// Amount in stored Toman.
  final int amount;

  MoneyInstallment copyWith({
    String? id,
    String? moneyItemId,
    int? index,
    DateTime? dueDate,
    int? amount,
  }) {
    return MoneyInstallment(
      id: id ?? this.id,
      moneyItemId: moneyItemId ?? this.moneyItemId,
      index: index ?? this.index,
      dueDate: dueDate ?? this.dueDate,
      amount: amount ?? this.amount,
    );
  }
}
