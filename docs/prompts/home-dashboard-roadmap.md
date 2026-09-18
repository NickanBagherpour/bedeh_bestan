# Roadmap: Home + reminders v2 (brainstorm → implementation order)

**Not a single chat task.** Use the linked specs one per Cursor chat.

## Theme

Turn home into an **actionable dashboard**: what to pay/collect **this week /
this month**, how much already **settled**, who owes whom (without endless scroll),
and stronger **قسط reminders** with optional **pay from notification**.

## Suggested order

| Phase | Spec | Why first |
|-------|------|-----------|
| A | [home-collapsible-sections.md](home-collapsible-sections.md) | Quick win; unblocks long who-owes lists |
| B | [home-period-due-lists.md](home-period-due-lists.md) + [home-month-settled-remaining.md](home-month-settled-remaining.md) | Correct mental model (items + month stats) |
| C | [home-quick-pay.md](home-quick-pay.md) | Pay from lists after lists are right |
| D0 | [reminder-offset-settings.md](reminder-offset-settings.md) + [money-item-reminder-override.md](money-item-reminder-override.md) | Configurable exact vs range offsets |
| D | [installment-due-notifications.md](installment-due-notifications.md) | Per-قسط notices using policy |
| E | [money-notification-actions.md](money-notification-actions.md) | Harder; depends on D + payment path |
| P | [profile-nav-hub.md](profile-nav-hub.md) | Profile menu (before assets UI) |
| F | [manual-assets-net-worth.md](manual-assets-net-worth.md) | Assets under profile |

## Already on home today (do not duplicate)

- `HomeReportCard` — month payments + global remaining + due by month end.
- `dueThisWeek` + `overdue` item lists.
- `HomeBalancesCard` — per-party pay/receive totals.

## Cross-links

- Money UX: [installment-row-settle.md](installment-row-settle.md) shares payment
  rules with [home-quick-pay.md](home-quick-pay.md).
- Notifications: [money-due-notifications.md](money-due-notifications.md) is done;
  installment offsets and actions extend it.

## Out of scope (unchanged)

Bank SMS, online sync, automatic bank balances.
