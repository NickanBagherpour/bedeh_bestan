# Feature: per-installment amount overrides (قسطی)

**Package:** `features/money` + `packages/local_db`
**Type:** feature
**Depends on:** [installment-schedule.md](installment-schedule.md)

## Problem

Today installment rows are **computed** from `totalAmount`, `installmentCount`,
and optional uniform `installmentAmount`. Real loans often have **different**
قسط amounts (first payment larger, balloon, skipped month, etc.).

## Goal

When creating or editing a **قسطی** money item:

1. After user enters count / start date / default قسط amount, show generated
   schedule (existing UI).
2. Allow **editing each row’s amount** (and optionally due date) before save.
3. **UX:** swipe row → edit sheet, or tap row → inline amount field; match
   `ui_kit` patterns (confirm on destructive changes).
4. Persist overrides; `recordPayment` and `installmentSchedule()` must use stored
   rows, not only equal splits.

## Data (migration)

Option A (preferred): new table `MoneyInstallments`

| Column | Type |
|--------|------|
| id | text PK |
| moneyItemId | FK → MoneyItems |
| index | int (1-based) |
| dueDate | DateTime |
| amount | int |
| state | paid / due / future (or derive from payments) |

Option B: JSON column on `MoneyItems` (`installmentsJson`) for v1 speed — document
backup round-trip.

- If no overrides: keep current equal-split generation.
- `totalAmount` should equal sum of installment amounts (validate on save; warn
  if mismatch).

## Behaviour

- `suggestedQuickPaymentAmount()` uses **current unpaid row** amount.
- Home due lists and notifications use per-row due dates from stored schedule.
- Collapse/expand schedule on detail page unchanged.

## i18n

`money.installments.editAmount`, validation errors (en + fa).

## Acceptance

- [x] User can set قسط 3 to a different amount; save survives restart.
- [x] Payment advances correct row; remaining totals consistent.
- [x] Backup/import includes installment overrides.
- [x] `melos run analyze && melos run test` pass.

## Implementation notes

- New Drift table `MoneyInstallments` (schema v7): `id`, `moneyItemId`,
  `index` (1-based), `dueDate`, `amount`. Loaded onto `MoneyItem.installments`.
- Empty installments list → equal-split generation (legacy items unchanged).
- Form shows generated schedule; tap / swipe opens edit sheet for amount + due
  date. Total = sum of rows. Save persists via `replaceInstallmentsFor`.
- `recordPayment` consumes stored row amounts in order; `suggestedQuickPaymentAmount`
  / schedule / notifications use stored rows when present.
- Backup encodes top-level `installments` (and nested under money items).
- i18n: `money.installments.*` (en + fa).
- Tests: `packages/local_db/test/installment_variable_test.dart` + schedule
  / suggested-amount coverage.
