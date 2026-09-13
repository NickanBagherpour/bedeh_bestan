# UX: collapse long installment schedule on money detail

**Package:** `features/money`
**Type:** UX improvement
**Depends on:** [installment-schedule.md](installment-schedule.md)

## Problem

When `installmentCount` is large, listing every `InstallmentRow` pushes the
**record payment** field to the bottom of a long scroll. Users want quick access
to pay the current قسط.

## Behavior (`money_detail_page.dart`)

**Threshold:** when the schedule has **more than 5** rows, use collapsed mode by
default. Smaller schedules keep today’s full list (no toggle).

**Collapsed (default when threshold met):**

- **Paid قسط‌ها:** one compact summary line (e.g. «۵ قسط پرداخت‌شده») — not
  individual cards.
- **Unpaid:** show at most the **next 5** unpaid rows (due + upcoming), in order.
- **Expand control:** text button «نمایش همه قسط‌ها» / «Show all installments»
  toggles to full list (all rows as today).
- **Collapse** again when expanded («جمع‌کردن»).

**Expanded:** current behavior — every row as a card.

Keep progress header (`۳/۱۲`, remaining) unchanged above the list.

## Implementation notes

- Pure helper optional: `visibleInstallmentRows(rows, {expanded})` in
  `money_query.dart` for unit tests.
- Local `StatefulWidget` or page state flag `_scheduleExpanded`.

## i18n

`scheduleShowAll`, `scheduleCollapse`, `schedulePaidSummary(count: …)` in en + fa.

## Acceptance

- [x] Item with ≤5 قسط: full list, no expand UI.
- [x] Item with >5 قسط: collapsed by default; payment section reachable with minimal scroll.
- [x] Expand shows all rows; collapse restores summary + top 5 unpaid.
- [x] `melos run analyze && melos run test` pass.

## Implementation notes

- Pure helper `visibleInstallmentRows(rows, {expanded})` in `money_query.dart`
  (threshold 5). Collapsed: omit paid rows, cap unpaid at 5.
- Page flag `_scheduleExpanded`; i18n `scheduleShowAll` / `scheduleCollapse` /
  `schedulePaidSummary`. Tests in `installment_schedule_test.dart`.
