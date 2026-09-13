# Feature: quick pay / receive from home due rows

**Package:** `features/home` + `features/money` (controller/repository via provider)
**Type:** UX improvement
**Pairs with:** [installment-row-settle.md](installment-row-settle.md) (same payment rules)

## Goal

On **home** due lists (`overdue`, `dueThisWeek`, future `dueThisMonth`), each row
gets a small **Pay** / **Receive** button (direction-aware) that records one
payment without opening the detail page.

## Behavior

1. Amount: same as installment prefill rules — قسطی → one قسط amount capped by
   remaining; one-time → **remaining** (full settle) in v1.
2. Tap → `showKitConfirmDialog` (amount + title) → call money repository /
   detail controller pattern via a thin `home_quick_pay` helper or shared
   `recordQuickPayment(itemId)` on a home-scoped notifier.
3. On success: refresh home dashboard + haptic; row disappears if settled.
4. Button hidden when settled; disabled while in-flight.

## Architecture

- Page watches `homeControllerProvider`; payment goes through repository in
  `feature_home` data layer OR delegate to existing `moneyRepositoryProvider`
  from `core`/money export — **no** cross-feature widget imports; prefer
  `packages/local_db` + shared provider defined in app or money package public API.

## i18n

`quickPay`, `quickReceive`, confirm strings (en + fa).

## Acceptance

- [ ] Quick pay on week list updates DB and UI.
- [ ] Installment item pays one قسط, not full loan (unless last قسط).
- [ ] `melos run analyze && melos run test` pass.
