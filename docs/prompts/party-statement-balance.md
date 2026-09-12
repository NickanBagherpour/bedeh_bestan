# Feature: party statement with net balance + running ledger

**Package:** `features/money`
**Type:** feature
**Priority:** P1 (directly fixes the #1 recurring competitor review complaint:
«مانده حساب رو بعد از هر تراکنش نشون نمیده، فقط آخرین مانده رو میاره»)

## Read first

- `docs/AGENTS.md`
- `docs/architecture/03-feature-anatomy.md`

## Why

`party_detail_page.dart` today lists linked account titles with no amounts and no
overall balance. Reviewers of rival apps specifically ask for **a per-party net
balance** and **a running balance after each transaction**.

## Behavior (`features/money`, no new tables)

Compute everything from existing `MoneyItem` + `MoneyPayment` data (via
`money_query.dart` helpers — keep the math in a pure, unit-tested function).

1. **Net summary** on `party_detail_page.dart`: one line showing the party's net
   position — total طلب (they owe me) minus total بدهی (I owe them) across all
   their accounts, using `AppCurrency` + `groupAmount` formatting and the existing
   طلب/بدهی color tokens (`money_style.dart`).
2. **Per-account rows**: show each linked account's remaining amount and
   direction, not just the title.
3. **Running-balance ledger**: a chronological list of all payments/receipts for
   the party (across accounts, sorted by `paidAt`), each row showing the amount,
   date (Jalali per calendar setting), and the **running balance** after that entry.

## i18n

New strings in `money_en.i18n.json` + `money_fa.i18n.json`; `melos run translations`.

## Acceptance

- [ ] Party detail shows correct net balance and per-account amounts.
- [ ] Ledger shows a running balance that matches manual calculation.
- [ ] Pure balance helper covered by a unit test in `features/money/test/`.
- [ ] `melos run analyze && melos run test` pass.
