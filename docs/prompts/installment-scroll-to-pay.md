# UX: sticky / jump to payment on installment detail

**Package:** `features/money`
**Type:** UX improvement (optional; ship after schedule collapse if still needed)

## Why

Even with a collapsed schedule, some users may expand the full list. A **floating
action** or header chip «ثبت پرداخت» that scrolls to the payment `TextField`
reduces friction (pairs well with [installment-row-settle.md](installment-row-settle.md)).

## Behavior

- On `money_detail_page.dart` for unsettled installment items only: show a
  secondary control in the schedule header row (or `FloatingActionButton.small`)
  that `Scrollable.ensureVisible` on the payment section key.
- Hide when item is settled.

## i18n

`jumpToPayment` in en + fa.

## Acceptance

- [x] Tap scrolls payment field into view with keyboard-friendly padding.
- [x] No control when settled or non-installment.
- [x] `melos run analyze && melos run test` pass.

## Implementation notes

- Unsettled installment schedule header has `jumpToPayment`; scrolls to a
  keyed payment section via `Scrollable.ensureVisible`. Hidden when settled.
