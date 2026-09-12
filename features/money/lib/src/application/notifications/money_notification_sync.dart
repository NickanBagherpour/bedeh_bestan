import 'package:core/core.dart' show notificationSchedulerProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translations/translations.dart' show t;

import '../money_notifications.dart';
import '../../data/repositories/money_repository_provider.dart';

/// Keeps OS notifications in sync with unsettled money due dates. Rescheduling
/// happens whenever items change (create / edit / pay / settle / delete), so
/// stale notices are cancelled. Watch from the app.
final moneyNotificationSyncProvider = Provider<bool>((ref) {
  final repo = ref.watch(moneyRepositoryProvider);
  final scheduler = ref.watch(notificationSchedulerProvider);
  final sub = repo.watchItems().listen((items) {
    final notices = upcomingMoneyNotices(
      items: items,
      now: DateTime.now(),
      dueTitle: (item) => t.money.dueTitle,
      dueSoonTitle: (item) => t.money.dueSoonTitle,
      body: (item) => t.money.dueBody(title: item.title),
    );
    scheduler.replaceGroup('money', notices);
  });
  ref.onDispose(sub.cancel);
  return true;
});
