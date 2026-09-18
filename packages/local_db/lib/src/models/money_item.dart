import 'enums.dart';
import 'money_installment.dart';

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
    this.reminderPolicy = 'default',
    this.reminderDaysBeforeJson = '[]',
    this.installments = const [],
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
  final String reminderPolicy;
  final String reminderDaysBeforeJson;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Stored per-قسط rows when the schedule was customized (or saved explicitly).
  /// Empty → equal-split generation from [installmentAmount] / count.
  final List<MoneyInstallment> installments;

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

  /// Amount of the current unpaid قسط when stored rows exist.
  int? currentInstallmentAmount() {
    if (schedule != MoneySchedule.installment) return null;
    if (isSettled) return null;
    if (installments.isNotEmpty) {
      final sorted = [...installments]
        ..sort((a, b) => a.index.compareTo(b.index));
      for (final row in sorted) {
        if (row.index > periodsPaid) {
          return row.amount > 0 ? row.amount : null;
        }
      }
      return null;
    }
    final count = installmentCount;
    final each = installmentAmount ??
        (count != null && count > 0 ? (totalAmount / count).round() : null);
    if (each == null || each <= 0) return null;
    return each;
  }

  /// One-tap payment amount: one قسط for installment, else full remaining.
  int? suggestedQuickPaymentAmount() {
    if (isSettled) return null;
    if (schedule == MoneySchedule.installment) {
      final each = currentInstallmentAmount();
      if (each == null || each <= 0) return remainingAmount;
      return each < remainingAmount ? each : remainingAmount;
    }
    return remainingAmount;
  }

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
    String? reminderPolicy,
    String? reminderDaysBeforeJson,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<MoneyInstallment>? installments,
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
      reminderPolicy: reminderPolicy ?? this.reminderPolicy,
      reminderDaysBeforeJson:
          reminderDaysBeforeJson ?? this.reminderDaysBeforeJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      installments: installments ?? this.installments,
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
