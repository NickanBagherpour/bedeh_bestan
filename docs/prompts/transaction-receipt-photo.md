# Feature: attach receipt photo to a transaction

**Package:** `features/money` + `packages/local_db`
**Type:** feature
**Priority:** P3 (rivals advertise «امکان پیوست تصویر در طلب و بدهی»; nice trust
signal, but heavier than the P1/P2 items)

## Read first

- `docs/AGENTS.md`
- `docs/architecture/04-local-data.md`

## Why

Users want a photo of a receipt / check attached to a payment so they have proof.
Fully local: store the image on-device and reference it — no upload.

## Data (`packages/local_db`)

- Add a nullable `receiptPath` (or `receiptId`) `TextColumn` to `MoneyPayments`
  (and/or `MoneyItems`). Store the copied image under the app's documents dir;
  keep only the relative path in the DB.
- Schema migration + backup round-trip (`backup.dart`). Note in the spec that a
  restored backup on a different device may not have the image bytes — store path
  only and degrade gracefully when the file is missing.

## UI (`features/money`)

- **`money_detail_page.dart`:** when recording/viewing a payment, allow picking an
  image (`image_picker`) from camera or gallery; show a thumbnail; tap to view
  full-screen; allow remove.
- Copy the picked file into app storage; never keep a transient cache path.

## Platform note

- Mobile-first. On web/desktop, hide or disable the picker gracefully (feature-
  detect); do not crash.

## i18n

New strings in `money_en.i18n.json` + `money_fa.i18n.json`; `melos run translations`.

## Acceptance

- [ ] Attach, view, and remove a receipt image; persists across restart.
- [ ] Missing-file case renders a placeholder, not a crash.
- [ ] `melos run analyze && melos run test` pass.
