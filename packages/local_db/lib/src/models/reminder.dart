import 'enums.dart';

final class Reminder {
  const Reminder({
    required this.id,
    required this.title,
    required this.startAt,
    required this.allDay,
    required this.repeatRule,
    required this.notifyOnTime,
    required this.notifyDayBefore,
    required this.createdAt,
    required this.updatedAt,
    this.kind = ReminderKind.event,
    this.body,
    this.endAt,
    this.repeatEveryN,
  });

  Reminder copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? startAt,
    DateTime? endAt,
    bool? allDay,
    ReminderKind? kind,
    RepeatRule? repeatRule,
    int? repeatEveryN,
    bool? notifyOnTime,
    bool? notifyDayBefore,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearBody = false,
    bool clearEndAt = false,
    bool clearRepeatEveryN = false,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      body: clearBody ? null : (body ?? this.body),
      startAt: startAt ?? this.startAt,
      endAt: clearEndAt ? null : (endAt ?? this.endAt),
      allDay: allDay ?? this.allDay,
      kind: kind ?? this.kind,
      repeatRule: repeatRule ?? this.repeatRule,
      repeatEveryN:
          clearRepeatEveryN ? null : (repeatEveryN ?? this.repeatEveryN),
      notifyOnTime: notifyOnTime ?? this.notifyOnTime,
      notifyDayBefore: notifyDayBefore ?? this.notifyDayBefore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  final String id;
  final String title;
  final String? body;
  final DateTime startAt;
  final DateTime? endAt;
  final bool allDay;
  final ReminderKind kind;
  final RepeatRule repeatRule;
  final int? repeatEveryN;
  final bool notifyOnTime;
  final bool notifyDayBefore;
  final DateTime createdAt;
  final DateTime updatedAt;
}
