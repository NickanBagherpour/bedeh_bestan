import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart' show MoneyItem, Party;

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
    var items = <MoneyItem>[];
    var parties = <Party>[];

    void emit() {
      state = HomeState(
        status: HomeStatus.loaded,
        dashboard: buildHomeDashboard(
          items: items,
          parties: parties,
          now: DateTime.now(),
        ),
      );
    }

    final itemsSub = repo.watchItems().listen(
      (value) {
        items = value;
        emit();
      },
      onError: (_) {
        state = const HomeState(
          status: HomeStatus.error,
          errorKey: 'home.loadError',
        );
      },
    );
    final partiesSub = repo.watchParties().listen(
      (value) {
        parties = value;
        emit();
      },
      onError: (_) {
        state = const HomeState(
          status: HomeStatus.error,
          errorKey: 'home.loadError',
        );
      },
    );
    ref.onDispose(() {
      itemsSub.cancel();
      partiesSub.cancel();
    });
    return const HomeState(status: HomeStatus.loading);
  }
}
