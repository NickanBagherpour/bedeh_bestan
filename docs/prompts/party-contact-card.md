# Feature: party contact info + bank card

**Package:** `features/money` + `packages/local_db`
**Type:** feature
**Priority:** P1 (most-requested competitor feature; nearly every Bazaar/Myket
rival stores «شماره تلفن» + «شماره کارت/حساب» per طرف حساب)

## Read first

- `docs/AGENTS.md`
- `docs/architecture/04-local-data.md`
- `docs/architecture/03-feature-anatomy.md`
- `docs/architecture/08-i18n-theming.md`

## Why

Competitor «دفتر حساب» / «دفتر بدهی و طلب» apps let you store a party's phone
and card number, then call or copy the card in one tap. Reviewers treat it as a
baseline. Today `Parties` holds only `name / kind / note`.

## Data (`packages/local_db`)

- Add nullable `phone`,`nationalCode`,`birthDate` and `cardNumber` (and optionally `sheba`) `TextColumn`s to
  the `Parties` table + `Party` model.
- Ship a **schema migration**; keep the Persian seed idempotent per `04-local-data.md`.
- Extend `backup.dart` (`_partyJson` / `_partyFrom`) so the new fields round-trip
  and older backups still import (null defaults).

## UI (`features/money`)

- **`party_form_page.dart`:** add phone + card fields (numeric keyboard,
  optional). Keep validation lenient — free text, trimmed.
- **`party_detail_page.dart`:** show phone + card in the header card with quick
  actions:
  - tap-to-call via a `tel:` intent (`url_launcher`, already a common dep — check
    `pubspec`; add to `feature_money` if missing),
  - copy card number to clipboard (`Clipboard.setData`) with a confirmation snackbar,
  - **no** background SMS/auto-dial (respects the “no SMS/backend” rule — the user
    initiates every action).

## i18n

New strings in `features/money/lib/src/translations/money_en.i18n.json` +
`money_fa.i18n.json`; `melos run translations`.

## Acceptance

- [ ] Create/edit a party with phone + card; values persist and survive restart.
- [ ] Detail shows call + copy actions; copy shows confirmation.
- [ ] Old backup (without the fields) imports without error.
- [ ] `melos run analyze && melos run test` pass.
