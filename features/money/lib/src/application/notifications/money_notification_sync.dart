import 'package:core/core.dart'
    show appSettingsProvider, notificationSchedulerProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translations/translations.dart' show t;

import '../money_notifications.dart';
import '../../data/repositories/money_repository_provider.dart';

/// Keeps OS notifications in sync with unsettled money due dates.
final moneyNotificationSyncProvider = Provider<bool>((ref) {
  final repo = ref.watch(moneyRepositoryProvider);
  final scheduler = ref.watch(notificationSchedulerProvider);
  final settings = ref.watch(appSettingsProvider);
  final sub = repo.watchItems().listen((items) {
    final notices = upcomingMoneyNotices(
      items: items,
      now: DateTime.now(),
      appPolicy: settings.moneyReminderPolicy,
      calendar: settings.resolvedCalendar,
      dueTitle: (item) => t.money.dueTitle,
      dueSoonTitle: (item) => t.money.dueSoonTitle,
      body: (item, {installmentIndex}) => installmentIndex == null
          ? t.money.dueBody(title: item.title)
          : t.money.dueBodyInstallment(
              title: item.title,
              index: installmentIndex,
            ),
    );
    scheduler.replaceGroup('money', notices);
  });
  ref.onDispose(sub.cancel);
  return true;
});
