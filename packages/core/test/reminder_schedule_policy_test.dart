import 'package:core/core.dart' show MoneyReminderMode, ReminderSchedulePolicy;
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 9, 12, 10);
  final due = DateTime(2026, 9, 20);

  test('range includes days before and due morning', () {
    const policy = ReminderSchedulePolicy(
      mode: MoneyReminderMode.range,
      daysBefore: [7, 2],
    );
    expect(
      policy.instantsForDueDate(due, now),
      [
        DateTime(2026, 9, 13, 9),
        DateTime(2026, 9, 18, 9),
        DateTime(2026, 9, 20, 9),
      ],
    );
  });

  test('exact day only fires on due date', () {
    final policy = ReminderSchedulePolicy.exactDay();
    expect(policy.instantsForDueDate(due, now), [DateTime(2026, 9, 20, 9)]);
  });
}
