# Feature: link to party detail from money screens

**Package:** `features/money`
**Type:** UX improvement

## Read first

- `docs/AGENTS.md`
- `packages/core/lib/src/router/app_routes.dart` — `AppRoutes.partyItemPath`

## Goal

From حساب (money), users can jump to a طرف حساب’s **party detail** in one tap
without hunting the parties list.

## Surfaces

1. **`money_detail_page.dart`** — party name in the header card is tappable
   (link style: primary color + optional `Icons.chevron_right` or person icon).
   `context.push(AppRoutes.partyItemPath(item.partyId))`.
2. **`money_item_tile.dart` + `money_page.dart`** — party subtitle gets its own
   tap target (e.g. `GestureDetector` / small icon button) so it does **not**
   steal the tile’s main `onTap` (which still opens the money item). Pass
   `partyId` + `onPartyTap` into the tile.
3. **`money_form_page.dart` (edit mode only)** — when an existing party is
   selected, show a compact «مشاهده طرف حساب» / «View party» text button that
   opens party detail (optional: push and return keeps form state).

## Constraints

- Widgets stay dumb where possible: page passes callbacks into tiles.
- Missing party id: hide link.

## i18n

`viewParty` (and optional `partyLink` a11y label) in en + fa.

## Acceptance

- [x] Money detail party name opens correct party overlay.
- [x] List party line opens party without opening the money item.
- [x] Edit form link works when `partyId` is set.
- [x] `melos run analyze && melos run test` pass.

## Implementation notes

- Detail header: tappable party name → `AppRoutes.partyItemPath`.
- List tile: `onPartyTap` + person icon (does not steal item `onTap`).
- Edit form: `viewParty` text button when an existing party is selected.
- i18n `viewParty` / `partyLink`.
