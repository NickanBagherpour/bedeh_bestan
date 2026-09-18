# Feature: notification actions — mark paid & remind tomorrow

**Package:** `apps/bedeh_bestan` (plugin) + `features/money` + `packages/core`
**Type:** feature
**Depends on:** [money-due-notifications.md](money-due-notifications.md)

## Goal

Money / قسط due notifications expose **action buttons** so the user can respond
from the shade without hunting the app:

1. **Mark paid** — record payment for the suggested amount (installment:
   `installmentPrefillAmount` / one قسط; one-time: `remainingAmount` or confirm
   if partial policy needed) and dismiss the notification.
2. **Remind tomorrow** — cancel this notice id and reschedule the same payload
   for tomorrow 09:00 (snooze once per tap; no infinite spam).

Tap on the notification body still opens the money item (`route` payload).

## Platform reality (document in UI copy / docs)

| Platform | Mark paid without UI |
|----------|----------------------|
| **Android** | Target: true background action via `flutter_local_notifications` action +
  background isolate; Drift must init in callback. |
| **iOS** | Background execution is limited; v1 may **open app** briefly or show action
  that only works when app process is alive — ship Android-first, iOS best-effort. |
| **Web** | No-op (unchanged). |

## Implementation sketch

- Extend `ScheduledNotice` with optional `actions` (id, label, payload key).
- Extend `PluginNotifications` to register Android `DarwinNotificationAction` /
  categories where supported.
- Central handler: parse payload → `moneyItemId` + `action` → call repository
  `recordPayment` or reschedule snooze via a small `money_notification_actions.dart`
  helper (inject `AppDatabase` in app composition root, not from feature import
  cycles — follow existing notification sync wiring).
- After pay: run existing `moneyNotificationSyncProvider` to clear stale notices.

## Safety

- Confirm is **not** required for notification pay in v1 (user explicitly tapped
  «پرداخت شد»); amount is fixed to one قسط / full remaining cap.
- If item already settled, action is no-op + cancel notice.

## i18n

Action labels: `notificationActionMarkPaid`, `notificationActionRemindTomorrow` (en + fa).

## Acceptance

- [ ] Android: mark paid updates DB and clears due notices for that item.
- [ ] Android: remind tomorrow reschedules one notice.
- [ ] Tap body still navigates to money detail.
- [ ] `melos run analyze && melos run test` pass.
