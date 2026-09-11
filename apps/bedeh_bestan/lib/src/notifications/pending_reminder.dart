import 'package:flutter_riverpod/flutter_riverpod.dart';

final class NotificationTapSink {
  ProviderContainer? _container;
  String? _queued;

  void emit(String id) {
    final container = _container;
    if (container == null) {
      _queued = id;
      return;
    }
    container.read(pendingReminderIdProvider.notifier).set(id);
  }

  void attach(ProviderContainer container) {
    _container = container;
    final queued = _queued;
    _queued = null;
    if (queued != null) {
      container.read(pendingReminderIdProvider.notifier).set(queued);
    }
  }
}

final pendingReminderIdProvider =
    NotifierProvider<PendingReminderId, String?>(PendingReminderId.new);

final class PendingReminderId extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? id) => state = id;
}
