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
| P1 | done | Party contact info + bank card (call / copy card) | [party-contact-card.md](party-contact-card.md) |
| P1 | todo | Party net balance + running-balance ledger | [party-statement-balance.md](party-statement-balance.md) |
| P2 | done | Shareable statement / report (text, then PDF) | [money-report-share.md](money-report-share.md) |
| P2 | done | Due-date notifications for money items | [money-due-notifications.md](money-due-notifications.md) |
| P3 | todo | Attach receipt photo to a transaction | [transaction-receipt-photo.md](transaction-receipt-photo.md) |
| P3 | done | Installment (قسطی) schedule view | [installment-schedule.md](installment-schedule.md) |

## Money UX backlog (installments + party navigation)

User-requested polish on top of the shipped قسطی schedule and party detail.
Implement in this order when possible: collapse → row settle → party links → copy.

| Priority | Status | Task | Spec |
|----------|--------|------|------|
| — | done | Collapse long schedule (summary + top 5 unpaid; expand all) | [installment-schedule-collapse.md](installment-schedule-collapse.md) |
| — | done | Settle current قسط from schedule row (confirm → `recordPayment`) | [installment-row-settle.md](installment-row-settle.md) |
| — | done | Link to party detail from money list / detail / edit form | [money-party-deep-link.md](money-party-deep-link.md) |
| — | done | Copy icon for phone, کد ملی, birth date, note on party detail | [party-detail-copy-all.md](party-detail-copy-all.md) |
| — | done | (Optional) Jump to payment field on long installment detail | [installment-scroll-to-pay.md](installment-scroll-to-pay.md) |

**Assumptions (change in spec if you want different behaviour):**

- Row **Settle** applies only to the **current due** قسط (not future قسط‌ها).
- Collapse kicks in when there are **more than 5** installments total.

## Home + reminders v2 (dashboard brainstorm)

**Roadmap (order only):** [home-dashboard-roadmap.md](home-dashboard-roadmap.md)

| Priority | Status | Task | Spec |
|----------|--------|------|------|
| A | todo | Collapsible home list sections (who owes, due lists) | [home-collapsible-sections.md](home-collapsible-sections.md) |
| A | todo | Tap who-owes row → party detail | [home-balances-party-link.md](home-balances-party-link.md) |
| B | todo | «This month» due list + item-focused period lists | [home-period-due-lists.md](home-period-due-lists.md) |
| B | todo | Month snapshot: settled vs still due in period | [home-month-settled-remaining.md](home-month-settled-remaining.md) |
| C | todo | Quick pay/receive on home due rows | [home-quick-pay.md](home-quick-pay.md) |
| D0 | todo | Settings: reminder mode (exact day vs range) + custom offsets | [reminder-offset-settings.md](reminder-offset-settings.md) |
| D0 | todo | Money form: per-item reminder override (default / exact / custom) | [money-item-reminder-override.md](money-item-reminder-override.md) |
| D | todo | Per-قسط notices using reminder policy | [installment-due-notifications.md](installment-due-notifications.md) |
| E | todo | Notification actions: mark paid, remind tomorrow | [money-notification-actions.md](money-notification-actions.md) |
| P | todo | Profile hub nav (home entry; assets + settings links) | [profile-nav-hub.md](profile-nav-hub.md) |
| F | todo | Manual asset accounts + net worth (under profile) | [manual-assets-net-worth.md](manual-assets-net-worth.md) |

## Profile & future auth (placeholder)

| Status | Task | Spec |
|--------|------|------|
| todo | Auth-gate profile routes when login exists | [future-profile-auth-gate.md](future-profile-auth-gate.md) |

**Notes:**

- **Pay from notification** is **Android-first** in v1; iOS may need opening the app
  (see [money-notification-actions.md](money-notification-actions.md)).
- **Assets** live under **Profile**, not a fifth tab ([profile-nav-hub.md](profile-nav-hub.md)).
- Default reminder range: **7, 2, and due day** until user changes Settings.

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
