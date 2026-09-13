# Feature: settle one قسط from the installment schedule

**Package:** `features/money`
**Type:** UX improvement
**Depends on:** [installment-schedule.md](installment-schedule.md) (schedule rows on `money_detail_page.dart`)

## Read first

- `docs/AGENTS.md`
- `docs/prompts/installment-payment-prefill.md`
- `packages/local_db` — `recordPayment` (updates `periodsPaid`, `nextDueDate`, `paidAmount`)

## Goal

On each **unpaid** schedule row (`InstallmentState.due` — the current قسط only in v1),
show a **Settle** action. User taps → confirm dialog → record that قسط’s payment
without scrolling to the bottom amount field.

## Behavior

1. **Visible control:** text button or compact `FilledButton.tonal` on the row for
   `state == due` only (not on `paid` / `upcoming` in v1 — avoids skipping ahead
   without an explicit product decision).
2. **Confirm:** `showKitConfirmDialog` with قسط index, due date, and formatted
   amount (locale + currency).
3. **Payment amount:** `min(row.amount, item.remainingAmount)` — one full قسط;
   if remaining is smaller (last odd قسط), use remaining.
4. **Persist:** call existing `moneyDetailController.recordPayment(amount)` (same
   path as the bottom form). On success: haptic confirm, refresh schedule
   (`periodsPaid` / row states update).
5. **Errors:** same snackbars as manual payment (`exceedsRemaining`, `settled`, etc.).
6. **Busy state:** disable row actions while `state.busy`.

## Out of scope

- Paying multiple upcoming قسط‌ها from one row tap.
- Custom amount on the row (user can still use the bottom field).

## i18n

`settleInstallment`, `settleInstallmentConfirm` (with params: index, amount, date)
in `money_en.i18n.json` + `money_fa.i18n.json`; `melos run translations`.

## Acceptance

- [x] Due row shows settle; paid/upcoming do not (v1).
- [x] Confirm → payment recorded; schedule and totals match DB logic.
- [x] Last قسط with partial remaining settles correctly.
- [x] `melos run analyze && melos run test` pass.

## Implementation notes

- Due-only `FilledButton.tonal` on the schedule row; confirm via
  `showKitConfirmDialog` then `recordPayment(min(row.amount, remaining))`.
- Helper `installmentRowSettleAmount` in `money_query.dart`. i18n
  `settleInstallment` / `settleInstallmentConfirm`.
