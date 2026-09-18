/// One local notification to schedule.
///
/// [at] is the local wall-clock instant to fire, [title] / [body] are the shown
/// copy, and [route] is the in-app path to open when the user taps it.
final class ScheduledNotice {
  const ScheduledNotice({
    required this.id,
    required this.at,
    required this.title,
    required this.body,
    required this.route,
    this.moneyItemId,
    this.enablePaymentActions = false,
    this.payActionLabel,
    this.snoozeActionLabel,
  });

  final int id;
  final DateTime at;
  final String title;
  final String body;
  final String route;
  final String? moneyItemId;
  final bool enablePaymentActions;
  final String? payActionLabel;
  final String? snoozeActionLabel;
}
