import 'package:local_db/local_db.dart'
    show AssetAccount, MoneyItem, MoneyPayment, Party;

import '../money_period_report.dart';

enum MoneyReportStatus { initial, loading, loaded, error }

final class MoneyReportState {
  const MoneyReportState({
    this.status = MoneyReportStatus.initial,
    this.items = const [],
    this.payments = const [],
    this.parties = const {},
    this.assets = const [],
    this.rangeStart,
    this.rangeEnd,
    this.partyId,
    this.direction = MoneyReportDirectionFilter.all,
    this.errorKey,
  });

  final MoneyReportStatus status;
  final List<MoneyItem> items;
  final List<MoneyPayment> payments;
  final Map<String, Party> parties;
  final List<AssetAccount> assets;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final String? partyId;
  final MoneyReportDirectionFilter direction;
  final String? errorKey;

  MoneyPeriodReport? report({required DateTime now}) {
    final start = rangeStart;
    final end = rangeEnd;
    if (start == null || end == null) return null;
    return buildMoneyPeriodReport(
      items: items,
      payments: payments,
      parties: parties.values.toList(),
      assets: assets,
      rangeStart: start,
      rangeEnd: end,
      now: now,
      partyId: partyId,
      direction: direction,
    );
  }

  MoneyReportState copyWith({
    MoneyReportStatus? status,
    List<MoneyItem>? items,
    List<MoneyPayment>? payments,
    Map<String, Party>? parties,
    List<AssetAccount>? assets,
    DateTime? rangeStart,
    DateTime? rangeEnd,
    String? partyId,
    MoneyReportDirectionFilter? direction,
    String? errorKey,
    bool clearError = false,
    bool clearPartyId = false,
  }) {
    return MoneyReportState(
      status: status ?? this.status,
      items: items ?? this.items,
      payments: payments ?? this.payments,
      parties: parties ?? this.parties,
      assets: assets ?? this.assets,
      rangeStart: rangeStart ?? this.rangeStart,
      rangeEnd: rangeEnd ?? this.rangeEnd,
      partyId: clearPartyId ? null : (partyId ?? this.partyId),
      direction: direction ?? this.direction,
      errorKey: clearError ? null : (errorKey ?? this.errorKey),
    );
  }
}
