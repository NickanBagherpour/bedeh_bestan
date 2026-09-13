# UX: copy buttons for all party detail fields

**Package:** `features/money`
**Type:** UX improvement

## Read first

- `party_detail_page.dart` — `_contactRow`, `_copy`, `_call`

## Goal

Every stored party field that users paste elsewhere (phone, card, شبا, کد ملی,
تاریخ تولد, یادداشت) should have an easy **copy** action with confirmation
snackbar (reuse `t.money.copyAction` / existing `_copy`).

## Current gap

- Card + شبا: copy ✓
- Phone: call only — add **copy** (second icon or long-press; prefer two icon
  buttons: call + copy).
- کد ملی, تاریخ تولد: no actions — add copy.
- **Note:** optional copy icon for multi-line note.

## Behavior

- Extend `_contactRow` to support **multiple trailing actions** (list of
  `{icon, tooltip, onPressed}`) or a dedicated `onCopy` alongside `onAction`.
- Copy strips nothing except trim; phone/card/sheba keep LTR `textDirection` on
  value.
- Empty fields: unchanged (row hidden).

## Optional follow-up (same spec if small)

- Copy **party name** from app bar overflow menu — low priority; skip unless trivial.

## i18n

Reuse `copyAction`, `copiedToClipboard` (or existing snackbar string). Add only if missing.

## Acceptance

- [x] Phone: call + copy both work.
- [x] National code, birth date, note: copy with snackbar.
- [x] Card/sheba behavior unchanged.
- [x] `melos run analyze && melos run test` pass.

## Implementation notes

- `_contactRow` takes a list of trailing actions. Phone: call + copy; کد ملی,
  birth date, note: copy. Reuses `copyAction` / `copied`.
