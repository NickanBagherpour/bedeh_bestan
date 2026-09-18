# Work backlog (agent specs)

One **task per chat**. Point the agent at a single spec file.

Shipped work (home dashboard v2, notifications, profile, assets, money UX polish)
is documented under `docs/prompts/*.md`; use git history for what landed when.

## Open tasks (priority order)

| Priority | Status | Task | Spec |
|----------|--------|------|------|
| P1 | todo | Party net balance + running-balance ledger | [party-statement-balance.md](party-statement-balance.md) |
| P1 | todo | Money period report (date range, party, month overview) | [money-period-report-hub.md](money-period-report-hub.md) |
| P2 | todo | Per-installment custom amounts (swipe/edit schedule) | [installment-variable-amounts.md](installment-variable-amounts.md) |
| P3 | todo | Attach receipt photo to a transaction | [transaction-receipt-photo.md](transaction-receipt-photo.md) |
| — | todo | Auth-gate profile routes when login exists | [future-profile-auth-gate.md](future-profile-auth-gate.md) |

## Reference (not scheduled)

- Home due lists (معوق / این هفته / سررسید این ماه): [home-period-due-lists.md](home-period-due-lists.md)
  — week = **شنبه–جمعه**; month = calendar month **excluding** this week.
- Home + reminders roadmap order: [home-dashboard-roadmap.md](home-dashboard-roadmap.md)
- Growth / competitor notes: see archived specs
  (`party-contact-card.md`, `money-due-notifications.md`, …) — all shipped.

**Positioning (store listing, not code):** local-only, free backup, no subscription,
offline — vs Bazaar/Myket paywalled rivals.

**Out of scope:** cloud sync, bank SMS, bank APIs.

After shipping: set **Status** to `done` in this table.

Templates: [new-feature.md](new-feature.md) · [new-chat.md](new-chat.md)
