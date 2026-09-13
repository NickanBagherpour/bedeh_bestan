# Feature: month cashflow snapshot (settled vs still due in period)

**Package:** `features/home`
**Type:** feature / UX
**Pairs with:** [home-period-due-lists.md](home-period-due-lists.md)

## Goal

Give a clear **month view** of money movement:

| Metric | Meaning |
|--------|---------|
| **Settled out** | Sum of بدهی **payments** in current month (already `paidOut` in report). |
| **Settled in** | Sum of طلب **receipts** in current month (`paidIn`). |
| **Still due this month** | Open items with `nextDueDate` in `[monthStart, monthEnd]` — sum of
  `remainingAmount` split by pay vs receive (or single «to pay by month end»). |
| **Remaining open (all time)** | Optional second line: total open بدهی/طلب (today’s `remainingPay` + receive side if added). |

## UI

- Extend `HomeReportCard` or add a compact **«این ماه»** sub-card with 2–4 chips /
  rows (settled pay, settled receive, due in month, remaining open).
- Use existing `HomePeriodReport`; extend model if receive-side «still owed to me
  this month» is missing.

## Data

- Extend `buildHomePeriodReport` to include `remainingReceive` (open طلب) and
  `dueReceiveByPeriodEnd` if useful for symmetry.
- Unit tests for month boundaries (Jalali).

## i18n

New labels distinct from global «still owe» (en + fa).

## Acceptance

- [ ] Numbers match manual calculation on seeded data.
- [ ] User can read settled vs still-due-in-month at a glance.
- [ ] `melos run analyze && melos run test` pass.
