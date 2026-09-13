import 'package:core/core.dart'
    show
        AppStorage,
        CalendarType,
        NotificationScheduler,
        ReminderSchedulePolicy,
        appSettingsProvider,
        appStorageProvider,
        notificationSchedulerProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart' show AppDatabase;
import 'package:translations/translations.dart' show t;

import '../money_notifications.dart';
import '../../data/repositories/money_repository_provider.dart';

/// Bump after a snooze so [moneyNotificationSyncProvider] rebuilds notices.
final moneySnoozeTickProvider =
    NotifierProvider<MoneySnoozeTick, int>(MoneySnoozeTick.new);

final class MoneySnoozeTick extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state++;
}

/// Keeps OS notifications in sync with unsettled money due dates.
final moneyNotificationSyncProvider = Provider<bool>((ref) {
  final repo = ref.watch(moneyRepositoryProvider);
  final scheduler = ref.watch(notificationSchedulerProvider);
  final settings = ref.watch(appSettingsProvider);
  final storage = ref.watch(appStorageProvider);
  ref.watch(moneySnoozeTickProvider);
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
      payActionLabel: t.money.notificationActionMarkPaid,
      snoozeActionLabel: t.money.notificationActionRemindTomorrow,
      snoozeUntil: decodeSnoozeUntilJson(
        storage.readString(moneySnoozeUntilKey),
      ),
    );
    scheduler.replaceGroup('money', notices);
  });
  ref.onDispose(sub.cancel);
  return true;
});

Future<void> syncMoneyNoticesNow({
  required AppDatabase database,
  required AppStorage storage,
  required NotificationScheduler scheduler,
  required ReminderSchedulePolicy appPolicy,
  required CalendarType calendar,
}) async {
  final items = await database.listMoneyItems();
  final notices = upcomingMoneyNotices(
    items: items,
    now: DateTime.now(),
    appPolicy: appPolicy,
    calendar: calendar,
    dueTitle: (_) => t.money.dueTitle,
    dueSoonTitle: (_) => t.money.dueSoonTitle,
    body: (item, {installmentIndex}) => installmentIndex == null
        ? t.money.dueBody(title: item.title)
        : t.money.dueBodyInstallment(
            title: item.title,
            index: installmentIndex,
          ),
    payActionLabel: t.money.notificationActionMarkPaid,
    snoozeActionLabel: t.money.notificationActionRemindTomorrow,
    snoozeUntil: decodeSnoozeUntilJson(
      storage.readString(moneySnoozeUntilKey),
    ),
  );
  await scheduler.replaceGroup('money', notices);
}
