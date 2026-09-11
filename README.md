# بده‌بستان (BedeBestan)

Local-only personal money + calendar + notes. Flutter Melos monorepo.

## Quick start

```bash
dart pub get                    # or: melos bootstrap
melos run dev                   # Linux desktop
melos run dev:web               # Chrome (local CanvasKit)
melos run translations          # after changing *.i18n.json
melos run analyze && melos run test
```

If `pub get` hits `pub.flutter-io.cn` hash errors, use `PUB_HOSTED_URL=https://pub.dev`.

## Documentation

| Doc | Purpose |
|---|---|
| [AGENTS.md](AGENTS.md) | AI agent entry (routes to full playbook) |
| [docs/README.md](docs/README.md) | Human docs index |
| [docs/project/bedeh-bestan/PHASES.md](docs/project/bedeh-bestan/PHASES.md) | Product phases |

## Layout

```
apps/bedeh_bestan/     composition root (router, AppShell)
features/              home, money, calendar, notes
packages/              core, ui_kit, translations
docs/                  architecture, prompts, phases
```
