---
name: local-db-change
description: >-
  Changes BedeBestan on-device Drift schema, seed, or repositories in
  packages/local_db. Use when editing tables, DAOs, migrations, seed data,
  or feature repositories that talk to local persistence.
---

# Local DB change

## Read first

- `docs/architecture/04-local-data.md`
- Existing patterns in `packages/local_db/`

## Steps

1. Change schema / DAO in `packages/local_db` only.
2. Update seed if demos/tests rely on it.
3. Map through the feature’s repository — pages never call DB directly.
4. No HTTP, sync, or remote API.
5. `melos run analyze && melos run test` (include local_db tests).

## Guardrails

- Features own repositories; `local_db` owns tables/DAOs.
- Prefer existing column/type conventions; avoid drive-by renames.
