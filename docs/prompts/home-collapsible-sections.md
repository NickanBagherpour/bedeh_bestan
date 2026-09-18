# UX: collapsible home sections (lists inside cards)

**Package:** `features/home` + `packages/ui_kit` (optional shared widget)
**Type:** UX improvement

## Problem

Home cards with long lists — especially **who owes whom** (`HomeBalancesCard`) and
**due this week** — push important content off-screen.

## Goal

Reusable **collapsible section** pattern for any home `KitCard` that contains a list.

## Behavior

- Section header row: icon + title + **chevron**; tap toggles expanded/collapsed.
- **Collapsed:** show section title + **summary line** (e.g. «۸ طرف حساب» /
  «۳ مورد سررسید») — no list rows.
- **Expanded:** current list UI.
- Persist collapse state in memory for the session (v1); optional later:
  `SharedPreferences` per section id.
- **Defaults:**
  - `whoOwes` / balances: **collapsed** when `balances.length > 4`, else expanded.
  - `dueThisWeek`, `overdue`: expanded when `rows.length ≤ 5`, else collapsed.
  - `HomeReportCard`: always expanded (no list) — unchanged.

## Widget

- `KitCollapsibleSection` or `HomeCollapsibleCard` in `features/home` (or ui_kit
  if calendar/home will share it). Dumb widget: `title`, `summary`, `expanded`,
 `onToggle`, `child`.

## i18n

`sectionShowMore`, `sectionCollapse`, summary templates with counts (en + fa).

## Acceptance

- [ ] Long who-owes list collapses by default; expand shows all parties.
- [ ] Due lists respect threshold; toggle works.
- [ ] `melos run analyze && melos run test` pass.
