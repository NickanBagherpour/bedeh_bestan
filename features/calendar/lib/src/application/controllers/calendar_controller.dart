import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart' show Reminder, RepeatRule;

import '../../data/repositories/calendar_repository_provider.dart';
import '../state/calendar_state.dart';

final calendarControllerProvider =
    NotifierProvider<CalendarController, CalendarState>(
  CalendarController.new,
);

final class CalendarController extends Notifier<CalendarState> {
  @override
  CalendarState build() {
    final repo = ref.watch(calendarRepositoryProvider);
    final sub = repo.watchReminders().listen(
      (value) {
        state = CalendarState(
          status: CalendarStatus.loaded,
          reminders: value,
        );
      },
      onError: (_) {
        state = const CalendarState(
          status: CalendarStatus.error,
          errorKey: 'calendar.loadError',
        );
      },
    );
    ref.onDispose(sub.cancel);
    return const CalendarState(status: CalendarStatus.loading);
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
