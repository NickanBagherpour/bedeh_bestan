import 'package:local_db/local_db.dart' show MoneyItem, MoneyPayment, Party;

enum MoneyDetailStatus { initial, loading, loaded, error }

final class MoneyDetailState {
  const MoneyDetailState({
    this.status = MoneyDetailStatus.initial,
    this.item,
    this.party,
    this.payments = const [],
    this.errorKey,
    this.busy = false,
  });

  final MoneyDetailStatus status;
  final MoneyItem? item;
  final Party? party;
  final List<MoneyPayment> payments;
  final String? errorKey;
  final bool busy;

  MoneyDetailState copyWith({
    MoneyDetailStatus? status,
    MoneyItem? item,
    Party? party,
    List<MoneyPayment>? payments,
    String? errorKey,
    bool? busy,
    bool clearError = false,
  }) {
    return MoneyDetailState(
      status: status ?? this.status,
      item: item ?? this.item,
      party: party ?? this.party,
      payments: payments ?? this.payments,
      errorKey: clearError ? null : (errorKey ?? this.errorKey),
      busy: busy ?? this.busy,
    );
  }
}
