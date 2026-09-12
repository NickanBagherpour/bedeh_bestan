# Feature: due-date notifications for money items

**Package:** `features/money` (+ reuse notification infra from Phase 8)
**Type:** feature
**Priority:** P2 (rivals lean hard on «یادآوری سررسید قسط / طلب / بدهی» via
notifications; it is the main retention hook in this category)

## Read first

- `docs/AGENTS.md`
- `docs/project/bedeh-bestan/PHASES.md` (Phase 8 — local notifications)

## Why

`MoneyItem` already stores `nextDueDate`, and Phase 8 schedules local
notifications for calendar reminders. But money due dates are **not** surfaced as
notifications, so an unsettled بدهی/قسط can silently pass its سررسید. Competitors
notify on the due date and the day before.

## Behavior (`features/money`)

- For **unsettled** money items with a future `nextDueDate`, schedule a local
  notification on the due date (and optionally one day before), reusing the
  existing scheduler used for reminders. Web stays a no-op (as in Phase 8).
- Reschedule when an item is created / edited / paid / settled / deleted so stale
  notifications are cancelled.
- Tapping the notification opens the money item overlay (`AppRoutes.moneyItemPath`).
- Keep it opt-outable if the reminder settings pattern allows (mirror
  `notifyOnTime` / `notifyDayBefore` semantics); otherwise a sensible default on.

## Constraints

- Local only. No push, no server. Same platform gating as Phase 8.
- Do not duplicate a notification if the user already created a manual calendar
  reminder for the same item (best-effort; document the chosen rule).

## i18n

Notification title/body strings in `money_en.i18n.json` + `money_fa.i18n.json`;
`melos run translations`.

## Acceptance

- [ ] Creating an unsettled item with a future due date schedules a notification.
- [ ] Settling / deleting the item cancels it.
- [ ] Tapping opens the correct money item.
- [ ] `melos run analyze && melos run test` pass.
