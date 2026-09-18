# Feature: home «this week» + «this month» due lists

**Package:** `features/home`
**Type:** feature (shipped; semantics below are canonical)

## Read first

- `features/home/lib/src/application/home_dashboard.dart`
- `packages/core/lib/src/utils/date_utils.dart` — `weekBounds`, `monthBounds`
- `docs/project/bedeh-bestan/PHASES.md` (Phase 5 report semantics)

## Section rules

| Section | FA | Window | Listed items |
|---------|-----|--------|----------------|
| Overdue | معوق | Due **before today**, unsettled | `MoneyStatus.overdue` only |
| This week | این هفته | **Saturday–Friday** week containing today (`weekBounds`) | Unsettled, not overdue, `nextDueDate` in that week |
| This month | سررسید این ماه | **First–last day** of current month per calendar setting (`monthBounds`) | Unsettled, not overdue, due in month, **not** already in this week |
| Who owes | کی چقدر؟ | — | Per-party open pay/receive totals |

### Why week and month do not overlap

The Iranian week (شنبه–جمعه) can **cross a month boundary** (e.g. چهارشنبه ۱ مهر still in the same week as days in شهریور). An item due on the first day of the new month may belong to **این هفته** but not **این ماه** (Gregorian/Jalali month). So month **excludes** any row already shown under this week.

### Month length

Jalali and Gregorian months use real month length (29 / 30 / 31) via `monthBounds` — not a fixed 30-day window.

## UI

- `HomeCollapsibleSection` + `HomeDueList` for overdue / week / month.
- Week subtitle: formatted `weekRange` (from–to).
- `HomeBalancesCard` for کی چقدر؟

## Acceptance

- [x] Week = Sat–Fri containing today.
- [x] Month = calendar month minus overdue minus this-week rows.
- [x] Jalali and Gregorian month boundaries tested.
- [x] `melos run analyze && melos run test` pass.
