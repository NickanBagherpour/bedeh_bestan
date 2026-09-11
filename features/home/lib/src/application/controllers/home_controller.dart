import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/home_repository_provider.dart';
import '../state/home_state.dart';

final homeControllerProvider = NotifierProvider<HomeController, HomeState>(
  HomeController.new,
);

final class HomeController extends Notifier<HomeState> {
  @override
  HomeState build() {
    Future.microtask(load);
    return const HomeState(status: HomeStatus.loading);
  }

  Future<void> load() async {
    state = state.copyWith(status: HomeStatus.loading, clearError: true);
    try {
      final snapshot = await ref.read(homeRepositoryProvider).snapshot();
      state = HomeState(status: HomeStatus.loaded, snapshot: snapshot);
    } catch (_) {
      state = const HomeState(
        status: HomeStatus.error,
        errorKey: 'home.loadError',
      );
    }
  }
}
