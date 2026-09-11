# 08 — i18n & theming

## slang

Package: `packages/translations`. `slang.yaml` scans the **whole repo** for `*.i18n.json`.

- App chrome: `packages/translations/lib/src/i18n/app_en.i18n.json` + `app_fa.i18n.json` → `t.app.*`
- Feature: `features/<name>/lib/src/translations/<name>_en.i18n.json` → `t.<name>.*`

Generate: `melos run translations` (watch: `melos run translations:watch`).

```dart
final t = Translations.of(context);
Text(t.money.title);
Text(t.translate('money.status.overdue')); // data keys only
```

**No hardcoded user-facing strings.** Both locales in the same PR.

Default locale is **fa** (`useAppDefaultLocale()` in `main.dart`). Persist via `appSettingsProvider.setLocale`.

Theme, locale, calendar, and currency persist via `appSettingsProvider`. The settings **screen** is `features/settings` (Home gear → `/settings`). Calendar (Jalali / Gregorian) is a separate setting from language — it drives date display and month/week bounds. Currency (تومان / ریال / Dollar) is also a setting; switching language updates it only when it was still the previous language default. Stored amounts stay integer toman; ریال is shown ×10.

## Theme

`packages/ui_kit`: `AppColors`, `AppSpacing`, `AppTypography`, `AppFonts` (Vazirmatn), `AppMotion`, `AppTheme.lightFor/darkFor`.

`BedeBestanApp` already honors `themeMode` / `locale`. Prefer `Theme.of(context).colorScheme`. Semantic accents: `AppColors.pay` (بدهی), `.receive` (طلب), `.reminder`, `.note`.
