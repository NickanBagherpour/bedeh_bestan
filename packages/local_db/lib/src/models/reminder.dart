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
    this.body,
    this.endAt,
    this.repeatEveryN,
  });

  final String id;
  final String title;
  final String? body;
  final DateTime startAt;
  final DateTime? endAt;
  final bool allDay;
  final RepeatRule repeatRule;
  final int? repeatEveryN;
  final bool notifyOnTime;
  final bool notifyDayBefore;
  final DateTime createdAt;
  final DateTime updatedAt;
}
