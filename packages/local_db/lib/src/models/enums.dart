/// Party kind — person, bank, shop, or a custom label.
enum PartyKind {
  person,
  bank,
  shop,
  custom,
}

/// بدهی (I must pay) vs طلب (they owe me).
enum MoneyDirection {
  pay,
  receive,
}

/// One-time amount vs N installment periods.
enum MoneySchedule {
  oneTime,
  installment,
}

/// Derived from due date + remaining balance.
enum MoneyStatus {
  upcoming,
  dueToday,
  overdue,
  settled,
}

/// Reminder recurrence.
enum RepeatRule {
  none,
  daily,
  weekly,
  monthly,
  yearly,
  everyNDays,
}

T enumByName<T extends Enum>(List<T> values, String name, T fallback) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  return fallback;
}
