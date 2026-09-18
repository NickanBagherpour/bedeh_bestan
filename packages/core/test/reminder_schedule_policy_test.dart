import 'package:core/core.dart'
    show
        MoneyItemReminderPolicy,
        MoneyReminderMode,
        ReminderSchedulePolicy,
        normalizeDaysBefore,
        resolveMoneyReminderPolicy,
        snoozeUntilTomorrow;
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

  test('skips instants that are not after now', () {
    const policy = ReminderSchedulePolicy(
      mode: MoneyReminderMode.range,
      daysBefore: [7, 2],
    );
    expect(
      policy.instantsForDueDate(due, DateTime(2026, 9, 18, 10)),
      [DateTime(2026, 9, 20, 9)],
    );
  });

  test('normalizeDaysBefore unique-sorts and clamps 1–30', () {
    expect(normalizeDaysBefore([7, 7, 0, 31, 2, 1]), [1, 2, 7]);
  });

  test('item custom range beats app exact day', () {
    final app = ReminderSchedulePolicy.exactDay();
    final resolved = resolveMoneyReminderPolicy(
      appDefault: app,
      itemPolicy: MoneyItemReminderPolicy.customRange,
      itemCustomDaysBefore: const [1],
    );
    expect(resolved.mode, MoneyReminderMode.range);
    expect(resolved.daysBefore, [1]);
    expect(
      resolved.instantsForDueDate(due, now),
      [DateTime(2026, 9, 19, 9), DateTime(2026, 9, 20, 9)],
    );
  });

  test('snoozeUntilTomorrow is next local 09:00', () {
    expect(
      snoozeUntilTomorrow(DateTime(2026, 9, 12, 22)),
      DateTime(2026, 9, 13, 9),
    );
  });
}
