import 'enums.dart';

final class MoneyItem {
  const MoneyItem({
    required this.id,
    required this.partyId,
    required this.direction,
    required this.title,
    required this.totalAmount,
    required this.paidAmount,
    required this.schedule,
    required this.startDate,
    required this.nextDueDate,
    required this.createdAt,
    required this.updatedAt,
    this.installmentCount,
    this.installmentAmount,
    this.periodsPaid = 0,
    this.note,
  });

  final String id;
  final String partyId;
  final MoneyDirection direction;
  final String title;

  /// Total in Toman (integer).
  final int totalAmount;

  /// Sum of recorded payments, Toman.
  final int paidAmount;
  final MoneySchedule schedule;
  final int? installmentCount;
  final int? installmentAmount;
  final int periodsPaid;
  final DateTime startDate;
  final DateTime nextDueDate;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  int get remainingAmount {
    final left = totalAmount - paidAmount;
    return left < 0 ? 0 : left;
  }

  int get remainingPeriods {
    final total = installmentCount;
    if (total == null) return 0;
    final left = total - periodsPaid;
    return left < 0 ? 0 : left;
  }

  bool get isSettled => remainingAmount <= 0;

  MoneyStatus statusOn(DateTime now) {
    if (isSettled) return MoneyStatus.settled;
    final due = DateTime(nextDueDate.year, nextDueDate.month, nextDueDate.day);
    final today = DateTime(now.year, now.month, now.day);
    if (due.isBefore(today)) return MoneyStatus.overdue;
    if (due == today) return MoneyStatus.dueToday;
    return MoneyStatus.upcoming;
  }
}
