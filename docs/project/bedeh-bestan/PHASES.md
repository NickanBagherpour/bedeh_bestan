# Phases

Work **one phase at a time**. After each phase: list files, how to run, and **STOP**.
Do not start the next phase until the user says `next phase`.

| Phase | Status | What |
|---|---|---|
| **0** Read `devportal` `build/mms` | done | Architecture notes only |
| **1** Shell + monorepo shape | done | Melos, `features/*` packages, slang, RTL, bottom nav placeholders, agent docs |
| **2** Local data + seed | done | Drift in `packages/local_db`. Party / money / reminder / note. Persian seed |
| **3** Money (core) | done | List, add/edit, detail (partial pay). Home: this week + who owes what. FAB بدهی/طلب |
| **4** Settings | queued | Theme + locale switching. **Calendar system** for month/week bounds (not tied to language) |
| **5** Money report | queued | Simple period overview: paid so far, remaining, still to pay until period end |
| **6** Calendar | queued | Jalali-primary agenda + month view. Repeats. FAB یادآوری |
| **7** Notes | queued | Title, body, tags, pin, optional link to party/money, search |
| **8** Notifications + icon | queued | Local notifications. App icon + splash. Launcher **بده‌بستان** |
| **9** Polish | queued | Motion, haptics, empty/error, contrast. Seed stays |

Out of scope v1: auth, ads, SMS, bank APIs, cloud backup, multi-user.

---

## Locale vs calendar (do not mix)

UI language (`fa` / `en`) is **not** how month and week are calculated.

`AppSettings` already persists `themeMode`, `locale`, and `calendar` (`jalali` | `gregorian`). There is **no settings screen** yet, so users cannot change them.

| Setting | Controls | Does not control |
|---|---|---|
| Locale | slang strings, RTL/LTR | First/last day of month or week |
| Calendar | Date display **and** period math (ماه / week) | Button labels |
| Theme | light / dark / system | Dates or copy |

Default calendar stays **Jalali**. A user can run the app in English and still close the month on 31 شهریور, or run it in Persian on a Gregorian month.

---

## Phase 4 — Settings (next)

`features/settings` (`feature_settings`). Settings-like: **no** `data/` folder. Wire from AppShell (gear on Home or a settings destination). Paths only in `AppRoutes`.

**UI (en + fa):**
- Theme: light / dark / system → `appSettingsProvider.setThemeMode` (already applied in `BedeBestanApp`)
- Language: فارسی / English → `setLocale` **and** `LocaleSettings.setLocale` in the same action (today only `main.dart` sets locale at startup)
- Calendar: Jalali / Gregorian → `setCalendar`. Used by date formatters **and** by Phase 5 period bounds

Do not infer calendar from locale. Do not build notes/calendar product UI. Seed stays.

---

## Phase 5 — Money report

Reuse `packages/local_db` (Home must not import `feature_money`). Period bounds come from **settings calendar**, not locale.

**One clean overview** (Home card is enough; skip a heavy dashboard):

1. **Paid so far** this period — sum of `MoneyPayment`s whose `paidAt` falls in `[periodStart, now]` (بدهی payments vs طلب receipts as two numbers, same card).
2. **Remaining** — open بدهی `remainingAmount` (what I still owe, any due date).
3. **Still to pay until period end** — open بدهی whose `nextDueDate` is in `[today, periodEnd]` (from now to end of this Jalali or Gregorian month).

`periodStart` / `periodEnd` = first and last instant of the current month in the chosen calendar. Keep week math in `core` date helpers if Home “this week” should honor the same setting later.

No charts in v1. Seed stays. No calendar/notes product UI.

---

## Phase 6 notes (calendar)

- Jalali-primary agenda + simple month view in `features/calendar`. Repeats already exist on `Reminder`. FAB یادآوری.
- Honor the **calendar setting** for the grid; language stays separate.
- Money UI and report stay as-is. Seed stays.
