import 'package:core/core.dart' show appSettingsProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart' show MoneyItem, MoneyPayment, Party;

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
      state = HomeState(
        status: HomeStatus.loaded,
        dashboard: buildHomeDashboard(
          items: items,
          parties: parties,
          payments: payments,
          now: DateTime.now(),
          calendar: calendar,
        ),
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
}
