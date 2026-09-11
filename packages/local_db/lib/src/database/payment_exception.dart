enum PaymentFailure { missingItem, settled, nonPositive, exceedsRemaining }

final class PaymentException implements Exception {
  const PaymentException(this.failure);

  final PaymentFailure failure;

  @override
  String toString() => 'PaymentException($failure)';
}
