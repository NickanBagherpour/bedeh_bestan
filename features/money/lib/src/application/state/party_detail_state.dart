import 'package:local_db/local_db.dart' show MoneyItem, MoneyPayment, Party;

enum PartyDetailStatus { initial, loading, loaded, error }

final class PartyDetailState {
  const PartyDetailState({
    this.status = PartyDetailStatus.initial,
    this.party,
    this.items = const [],
    this.payments = const [],
    this.errorKey,
    this.busy = false,
  });

  final PartyDetailStatus status;
  final Party? party;

  /// Accounts linked to this party.
  final List<MoneyItem> items;

  /// Payments across this party's accounts.
  final List<MoneyPayment> payments;

  final String? errorKey;
  final bool busy;

  PartyDetailState copyWith({
    PartyDetailStatus? status,
    Party? party,
    List<MoneyItem>? items,
    List<MoneyPayment>? payments,
    String? errorKey,
    bool? busy,
    bool clearError = false,
  }) {
    return PartyDetailState(
      status: status ?? this.status,
      party: party ?? this.party,
      items: items ?? this.items,
      payments: payments ?? this.payments,
      errorKey: clearError ? null : (errorKey ?? this.errorKey),
      busy: busy ?? this.busy,
    );
  }
}
