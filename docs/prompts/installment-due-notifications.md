# Feature: per-قسط due reminders (policy-driven offsets)

**Package:** `features/money` + `packages/core` (notifications)
**Type:** feature
**Depends on:**
- [reminder-offset-settings.md](reminder-offset-settings.md) (global defaults)
- [money-item-reminder-override.md](money-item-reminder-override.md) (per item)
- [money-due-notifications.md](money-due-notifications.md), [installment-schedule.md](installment-schedule.md)

## Goal

For **installment** items, schedule local notifications for **each unpaid قسط** using
the effective **reminder policy** (settings default or item override):

- **Exact day only** → one fire at قسط `dueDate` 09:00.
- **Range** → due day + each configured **days-before** offset (e.g. 7, 2, 0).

Hard-coded 7 / 2 / due are **defaults only** until settings ship; then read policy.

## Data / pure logic

- Build events from `installmentSchedule(item, calendar)` — unpaid rows with
  `dueDate` in `(now, now + horizon]` (90 days).
- For each قسط due date `D`, expand policy → list of `DateTime` instants at 09:00.
- Distinct `notificationId` per `(itemId, قسط index, offset key)`.
- Paid قسط → drop its notices on sync.

## Constraints

- Local only; web no-op.
- Skip instants `<= now`.

## i18n

Titles/bodies: قسط number + item title + party (en + fa).

## Acceptance

- [ ] Policy exact → one notice per upcoming قسط.
- [ ] Policy range `[7,2]` + due → up to 3 per قسط.
- [ ] Item override beats global settings.
- [ ] Tests in `features/money/test/`.
- [ ] `melos run analyze && melos run test` pass.
