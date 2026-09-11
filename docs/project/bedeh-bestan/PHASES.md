# Phases

Work **one phase at a time**. After each phase: list files, how to run, **STOP**.
Do not start the next phase until the user says `next phase`.

| Phase | Status | What |
|---|---|---|
| **0** Read `devportal` `build/mms` | done | Architecture notes only |
| **1** Shell + monorepo shape | **done (this alignment)** | Melos, `features/*` packages, slang, RTL, bottom nav placeholders, agent docs |
| **2** Local data + seed | **done** | Drift in `packages/local_db`. Party / money / reminder / note. Persian seed. Home shows counts |
| **3** Money (core) | queued | List, add/edit sheet, detail (partial pay, remaining, overdue). Home: this week + who owes what. FAB بدهی/طلب |
| **4** Calendar | queued | Jalali agenda + month view. Repeats. FAB یادآوری |
| **5** Notes | queued | Title, body, tags, pin, optional link to party/money, search |
| **6** Notifications + icon | queued | Local notifications. App icon + splash. Launcher **بده‌بستان** |
| **7** Polish | queued | Motion, haptics, empty/error, contrast. Seed stays |

Out of scope v1: auth, ads, SMS, bank APIs, cloud backup, multi-user.

## Phase 3 notes (for the next agent)

- Reuse `packages/local_db` models and `AppDatabase`. Add money list / sheet / detail in `features/money` (repository + controller). Home: this week + who owes what from the same DB.
- Seed data stays. Do not add calendar/notes product UI yet.
