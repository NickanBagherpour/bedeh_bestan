# 04 — Local data

On-device Drift in `packages/local_db`. No HTTP. Shared by features (Home must not import `feature_money`).

```
packages/local_db/
  models/     Party, MoneyItem, Reminder, Note, enums, LibrarySnapshot
  database/   Drift tables, AppDatabase, seedDemoData
  memory.dart test-only in-memory opener (not exported from the barrel)
```

- Open in `apps/bedeh_bestan/lib/main.dart` **before** `runApp`. Demo seed
  is **dev-only** (`flutter run --dart-define=SEED_DEMO=true`). Store builds
  call `retireDemoSeed` so leftover demo rows (Ali, بانک ملی, …) are removed;
  user-created rows stay.
- Override `appDatabaseProvider`.
- File lives in the app documents directory (`bedeh_bestan.sqlite`). **App
  updates keep it.** Uninstall / changing the application id starts empty.
  Schema bumps use `onUpgrade` + `CREATE TABLE IF NOT EXISTS` — they must not
  drop user tables. Export / restore is in Settings.
- Chrome / web: `AppDatabase.open()` passes `DriftWebOptions`. The compiled
  `sqlite3.wasm` and `drift_worker.js` live in `apps/bedeh_bestan/web/` and
  must match the `drift` version in `pubspec.lock` (download from the
  matching [Drift GitHub release](https://github.com/simolus3/drift/releases)).
  Native platforms ignore those files.
- Seed is idempotent (`meta.seed.version`). Tests call `seedDemoData` themselves.
- Money **status** is derived (`MoneyItem.statusOn`) from due date + remaining, not a stored column.
- Feature repositories wrap `AppDatabase`; pages never touch Drift.
- Money writes: `upsertParty`, `upsertMoneyItem`, `deleteMoneyItem`, `recordPayment` (partial pay + installment period advance).

Tests: `packages/local_db/test/seed_test.dart`. After schema edits:  
`cd packages/local_db && dart run build_runner build --delete-conflicting-outputs`
