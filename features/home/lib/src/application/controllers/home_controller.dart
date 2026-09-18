import 'package:core/core.dart' show appSettingsProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart' show MoneyItem, MoneyPayment, Party;

import '../../data/repositories/home_repository.dart';
import '../../data/repositories/home_repository_provider.dart';
import '../home_dashboard.dart';
import '../state/home_state.dart';

final homeControllerProvider = NotifierProvider<HomeController, HomeState>(
  HomeController.new,
);

final class HomeController extends Notifier<HomeState> {
  @override
  HomeState build() {
    final repo = ref.watch(homeRepositoryProvider);
    final calendar = ref.watch(appSettingsProvider).resolvedCalendar;
    var items = <MoneyItem>[];
    var parties = <Party>[];
    var payments = <MoneyPayment>[];

    void emit() {
      state = state.copyWith(
        status: HomeStatus.loaded,
        dashboard: buildHomeDashboard(
          items: items,
          parties: parties,
          payments: payments,
          now: DateTime.now(),
          calendar: calendar,
        ),
        clearError: true,
      );
    }

    void onError(_) {
      state = const HomeState(
        status: HomeStatus.error,
        errorKey: 'home.loadError',
      );
    }

    final itemsSub = repo.watchItems().listen(
      (value) {
        items = value;
        emit();
      },
      onError: onError,
    );
    final partiesSub = repo.watchParties().listen(
      (value) {
        parties = value;
        emit();
      },
      onError: onError,
    );
    final paymentsSub = repo.watchPayments().listen(
      (value) {
        payments = value;
        emit();
      },
      onError: onError,
    );
    ref.onDispose(() {
      itemsSub.cancel();
      partiesSub.cancel();
      paymentsSub.cancel();
    });
    return const HomeState(status: HomeStatus.loading);
  }

  void retry() => ref.invalidateSelf();

  /// Records one suggested payment for [itemId]. Returns error message key.
  Future<String?> recordQuickPayment(String itemId) async {
    final repo = ref.read(homeRepositoryProvider);
    state = state.copyWith(busyPaymentItemId: itemId);
    try {
      final item = await repo.getItem(itemId);
      if (item == null) return 'money.missingItem';
      final amount = item.suggestedQuickPaymentAmount();
      if (amount == null || amount <= 0) return 'money.alreadySettled';
      await repo.recordPayment(moneyItemId: itemId, amount: amount);
      state = state.copyWith(clearBusyPayment: true);
      return null;
    } catch (e) {
      state = state.copyWith(clearBusyPayment: true);
      return HomeRepository.paymentErrorKey(e);
    }
  }
}
