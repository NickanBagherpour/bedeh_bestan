# Feature: home «this month» + clearer period due lists

**Package:** `features/home`
**Type:** feature

## Read first

- `features/home/lib/src/application/home_dashboard.dart`
- `docs/project/bedeh-bestan/PHASES.md` (Phase 5 report semantics)

## Problem (user feedback)

- **This week** already lists **items** (`HomeDueList`), but there is no parallel
  **this month** section.
- The **month report card** emphasizes **totals** (paid out/in, still owe globally,
  due by period end) — users want to see **which accounts** to pay or collect
  **in the period**, not only aggregate numbers.
- Totals like `remainingPay` sum **all** open بدهی everywhere, which can feel
  disconnected from «this month».

## Goal

1. Add **`dueThisMonth`**: unsettled items whose `nextDueDate` falls in the
   current month per **calendar setting** (same bounds as `buildHomePeriodReport`).
   Exclude items already shown in `overdue` (or show overdue only in overdue section).
2. Render with existing `HomeDueList` (or shared row widget) — **per item**:
   title, party, direction, **remaining or قسط amount**, due date, status.
3. **Report card copy/clarity (light touch):**
   - Keep the four metrics but label them clearly as **month activity** vs **all open debt**.
   - Optional subtitle on card: period range (Jalali/Gregorian per settings).

## Data

- Extend `HomeDashboard` + `buildHomeDashboard` with `dueThisMonth` list.
- Pure helpers + tests in `features/home/test/` (sort by due date).

## Out of scope

- Replacing the report card with only lists (keep both: summary + lists).

## i18n

`dueThisMonth` section title; clarify report captions if changed (en + fa).

## Acceptance

- [ ] Month section lists correct items for Jalali and Gregorian settings.
- [ ] Week + month sections show items, not party-level totals.
- [ ] `melos run analyze && melos run test` pass.
