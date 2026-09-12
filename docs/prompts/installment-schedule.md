# Feature: installment (قسطی) schedule view

**Package:** `features/money`
**Type:** feature / UX improvement
**Priority:** P3 (builds on existing قسطی support + `installment-payment-prefill`;
«دفترچه اقساط» style tracking is a popular niche on Bazaar/Myket)

## Read first

- `docs/AGENTS.md`
- `docs/prompts/installment-payment-prefill.md` (existing قسطی behavior)

## Why

Items with `schedule == installment` store `installmentAmount`,
`installmentCount`, `periodsPaid`, `startDate`, `nextDueDate`. Today the user sees
totals but not the **schedule** — which قسط is due when, and which are paid.
Loan/installment trackers on the stores make this the headline view.

## Behavior (`features/money`, no new tables)

- On `money_detail_page.dart` for installment items, show a computed schedule:
  one row per installment with its due date (derived from `startDate` +
  period index, shown in the calendar setting) and a paid / due / upcoming state
  derived from `periodsPaid` and recorded `MoneyPayment`s.
- Show a compact progress indicator (e.g. `۳/۱۲` and remaining amount).
- Keep the schedule generation in a pure helper in `money_query.dart` with unit
  tests (reuse period-shift helpers from `core` `date_utils` where possible).

## Out of scope

- Changing how installment totals are entered on the form (unless required).
- Per-installment custom amounts/dates (assume equal installments for v1).

## i18n

New strings in `money_en.i18n.json` + `money_fa.i18n.json`; `melos run translations`.

## Acceptance

- [ ] Installment item shows a correct per-قسط schedule with paid/due states.
- [ ] Progress (paid/total + remaining) matches the ledger.
- [ ] Schedule helper covered by a unit test in `features/money/test/`.
- [ ] `melos run analyze && melos run test` pass.
