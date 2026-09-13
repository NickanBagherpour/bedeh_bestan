# Feature: manual assets & net worth

**Package:** `features/assets` (or `features/profile` sub-routes) + `packages/local_db`
**Type:** new feature
**Entry:** [profile-nav-hub.md](profile-nav-hub.md) — **not** a fifth bottom tab

## Read first

- `docs/architecture/03-feature-anatomy.md`
- `docs/prompts/new-feature.md`

## Goal

Users track **manual balances** (cash, bank, gold, etc.) — no bank API/SMS.
Show **financial position** on the assets screen (under Profile):

- Total assets, open liabilities (بدهی), net طلب/بدهی, **net worth**
- Simple **utilization** indicator (% of assets vs short-term debt)

Optional **home teaser card** linking to `/profile/assets` (no full CRUD on home).

## Data (`packages/local_db`)

- Table `AssetAccounts`: `id`, `name`, `kind`, `balance`, `note`, timestamps.
- Migration + `backup.dart` round-trip.

## UI

- Route: `AppRoutes.profileAssets` (or nested under profile feature).
- List + add/edit + total header.
- Net worth uses live money totals + asset sum (query in `features/assets` via
  repository reading `local_db` only — no cross-feature imports; shared math in
  `core` if needed).

## Future auth

Assets live under profile subtree → later protected by
[future-profile-auth-gate.md](future-profile-auth-gate.md).

## Constraints

- Local-only; app currency setting only (no FX).

## i18n

Feature en + fa; `melos run translations`.

## Acceptance

- [ ] CRUD assets; persist + backup.
- [ ] Opened from profile hub; not in bottom nav.
- [ ] Net position matches seeded scenario.
- [ ] `melos run analyze && melos run test` pass.
