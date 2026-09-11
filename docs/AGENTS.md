# Agent playbook — BedeBestan

Flutter **Melos monorepo**. Local-only personal money + calendar + notes app.
Layout matches `devportal` (`build/mms`): apps compose, features own slices,
packages share foundation. **Do not copy MMS business logic.**

## Task → docs (read in this order)

| Task | Read | Then |
|---|---|---|
| Understand repo | `architecture/00-overview.md` | Explore `features/` + `packages/` |
| Local DB / seed | `architecture/04-local-data.md` | `packages/local_db` |
| New feature | `architecture/03-feature-anatomy.md`, `prompts/new-feature.md` | Package under `features/<name>/` |
| Routing / shell | `architecture/00-overview.md` (routing bullet) | Paths only in `AppRoutes` |
| Theme / i18n / RTL | `architecture/08-i18n-theming.md` | en + fa in the same change |
| Next product work | `project/bedeh-bestan/PHASES.md` | One phase at a time |

## Layout

```
apps/bedeh_bestan/     composition root (main, router, AppShell)
features/              one Dart package per destination
  home/ money/ calendar/ notes/
packages/
  core/                routes, settings, storage, Jalali, Toman helpers
  ui_kit/              theme + Kit* widgets
  translations/        slang (scans whole repo for *.i18n.json)
  local_db/            Drift + seed
```

## Non-negotiable

1. **Features live in `features/`**, never `apps/bedeh_bestan/lib/src/features/`.
2. **Pages → Controller → Repository → local source.** Pages never call repositories.
3. **Widgets have no `ref`.** Only pages use Riverpod.
4. **No cross-feature imports.** Shared code goes in `core` / `ui_kit`.
5. **Paths** only in `AppRoutes`. Features use `AppRoutes.x.path`.
6. **No hardcoded UI strings.** `*_en.i18n.json` + `*_fa.i18n.json`; `melos run translations`.
7. **Local-only.** No backend, auth, sync, or `api_client`. Persistence is on-device.
8. **Verify:** `melos run analyze && melos run test` before finishing.

## Workflow

```
- [ ] Read the one architecture file for this task
- [ ] Touch the owning feature package (not the app, except router wiring)
- [ ] Register routes in AppRoutes + `...build<Name>Routes(ref)` in app_router
- [ ] Add en + fa translations; run `melos run translations`
- [ ] Analyze + test
```
