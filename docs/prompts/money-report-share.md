# Feature: shareable statement / report (text + PDF)

**Package:** `features/money`
**Type:** feature
**Priority:** P2 (almost every rival advertises «گزارش‌گیری PDF» / «خروجی PDF»;
we only have a JSON backup today)

## Read first

- `docs/AGENTS.md`
- `docs/architecture/08-i18n-theming.md` (RTL + Persian digits in output)

## Why

Users want to send a party a readable statement of what they owe, or keep a PDF
record. `settings_page.dart` already does file share for JSON backup — reuse the
same OS share plumbing for a human-readable report. Stays fully local (no backend).

## Behavior (`features/money`)

- Add a **share** action on `party_detail_page.dart` (and optionally
  `money_detail_page.dart`) that produces a statement for that party:
  header (name, net balance), per-account lines, and the transaction ledger.
- **Phase A — text share (ship first):** build a formatted Persian/English string
  (respect locale + calendar + currency) and hand it to the OS share sheet. Low
  risk, works on every platform including web.
- **Phase B — PDF (optional follow-up):** render the same statement to a PDF via a
  package (e.g. `pdf` + `printing`); must handle **RTL + Persian glyphs** correctly
  — verify with a real fa sample before shipping. If RTL/PDF fonts prove costly,
  ship text-only and leave PDF as a separate backlog item.

## Constraints

- No backend, no upload. Sharing = OS share sheet only.
- Formatting must go through existing `AppCurrency` / `groupAmount` and the
  calendar/locale settings, not hardcoded.

## i18n

Report labels in `money_en.i18n.json` + `money_fa.i18n.json`; `melos run translations`.

## Acceptance

- [x] Text statement shares correctly in fa (RTL) and en with right amounts/dates.
- [ ] (If PDF shipped) fa PDF renders readable RTL Persian text. — Phase B deferred
      (text-only shipped; PDF stays a separate backlog item per this spec).
- [x] `melos run analyze && melos run test` pass.

## Shipped (Phase A — text)

- `features/money`: share action on `party_detail_page.dart` app bar.
- Pure builder `application/party_statement.dart` (`buildPartyStatement` +
  `PartyStatementLabels`), unit-tested in `test/party_statement_test.dart`.
- OS share sheet via `share_plus` (`SharePlus.instance.share`).
- Amounts/dates go through `formatItemMoney` / `formatLongDate` + `toPersianDigits`,
  honouring the currency + calendar + locale settings.
- New i18n keys `money.share*` in en + fa; other labels reuse existing keys.
