import 'package:local_db/local_db.dart' show LibrarySnapshot;

enum HomeStatus { initial, loading, loaded, error }

final class HomeState {
  const HomeState({
    this.status = HomeStatus.initial,
    this.snapshot,
    this.errorKey,
  });

  final HomeStatus status;
  final LibrarySnapshot? snapshot;
  final String? errorKey;

  bool get isLoading =>
      status == HomeStatus.initial || status == HomeStatus.loading;

  HomeState copyWith({
    HomeStatus? status,
    LibrarySnapshot? snapshot,
    String? errorKey,
    bool clearError = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      snapshot: snapshot ?? this.snapshot,
      errorKey: clearError ? null : (errorKey ?? this.errorKey),
    );
  }
}
