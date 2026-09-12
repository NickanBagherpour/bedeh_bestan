# Feature: pre-fill payment amount for قسطی (installment) items

**Package:** `features/money`  
**Type:** UX improvement

## Read first

- `docs/AGENTS.md`
- `docs/architecture/04-local-data.md` (MoneyItem fields only)

## Context

- Installment loans store `installmentAmount`, `installmentCount`, `schedule == MoneySchedule.installment` (see `money_form_page.dart`).
- Recording payment: `features/money/lib/src/presentation/pages/money_detail_page.dart` — `_amount` is empty today; `money_detail_controller.recordPayment`.

## Behavior

1. When detail page shows an **unsettled** item with `schedule == installment` and `installmentAmount != null`:
   - Pre-fill the payment `TextField` with that installment amount (same formatting as elsewhere: `AppCurrency`, `GroupedAmountFormatter`, `groupAmount`).
   - If remaining balance is less than one installment, pre-fill **remaining** (cap at `remainingAmount`).
2. User **can edit** the field before pay/receive.
3. After successful payment, if still unsettled, pre-fill again for the next قسط (same rules).
4. **One-time** / non-installment items: unchanged (no forced pre-fill).

## Out of scope

- Changing how totals are computed on the create/edit form unless required for this flow.

## i18n

Reuse existing `money.paymentAmount` unless new copy is needed (then en + fa + `melos run translations`).

## Acceptance

- [x] Seeded or manual installment item opens with suggested amount in the field.
- [x] User can change amount; payment persists correctly.
- [x] `melos run analyze && melos run test` pass.

## Implementation notes

- Pure helper `installmentPrefillAmount` in `features/money/lib/src/application/money_query.dart`
  (per-قسط amount capped at the remaining balance; `null` for one-time / settled / no-amount).
- `money_detail_page.dart` calls it via `_syncPrefill`, tracking the remaining
  balance so it fills on load and re-fills after each payment without
  clobbering user edits. Non-installment items stay untouched.
- Unit tests: `features/money/test/installment_prefill_test.dart`.
