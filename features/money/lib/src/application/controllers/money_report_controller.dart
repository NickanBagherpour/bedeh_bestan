import 'package:core/core.dart'
    show CalendarType, appSettingsProvider, dateOnly;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart'
    show AssetAccount, MoneyItem, MoneyPayment, Party;

import '../../data/repositories/money_repository_provider.dart';
import '../money_period_report.dart';
import '../state/money_report_state.dart';

final moneyReportControllerProvider =
    NotifierProvider.autoDispose<MoneyReportController, MoneyReportState>(
  MoneyReportController.new,
);

final class MoneyReportController extends Notifier<MoneyReportState> {
  @override
  MoneyReportState build() {
    final calendar = ref.watch(appSettingsProvider).resolvedCalendar;
    final defaults = defaultMoneyReportRange(DateTime.now(), calendar);

    final repo = ref.watch(moneyRepositoryProvider);
    var items = <MoneyItem>[];
    var payments = <MoneyPayment>[];
    var parties = <String, Party>{};
    var assets = <AssetAccount>[];
    var itemsReady = false;
    var paymentsReady = false;
    var partiesReady = false;
    var assetsReady = false;

    void emit() {
      if (!itemsReady || !paymentsReady || !partiesReady || !assetsReady) {
        return;
      }
      state = state.copyWith(
        status: MoneyReportStatus.loaded,
        items: items,
        payments: payments,
        parties: parties,
        assets: assets,
        clearError: true,
      );
    }

    void fail() {
      state = state.copyWith(
        status: MoneyReportStatus.error,
        errorKey: 'money.loadError',
      );
    }

    final itemsSub = repo.watchItems().listen(
      (value) {
        items = value;
        itemsReady = true;
        emit();
      },
      onError: (_) => fail(),
    );
    final paymentsSub = repo.watchPayments().listen(
      (value) {
        payments = value;
        paymentsReady = true;
        emit();
      },
      onError: (_) => fail(),
    );
    final partiesSub = repo.watchParties().listen(
      (value) {
        parties = {for (final party in value) party.id: party};
        partiesReady = true;
        emit();
      },
      onError: (_) => fail(),
    );
    final assetsSub = repo.watchAssetAccounts().listen(
      (value) {
        assets = value;
        assetsReady = true;
        emit();
      },
      onError: (_) => fail(),
    );

    ref.onDispose(() {
      itemsSub.cancel();
      paymentsSub.cancel();
      partiesSub.cancel();
      assetsSub.cancel();
    });

    return MoneyReportState(
      status: MoneyReportStatus.loading,
      rangeStart: defaults.start,
      rangeEnd: defaults.endInclusive,
    );
  }

  void retry() => ref.invalidateSelf();

  void setRange({required DateTime start, required DateTime end}) {
    var from = dateOnly(start);
    var to = dateOnly(end);
    if (to.isBefore(from)) {
      final swap = from;
      from = to;
      to = swap;
    }
    state = state.copyWith(rangeStart: from, rangeEnd: to);
  }

  void resetToCurrentMonth() {
    final calendar = ref.read(appSettingsProvider).resolvedCalendar;
    final range = defaultMoneyReportRange(DateTime.now(), calendar);
    state = state.copyWith(
      rangeStart: range.start,
      rangeEnd: range.endInclusive,
    );
  }

  void setPartyId(String? partyId) {
    if (partyId == null) {
      state = state.copyWith(clearPartyId: true);
    } else {
      state = state.copyWith(partyId: partyId);
    }
  }

  void setDirection(MoneyReportDirectionFilter direction) {
    state = state.copyWith(direction: direction);
  }

  CalendarType get calendar =>
      ref.read(appSettingsProvider).resolvedCalendar;
}
