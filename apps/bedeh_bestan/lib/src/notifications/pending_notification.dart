import 'dart:async' show unawaited;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notification_action_handler.dart';

/// Bridges a notification tap (which happens before the provider container is
/// ready) into Riverpod. The tapped notice's in-app route is queued until a
/// container is [attach]ed, then handed to [pendingNotificationRouteProvider].
final class NotificationTapSink {
  ProviderContainer? _container;
  String? _queued;

  void emit(String route, {String? actionId}) {
    final container = _container;
    if (container == null) {
      _queued = route;
      return;
    }
    unawaited(handleNotificationPayload(container, route, actionId: actionId));
  }

  void attach(ProviderContainer container) {
    _container = container;
    final queued = _queued;
    _queued = null;
    if (queued != null) {
      unawaited(handleNotificationPayload(container, queued));
    }
  }
}

/// In-app route requested by a tapped notification, consumed by the router.
final pendingNotificationRouteProvider =
    NotifierProvider<PendingNotificationRoute, String?>(
      PendingNotificationRoute.new,
    );

final class PendingNotificationRoute extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? route) => state = route;
}
