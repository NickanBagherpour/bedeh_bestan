# 03 — Feature anatomy

Every feature is a Dart package. Do **not** put feature code under `apps/`.

```
features/<name>/
├── pubspec.yaml                 # name: feature_<name>, resolution: workspace
├── analysis_options.yaml        # include: ../../analysis_options.yaml
└── lib/
    ├── <name>.dart              # barrel: routes + page (+ controller later)
    └── src/
        ├── data/                # Phase 2+: api-or-db, entities, repositories
        ├── application/         # controllers/, state/, mappers/
        ├── presentation/
        │   ├── pages/
        │   └── widgets/         # no ref.watch / ref.read
        ├── routes/              # build<Name>Routes(Ref)
        └── translations/        # <name>_en.i18n.json, <name>_fa.i18n.json
```

Skip empty folders. Settings-like features may omit `data/`.

## Layering

1. **Page** (`ConsumerWidget`) — `ref.watch`, calls controller.
2. **Controller** (`Notifier`) — owns status + error; never talks to widgets.
3. **Repository** — DTO→model, persistence.
4. **Local source** — Drift/Isar (Phase 2). Not HTTP.

## Routes

```dart
List<RouteBase> buildMoneyRoutes(Ref ref) {
  return [
    GoRoute(
      path: AppRoutes.money.path,
      name: AppRoutes.money.name,
      pageBuilder: (context, state) =>
          buildRoutePage(state: state, child: const MoneyPage()),
    ),
  ];
}
```

Wire in `apps/bedeh_bestan/.../app_router.dart`: `...buildMoneyRoutes(ref)`.

## New-feature checklist

1. `features/<name>/` + pubspec `feature_<name>`.
2. Covered by root `workspace: features/**`.
3. Add `AppRoutes` entry.
4. en + fa JSON; `melos run translations`.
5. Depend from `apps/bedeh_bestan/pubspec.yaml`.
6. Spread routes inside the shell.
7. `melos run analyze && melos run test`.
