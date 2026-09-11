# Phases

Work **one phase at a time**. After each phase: list files, how to run, **STOP**.
Do not start the next phase until the user says `next phase`.

| Phase | Status | What |
|---|---|---|
| **0** Read `devportal` `build/mms` | done | Architecture notes only |
| **1** Shell + monorepo shape | **done (this alignment)** | Melos, `features/*` packages, slang, RTL, bottom nav placeholders, agent docs |
| **2** Local data + seed | **done** | Drift in `packages/local_db`. Party / money / reminder / note. Persian seed. Home shows counts |
| **3** Money (core) | **done** | List, add/edit, detail (partial pay). Home: this week + who owes what. FAB بدهی/طلب |
| **4** Calendar | queued | Jalali agenda + month view. Repeats. FAB یادآوری |
| **5** Notes | queued | Title, body, tags, pin, optional link to party/money, search |
| **6** Notifications + icon | queued | Local notifications. App icon + splash. Launcher **بده‌بستان** |
| **7** Polish | queued | Motion, haptics, empty/error, contrast. Seed stays |

Out of scope v1: auth, ads, SMS, bank APIs, cloud backup, multi-user.

## Phase 4 notes (for the next agent)

- Jalali-primary agenda + simple month view in `features/calendar`. Repeats already exist on `Reminder`. FAB یادآوری. Do not build notes product UI yet.
- Money UI stays as-is. Seed data stays.
