import '../home_dashboard.dart';

enum HomeStatus { initial, loading, loaded, error }

final class HomeState {
  const HomeState({
    this.status = HomeStatus.initial,
    this.dashboard,
    this.errorKey,
    this.busyPaymentItemId,
  });

  final HomeStatus status;
  final HomeDashboard? dashboard;
  final String? errorKey;
  final String? busyPaymentItemId;

  HomeState copyWith({
    HomeStatus? status,
    HomeDashboard? dashboard,
    String? errorKey,
    bool clearError = false,
    String? busyPaymentItemId,
    bool clearBusyPayment = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      dashboard: dashboard ?? this.dashboard,
      errorKey: clearError ? null : (errorKey ?? this.errorKey),
      busyPaymentItemId:
          clearBusyPayment ? null : (busyPaymentItemId ?? this.busyPaymentItemId),
    );
  }
}
