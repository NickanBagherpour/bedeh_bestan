import 'package:local_db/local_db.dart'
    show MoneyDirection, MoneyItem, MoneySchedule, Party;

import '../money_query.dart';

enum MoneyListStatus { initial, loading, loaded, error }

final class MoneyListState {
  const MoneyListState({
    this.status = MoneyListStatus.initial,
    this.items = const [],
    this.parties = const {},
    this.filter = MoneyListFilter.all,
    this.hideSettled = true,
    this.errorKey,
  });

  final MoneyListStatus status;
  final List<MoneyItem> items;
  final Map<String, Party> parties;
  final MoneyListFilter filter;
  final bool hideSettled;
  final String? errorKey;

  List<MoneyItem> visible({required DateTime now}) {
    return visibleMoneyItems(
      items: items,
      filter: filter,
      hideSettled: hideSettled,
      now: now,
    );
  }

  Party? partyFor(String partyId) => parties[partyId];

  MoneyListState copyWith({
    MoneyListStatus? status,
    List<MoneyItem>? items,
    Map<String, Party>? parties,
    MoneyListFilter? filter,
    bool? hideSettled,
    String? errorKey,
    bool clearError = false,
  }) {
    return MoneyListState(
      status: status ?? this.status,
      items: items ?? this.items,
      parties: parties ?? this.parties,
      filter: filter ?? this.filter,
      hideSettled: hideSettled ?? this.hideSettled,
      errorKey: clearError ? null : (errorKey ?? this.errorKey),
    );
  }
}

final class MoneyDraft {
  const MoneyDraft({
    this.id,
    required this.partyId,
    required this.direction,
    required this.title,
    required this.totalAmount,
    required this.schedule,
    required this.startDate,
    required this.nextDueDate,
    this.installmentCount,
    this.installmentAmount,
    this.note,
  });

  final String? id;
  final String partyId;
  final MoneyDirection direction;
  final String title;
  final int totalAmount;
  final MoneySchedule schedule;
  final DateTime startDate;
  final DateTime nextDueDate;
  final int? installmentCount;
  final int? installmentAmount;
  final String? note;
}
