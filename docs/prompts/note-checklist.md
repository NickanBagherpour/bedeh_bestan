# Feature: checklists on notes

**Package:** `features/notes` + `packages/local_db`  
**Type:** feature

## Read first

- `docs/AGENTS.md`
- `docs/architecture/04-local-data.md`
- `docs/architecture/03-feature-anatomy.md`
- `docs/architecture/08-i18n-theming.md`

## Goal

Notes can include a **checklist**: multiple items with text + checked state. Persist on-device; survive restart.

Keep existing title, body, tags, pin, optional `partyId` / `moneyItemId` links.

## Data

- Extend Drift `Notes` table / `Note` model (e.g. JSON column for checklist items with stable ids, or normalized table — pick simplest maintainable approach).
- Ship a **schema migration** in `packages/local_db`; keep seed idempotent per `04-local-data.md`.

## UI (`features/notes`)

- **Form:** add/remove rows; checkbox + text per item (reorder optional).
- **Detail:** show checklist; toggle checked.
- **List:** optional compact progress (e.g. `2/5` or checked count) — keep lightweight.

Architecture: Page → Controller → Repository. Widgets without `ref`.

## i18n

New strings in `features/notes/lib/src/translations/notes_en.i18n.json` + `notes_fa.i18n.json`; `melos run translations`.

## Acceptance

- [ ] Create, edit, toggle, delete checklist items; data reloads correctly.
- [ ] Test: parsing, repository, or query-level test as appropriate.
- [ ] `melos run analyze && melos run test` pass.
