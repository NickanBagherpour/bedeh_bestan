import 'package:local_db/local_db.dart'
    show MoneyItem, Reminder, ReminderKind, RepeatRule;

enum CalendarStatus { initial, loading, loaded, error }

final class CalendarState {
  const CalendarState({
    this.status = CalendarStatus.initial,
    this.reminders = const [],
    this.moneyItems = const [],
    this.errorKey,
  });

  final CalendarStatus status;
  final List<Reminder> reminders;
  final List<MoneyItem> moneyItems;
  final String? errorKey;

  Reminder? reminderById(String id) {
    for (final reminder in reminders) {
      if (reminder.id == id) return reminder;
    }
    return null;
  }

  CalendarState copyWith({
    CalendarStatus? status,
    List<Reminder>? reminders,
    List<MoneyItem>? moneyItems,
    String? errorKey,
    bool clearError = false,
  }) {
    return CalendarState(
      status: status ?? this.status,
      reminders: reminders ?? this.reminders,
      moneyItems: moneyItems ?? this.moneyItems,
      errorKey: clearError ? null : (errorKey ?? this.errorKey),
    );
  }
}

final class ReminderDraft {
  const ReminderDraft({
    this.id,
    required this.title,
    required this.startAt,
    required this.allDay,
    required this.repeatRule,
    required this.notifyOnTime,
    required this.notifyDayBefore,
    this.body,
    this.repeatEveryN,
    this.kind = ReminderKind.event,
  });

  final String? id;
  final String title;
  final String? body;
  final DateTime startAt;
  final bool allDay;
  final ReminderKind kind;
  final RepeatRule repeatRule;
  final int? repeatEveryN;
  final bool notifyOnTime;
  final bool notifyDayBefore;
}
