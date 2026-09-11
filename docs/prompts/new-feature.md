# Prompt: new feature

Read first: `docs/architecture/03-feature-anatomy.md`, `docs/AGENTS.md`.

- **Name:** `{feature_name}` (package `feature_{feature_name}`)
- **Route(s):** register in `AppRoutes`
- **Summary:** `{one paragraph}`

1. Create `features/{feature_name}/` (pages, routes, en+fa JSON). Data layer only if the phase needs it.
2. No UI strings in Dart. Run `melos run translations`.
3. Widgets are dumb (no `ref`).
4. Wire `...build<Name>Routes(ref)` in `apps/bedeh_bestan/.../app_router.dart`.
5. `melos run analyze && melos run test`.

Local-only: no HTTP, no auth.
