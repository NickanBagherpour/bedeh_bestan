# Feature: configurable reminder offsets (Settings defaults)

**Package:** `features/settings` + `packages/core` (`AppSettings` / `AppStorage`)
**Type:** feature
**Blocks:** [installment-due-notifications.md](installment-due-notifications.md), updates
[money-due-notifications.md](money-due-notifications.md) behaviour

## Read first

- `docs/architecture/08-i18n-theming.md`
- `features/money/lib/src/application/money_notifications.dart`

## Goal

Users control **when** money (and later calendar) due reminders fire — globally in
**Settings**, instead of hard-coded 7d / 2d / due day.

## Reminder mode (global default)

Two presets plus advanced:

| Mode | Behaviour |
|------|-----------|
| **Exact day only** | One notification on the due date at **09:00** (local). |
| **Range (before + due)** | Notifications on the due date **and** on each selected **days-before** offset. |

Default for new installs: **Range** with offsets **7, 2, 0** (0 = due day; store
`daysBefore` as sorted unique positive ints + always include due day when range mode).

## Settings UI (`features/settings`)

New section **«یادآوری سررسید»** / **Due reminders**:

- Segmented control or chips: **Exact day** vs **Range**.
- When **Range**: multi-select or checklist for common offsets (7, 3, 2, 1 days
  before) + optional «custom day» numeric field (1–30) to add one-off offsets.
- Show time hint: «09:00» (fixed in v1; custom time is out of scope).
- Footer explaining that per-item overrides exist on money form ([money-item-reminder-override.md](money-item-reminder-override.md)).

## Persistence (`packages/core`)

Extend `AppSettings` + `AppSettingsKeys`:

- `moneyReminderMode`: `exactDay` | `range`
- `moneyReminderDaysBefore`: JSON array of ints, e.g. `[7, 2]` (due day implied in range mode)

Load/save via existing `AppStorage`. Migrate: missing keys → range + `[7, 2]`.

## Scheduling (`features/money`)

Refactor `upcomingMoneyNotices` (and installment helper) to accept
`ReminderSchedulePolicy` built from settings + item override (item wins when not `default`).

Pure function + tests: given policy + due `DateTime`, emit notice instants; skip `<= now`.

## Calendar (follow-up, same settings section)

v1 can **reuse the same global policy** for calendar reminders that use
`notifyOnTime` / `notifyDayBefore`, or a second row «same as money» toggle — document
chosen approach in implementation; minimum is money items.

## i18n

Settings strings en + fa; `melos run translations`.

## Acceptance

- [ ] Changing mode/offsets persists and reschedules money notices on next sync.
- [ ] Exact day mode fires only on due morning.
- [ ] Range with `[7,2]` + due fires up to 3 notices per due event.
- [ ] Unit tests for policy → notice list.
- [ ] `melos run analyze && melos run test` pass.
