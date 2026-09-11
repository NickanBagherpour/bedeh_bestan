# Phases

Work **one phase at a time**. After each phase: list files, how to run, and **STOP**.
Do not start the next phase until the user says `next phase`.

| Phase | Status | What |
|---|---|---|
| **0** Read `devportal` `build/mms` | done | Architecture notes only |
| **1** Shell + monorepo shape | done | Melos, `features/*` packages, slang, RTL, bottom nav placeholders, agent docs |
| **2** Local data + seed | done | Drift in `packages/local_db`. Party / money / reminder / note. Persian seed |
| **3** Money (core) | done | List, add/edit, detail (partial pay). Home: this week + who owes what. FAB بدهی/طلب |
| **4** Settings | **done** | Theme + locale switching. Calendar system for month/week bounds (not tied to language) |
| **5** Money report | **done** | Home card: paid so far, remaining بدهی, still to pay until month end |
| **6** Calendar | queued | Jalali-primary agenda + month view. Repeats. FAB یادآوری |
| **7** Notes | queued | Title, body, tags, pin, optional link to party/money, search |
| **8** Notifications + icon | queued | Local notifications. App icon + splash. Launcher **بده‌بستان** |
| **9** Polish | queued | Motion, haptics, empty/error, contrast. Seed stays |

Out of scope v1: auth, ads, SMS, bank APIs, cloud backup, multi-user.

---

## Locale vs calendar (do not mix)

UI language (`fa` / `en`) is **not** how month and week are calculated.

`AppSettings` persists `themeMode`, `locale`, `calendar` (`jalali` | `gregorian`), and `currency` (`toman` | `rial` | `usd`). Calendar is **not** inferred from language. Currency defaults with language (fa → تومان, en → Dollar) but the user can pick independently.

| Setting | Controls | Does not control |
|---|---|---|
| Locale | slang strings, RTL/LTR | First/last day of month or week |
| Calendar | Date display **and** period math (ماه / week) | Button labels |
| Currency | Amount label + ریال ×10 display | FX conversion |
| Theme | light / dark / system | Dates or copy |

Default calendar stays **Jalali**. A user can run the app in English and still close the month on 31 شهریور, or run it in Persian on a Gregorian month.

---

## Phase 4 — Settings (done)

`features/settings`. Overlay at `AppRoutes.settings`. Gear on Home. Theme / language / calendar / currency chips. `setLocale` also updates slang.

---

## Phase 5 — Money report (done)

Home card on `features/home`. Period bounds from **settings calendar**, not locale.

1. **Paid so far** this period — sum of `MoneyPayment`s whose `paidAt` falls in `[periodStart, now]` (بدهی payments vs طلب receipts as two numbers, same card).
2. **Remaining** — open بدهی `remainingAmount` (what I still owe, any due date).
3. **Still to pay until period end** — open بدهی whose `nextDueDate` is in `[today, periodEnd]`.

`periodStart` / `periodEnd` = first and last day of the current month in the chosen calendar. Week helpers live in `core` `date_utils` (`weekBounds`) for later use; Home “this week” is still a rolling seven days.

No charts in v1. Seed stays. No calendar/notes product UI.

---

## Phase 6 notes (calendar)

- Jalali-primary agenda + simple month view in `features/calendar`. Repeats already exist on `Reminder`. FAB یادآوری.
- Honor the **calendar setting** for the grid; language stays separate.
- Money UI and report stay as-is. Seed stays.
