import 'package:local_db/local_db.dart' show Reminder, RepeatRule;

enum CalendarStatus { initial, loading, loaded, error }

final class CalendarState {
  const CalendarState({
    this.status = CalendarStatus.initial,
    this.reminders = const [],
    this.errorKey,
  });

  final CalendarStatus status;
  final List<Reminder> reminders;
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
    String? errorKey,
    bool clearError = false,
  }) {
    return CalendarState(
      status: status ?? this.status,
      reminders: reminders ?? this.reminders,
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
  });

  final String? id;
  final String title;
  final String? body;
  final DateTime startAt;
  final bool allDay;
  final RepeatRule repeatRule;
  final int? repeatEveryN;
  final bool notifyOnTime;
  final bool notifyDayBefore;
}
