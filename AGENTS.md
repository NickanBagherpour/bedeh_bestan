# Agent entry point

> Canonical playbook: [docs/AGENTS.md](docs/AGENTS.md)

Read **only** what the task needs. Do not load the whole `docs/` tree.

## Read first

1. [docs/AGENTS.md](docs/AGENTS.md) — task routing + non-negotiable rules
2. [docs/architecture/00-overview.md](docs/architecture/00-overview.md) — if you need layout

## Quick reference

| Task | Go to |
|---|---|
| New feature | [docs/architecture/03-feature-anatomy.md](docs/architecture/03-feature-anatomy.md) · [docs/prompts/new-feature.md](docs/prompts/new-feature.md) · skill `new-feature` |
| i18n / theme / RTL | [docs/architecture/08-i18n-theming.md](docs/architecture/08-i18n-theming.md) · skill `i18n-change` |
| Local DB | [docs/architecture/04-local-data.md](docs/architecture/04-local-data.md) · skill `local-db-change` |
| Routing | `packages/core/lib/src/router/app_routes.dart` |
| Phases | [docs/project/bedeh-bestan/PHASES.md](docs/project/bedeh-bestan/PHASES.md) |
| Backlog task | [docs/prompts/backlog.md](docs/prompts/backlog.md) · [new-chat template](docs/prompts/new-chat.md) · skill `implement-backlog` |
| Large / efficient slice | skill `efficient-slice` |

Project rules: `.cursor/rules/` · skills: `.cursor/skills/`

## Current features

`features/home` · `features/money` · `features/calendar` · `features/notes` · `features/settings`

App root: `apps/bedeh_bestan/` · DB: `packages/local_db/` · Routes: `packages/core/lib/src/router/app_routes.dart`
