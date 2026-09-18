import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart' show MoneyItem, Reminder, RepeatRule;

import '../../data/repositories/calendar_repository_provider.dart';
import '../state/calendar_state.dart';

final calendarControllerProvider =
    NotifierProvider<CalendarController, CalendarState>(
  CalendarController.new,
);

final class CalendarController extends Notifier<CalendarState> {
  List<Reminder> _reminders = const [];
  List<MoneyItem> _moneyItems = const [];

  @override
  CalendarState build() {
    final repo = ref.watch(calendarRepositoryProvider);
    final remSub = repo.watchReminders().listen(
      (value) {
        _reminders = value;
        _emitLoaded();
      },
      onError: (_) => _emitError(),
    );
    final moneySub = repo.watchMoneyItems().listen(
      (value) {
        _moneyItems = value;
        _emitLoaded();
      },
      onError: (_) => _emitError(),
    );
    ref.onDispose(remSub.cancel);
    ref.onDispose(moneySub.cancel);
    return const CalendarState(status: CalendarStatus.loading);
  }

  void _emitLoaded() {
    state = CalendarState(
      status: CalendarStatus.loaded,
      reminders: _reminders,
      moneyItems: _moneyItems,
    );
  }

  void _emitError() {
    state = const CalendarState(
      status: CalendarStatus.error,
      errorKey: 'calendar.loadError',
    );
  }

  void retry() => ref.invalidateSelf();

  Future<String> saveDraft(ReminderDraft draft) async {
    final repo = ref.read(calendarRepositoryProvider);
    final now = DateTime.now();
    final existing =
        draft.id == null ? null : await repo.getReminder(draft.id!);
    final body = draft.body?.trim();
    final reminder = Reminder(
      id: draft.id ?? repo.nextId(),
      title: draft.title.trim(),
      body: (body == null || body.isEmpty) ? null : body,
      startAt: draft.startAt,
      allDay: draft.allDay,
      kind: draft.kind,
      repeatRule: draft.repeatRule,
      repeatEveryN: draft.repeatRule == RepeatRule.everyNDays
          ? draft.repeatEveryN
          : null,
      notifyOnTime: draft.notifyOnTime,
      notifyDayBefore: draft.notifyDayBefore,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
    await repo.upsertReminder(reminder);
    return reminder.id;
  }

  Future<void> deleteReminder(String id) {
    return ref.read(calendarRepositoryProvider).deleteReminder(id);
  }
}
