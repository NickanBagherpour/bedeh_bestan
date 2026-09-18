# Feature: per-item reminder override (money create/edit)

**Package:** `features/money` + `packages/local_db`
**Type:** feature
**Depends on:** [reminder-offset-settings.md](reminder-offset-settings.md)

## Goal

On **money item** create/edit, user chooses how reminders behave for **this** item:

| Option | Meaning |
|--------|---------|
| **Use app default** | Follow Settings policy ([reminder-offset-settings.md](reminder-offset-settings.md)). |
| **Exact day only** | Override: only due-day 09:00. |
| **Custom range** | Override: pick subset of days-before + due day (same UI pattern as Settings, compact). |

Installment items: policy applies to **each unpaid قسط** due date (see
[installment-due-notifications.md](installment-due-notifications.md)).

## Data (`packages/local_db`)

Add to `MoneyItems` (migration + backup):

- `reminderPolicy` — `default` | `exactDay` | `customRange` (string enum)
- `reminderDaysBeforeJson` — nullable; when `customRange`, sorted ints e.g. `[3,1]`

Seed / existing rows: `default`.

## UI (`money_form_page.dart`)

Section **«یادآوری»** below due date / installment fields:

- Radio or chips: default / exact / custom.
- Custom: same offset picker as settings (reuse widget from settings if possible
  via `ui_kit` or `core` model — avoid cross-feature import; duplicate minimal UI
  in money if needed).

When user turns off notifications entirely (optional v1 toggle «بدون یادآوری»):
store policy `none` and schedule zero notices — only if cheap; else exact+empty.

## Sync

`moneyNotificationSyncProvider` reads item policy when building notices.

## i18n

`money.reminder.*` en + fa.

## Acceptance

- [ ] Default item follows settings when user changes settings later.
- [ ] Exact override ignores global range.
- [ ] Custom `[1]` + range mode fires day-before and due day for that item only.
- [ ] Backup round-trip for new fields.
- [ ] `melos run analyze && melos run test` pass.
