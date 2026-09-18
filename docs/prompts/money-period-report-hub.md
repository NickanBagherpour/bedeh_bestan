# Feature: money period report (filtered overview)

**Package:** `features/money` (or new `features/reports` if it grows)
**Type:** feature
**Route:** add `AppRoutes.moneyReports` (or under profile); entry from Home hero
or Money tab app bar.

## Goal

A dedicated **report screen** for «این ماه چطور بود؟» with user-chosen filters
and a clear summary + optional detail breakdown.

## Filters (defaults)

| Filter | Default | Notes |
|--------|---------|--------|
| From date | First day of **current month** (Jalali/Gregorian per settings) | Inclusive |
| To date | Last day of same month | Inclusive |
| Party | **All** | Optional single party |
| Direction | All / pay only / receive only | Optional |
| Status | All / open / settled in period | Optional v2 |

Reuse date pickers and party search patterns from money/settings.

## Summary blocks (top of screen)

For the selected period:

1. **Due in period** — total pay vs receive still expected by period end
   (same semantics as `HomePeriodReport.duePayByPeriodEnd` /
   `dueReceiveByPeriodEnd`, but for arbitrary range).
2. **Settled in period** — sum of `MoneyPayment` rows with `paidAt` in range,
   split pay-out vs receive-in.
3. **Remaining (open items)** — global or party-scoped open balances (label
   clearly as «همهٔ بدهی‌های باز», not only the period).
4. **Assets snapshot** — sum of `AssetAccounts.balance` (manual assets under
   profile); optional line «دارایی خالص تقریبی» = assets − net debt if product
   agrees on formula.
5. **Net with parties** — optional: top parties by absolute balance in period.

## Detail sections (scroll below)

- **By item:** list money items with due date in range (pay/receive, party,
  suggested قسط or remaining, status).
- **By party:** aggregate pay/receive remaining per party (like home balances
  but scoped).
- **Payments log:** chronological list of payments in range (amount, item title,
  party, date).

## Data

- Pure functions in `features/money/lib/src/application/` (or shared `core` date
  helpers) — query `AppDatabase`: `listMoneyItems`, payments in range, parties,
  asset accounts.
- No new tables in v1; derive from existing models.
- Tests for range boundaries (Jalali month edges, partial payments).

## i18n

`money.reports.*` en + fa; run `melos run translations`.

## Out of scope (v1)

- PDF export (see [money-report-share.md](money-report-share.md) for share text).
- Charts; bank SMS.

## Acceptance

- [ ] Defaults match current calendar month; user can change range and party.
- [ ] Summary numbers match unit tests for a fixed fixture DB.
- [ ] Assets + open debt lines visible when data exists.
- [ ] `melos run analyze && melos run test` pass.
