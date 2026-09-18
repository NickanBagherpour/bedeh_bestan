# UX: tap party row on home «who owes» → party detail

**Package:** `features/home`
**Type:** UX improvement
**Pairs with:** [money-party-deep-link.md](money-party-deep-link.md)

## Goal

`HomeBalancesCard` rows are display-only today. Each party row should open
`AppRoutes.partyItemPath(partyId)` on tap (chevron optional).

## Acceptance

- [ ] Tap navigates to correct party detail.
- [ ] Collapsible section ([home-collapsible-sections.md](home-collapsible-sections.md)) still works.
- [ ] `melos run analyze && melos run test` pass.
