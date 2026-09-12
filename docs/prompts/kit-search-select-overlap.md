# Fix: KitSearchSelect label / placeholder overlap

**Package:** `packages/ui_kit`  
**Type:** bug fix

## Read first

- `docs/AGENTS.md`
- `docs/architecture/08-i18n-theming.md`

## Problem

In forms using `KitSearchSelect` (e.g. `features/notes/.../note_form_page.dart`, `features/money/.../money_form_page.dart`), the field **label** and empty-state **placeholder** text overlap (including RTL / fa).

## Where

- `packages/ui_kit/lib/src/widgets/kit_search_select.dart`
- Tests: `packages/ui_kit/test/kit_search_select_test.dart`

## Expected fix

- Empty value: clear label + hint/placeholder, no visual overlap (LTR and RTL).
- Selected value: label + value readable.
- Use Material `InputDecoration` patterns (`hintText`, `floatingLabelBehavior`, etc.) instead of duplicating placeholder text inside the decorator child when that causes collision.
- Match existing `AppSpacing` / theme.

## Acceptance

- [ ] Manual check on a notes or money form (empty + selected).
- [ ] Widget test updated or extended.
- [ ] `melos run analyze && melos run test` pass.
