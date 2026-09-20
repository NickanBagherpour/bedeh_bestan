---
name: new-feature
description: >-
  Scaffolds a BedeBestan feature package under features/ with routes, en+fa
  slang, and app wiring. Use when creating a new feature, destination tab,
  or when the user mentions new-feature.md / feature_<name>.
---

# New feature

## Read first

1. `docs/AGENTS.md`
2. `docs/architecture/03-feature-anatomy.md`
3. `docs/prompts/new-feature.md`

## Steps

1. Create `features/<name>/` (`feature_<name>`, `resolution: workspace`, shared `analysis_options.yaml`).
2. Add barrel + `src/presentation`, `src/routes`, `src/translations` (`<name>_en.i18n.json` + `<name>_fa.i18n.json`). Add `data/` / `application/` only if needed.
3. Register path in `packages/core/.../app_routes.dart` (`AppRoutes` only).
4. Depend from `apps/bedeh_bestan/pubspec.yaml`; spread `...build<Name>Routes(ref)` in app router.
5. Run `melos run translations`, then `melos run analyze && melos run test`.

## Guardrails

- No code under `apps/bedeh_bestan/lib/src/features/`.
- Widgets: no `ref`. Pages: `ConsumerWidget` only.
- Local-only: no HTTP / auth / sync.
