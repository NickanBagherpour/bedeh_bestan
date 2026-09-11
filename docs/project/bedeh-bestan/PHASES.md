# Phases

Work **one phase at a time**. After each phase: list files, how to run, **STOP**.
Do not start the next phase until the user says `next phase`.

| Phase | Status | What |
|---|---|---|
| **0** Read `devportal` `build/mms` | done | Architecture notes only |
| **1** Shell + monorepo shape | **done (this alignment)** | Melos, `features/*` packages, slang, RTL, bottom nav placeholders, agent docs |
| **2** Local data + seed | next | On-device DB (Drift preferred). Models: party, money item, reminder, note. Persian seed. Minimal UI to verify |
| **3** Money (core) | queued | List, add/edit sheet, detail (partial pay, remaining, overdue). Home: this week + who owes what. FAB بدهی/طلب |
| **4** Calendar | queued | Jalali agenda + month view. Repeats. FAB یادآوری |
| **5** Notes | queued | Title, body, tags, pin, optional link to party/money, search |
| **6** Notifications + icon | queued | Local notifications. App icon + splash. Launcher **بده‌بستان** |
| **7** Polish | queued | Motion, haptics, empty/error, contrast. Seed stays |

Out of scope v1: auth, ads, SMS, bank APIs, cloud backup, multi-user.

## Phase 2 notes (for the next agent)

- Keep MMS layering: entities in the **owning feature**, shared schema may live in `packages/core` or a small `packages/local_db` if several features share tables.
- Seed Persian demo data so Home can look alive in Phase 3.
- No calendar/notes product UI in Phase 2 beyond what is needed to prove the DB.
