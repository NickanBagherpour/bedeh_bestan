# 00 — Overview

BedeBestan (بده‌بستان): local-only personal **money + calendar + notes**.
Android / iOS / web. No accounts, no sync, no backend.

Blueprint: `/media/nickan/workspace/trains/devportal` branch `build/mms`
(structure only — not MMS domain code).

## Packages

| Path | Role |
|---|---|
| `apps/bedeh_bestan` | Composition root: `main.dart`, `GoRouter`, `AppShell` |
| `features/<name>` | Vertical slice (`feature_<name>`). Owns UI, state, data, i18n, routes |
| `packages/core` | `AppRoutes`, settings, `AppStorage`, Jalali, Toman grouping |
| `packages/ui_kit` | `AppTheme`, tokens, `KitCard` / `KitEmpty` |
| `packages/translations` | slang; input is every `*.i18n.json` in the repo |
| `packages/local_db` | Drift schema, domain rows, Persian seed |

## Data flow (local-only)

```
On-device DB / SharedPreferences
  → DTO (feature data/entities/*.dto.dart)
  → Model (*.model.dart)
  → Repository
  → Controller state
  → Page (ConsumerWidget)
  → Dumb widgets
```

Phase 3 added money list / form / detail. Home shows due-this-week and who-owes-what.

## Dependency rules

- App may depend on every feature + every package.
- A feature may depend on `core`, `ui_kit`, `translations`, `local_db` (not other features).
- `local_db` may depend on nothing internal.
- `ui_kit` may depend on `core`.
- `core` and `translations` depend on nothing internal.

## Routing

- Paths live **only** in `packages/core/lib/src/router/app_routes.dart`.
- Each feature exports `build<Name>Routes(Ref)`.
- `apps/bedeh_bestan/lib/src/router/app_router.dart` spreads those lists inside one `ShellRoute` (`AppShell` bottom nav: خانه \| حساب \| تقویم \| یادداشت).

## State

Riverpod 3 `Notifier` / `NotifierProvider`. Same pattern as MMS dashboard/settings.
No Bloc. No Freezed.
