# Work backlog (agent specs)

One **task per chat**. Point the agent at a single spec file below.

| Status | Task | Spec |
|--------|------|------|
| done | Searchable dropdown label/placeholder overlap | [kit-search-select-overlap.md](kit-search-select-overlap.md) |
| done | Pre-fill payment amount for قسطی items | [installment-payment-prefill.md](installment-payment-prefill.md) |
| done | Note checklists | [note-checklist.md](note-checklist.md) |

## Growth backlog (informed by Bazaar / Myket reviews)

Prioritised from real user reviews and competitor feature lists on
[cafebazaar.ir](https://cafebazaar.ir/) and [myket.ir](https://myket.ir/) for
this category (دفتر حساب / طلب و بدهی / حسابداری شخصی / اقساط). Do the P1 items
first — they close the biggest gaps against rivals while staying local-only.

| Priority | Status | Task | Spec |
|----------|--------|------|------|
| P1 | todo | Party contact info + bank card (call / copy card) | [party-contact-card.md](party-contact-card.md) |
| P1 | todo | Party net balance + running-balance ledger | [party-statement-balance.md](party-statement-balance.md) |
| P2 | done | Shareable statement / report (text, then PDF) | [money-report-share.md](money-report-share.md) |
| P2 | done | Due-date notifications for money items | [money-due-notifications.md](money-due-notifications.md) |
| P3 | todo | Attach receipt photo to a transaction | [transaction-receipt-photo.md](transaction-receipt-photo.md) |
| P3 | done | Installment (قسطی) schedule view | [installment-schedule.md](installment-schedule.md) |

**Positioning note (not a code task):** rivals lock backup and core features
behind steep paywalls (reviewers cite «اشتراک ماهیانه ۳۰ هزار تومان» and
«۵۰۰ هزار تومان»). BedeBestan is fully local and already ships free
export/import backup — lead with **free, private, no-subscription, offline** in
the store listing to convert those frustrated reviewers.

**Deliberately out of scope** (conflicts with the local-only, no-backend rule):
cloud/online backup, reading bank SMS, and bank-API sync. The existing on-device
file backup in Settings covers the “don’t lose my data when I change phones”
need without a server.

After shipping: set **Status** to `done` and note the commit or PR in the spec file if helpful.

Other templates:

- New feature package: [new-feature.md](new-feature.md)
- How to open a Cursor chat: [new-chat.md](new-chat.md)
