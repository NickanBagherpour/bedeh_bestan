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

  MoneyItem copyWith({
    String? id,
    String? partyId,
    MoneyDirection? direction,
    String? title,
    int? totalAmount,
    int? paidAmount,
    MoneySchedule? schedule,
    int? installmentCount,
    int? installmentAmount,
    int? periodsPaid,
    DateTime? startDate,
    DateTime? nextDueDate,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearNote = false,
    bool clearInstallmentCount = false,
    bool clearInstallmentAmount = false,
  }) {
    return MoneyItem(
      id: id ?? this.id,
      partyId: partyId ?? this.partyId,
      direction: direction ?? this.direction,
      title: title ?? this.title,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      schedule: schedule ?? this.schedule,
      installmentCount: clearInstallmentCount
          ? null
          : (installmentCount ?? this.installmentCount),
      installmentAmount: clearInstallmentAmount
          ? null
          : (installmentAmount ?? this.installmentAmount),
      periodsPaid: periodsPaid ?? this.periodsPaid,
      startDate: startDate ?? this.startDate,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      note: clearNote ? null : (note ?? this.note),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  MoneyStatus statusOn(DateTime now) {
    if (isSettled) return MoneyStatus.settled;
    final due = DateTime(nextDueDate.year, nextDueDate.month, nextDueDate.day);
    final today = DateTime(now.year, now.month, now.day);
    if (due.isBefore(today)) return MoneyStatus.overdue;
    if (due == today) return MoneyStatus.dueToday;
    return MoneyStatus.upcoming;
  }
}
