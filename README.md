# بده‌بستان (BedeBestan)

Local-only personal money + calendar + notes. Flutter Melos monorepo.

## Quick start

```bash
dart pub get                    # or: melos bootstrap
melos run dev:linux             # Linux desktop
melos run dev:web               # Chrome (local CanvasKit)
melos run translations          # after changing *.i18n.json
melos run analyze && melos run test
```

If `pub get` hits `pub.flutter-io.cn` hash errors, use `PUB_HOSTED_URL=https://pub.dev`.

## Store release (Android)

Listing copy, ad titles, and screenshots: [store/LISTING.md](store/LISTING.md).

```bash
# Signed APK for Cafe Bazaar / Myket
cd apps/bedeh_bestan && flutter build apk --release

# Play Store bundle
cd apps/bedeh_bestan && flutter build appbundle --release
```

Keep `android/upload-keystore.jks` and `android/key.properties` off git and in a backup.

## Documentation

| Doc | Purpose |
|---|---|
| [AGENTS.md](AGENTS.md) | AI agent entry (routes to full playbook) |
| [docs/README.md](docs/README.md) | Human docs index |
| [docs/project/bedeh-bestan/PHASES.md](docs/project/bedeh-bestan/PHASES.md) | Product phases |

## Layout

```
apps/bedeh_bestan/     composition root (router, AppShell)
features/              home, money, calendar, notes, settings
packages/              core, ui_kit, translations
docs/                  architecture, prompts, phases
```
