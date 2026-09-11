# 10 — Conventions

| Thing | Convention |
|---|---|
| Feature package | `feature_<snake>` in `features/<snake>/` |
| Files | `snake_case.dart` |
| Classes | `PascalCase`, feature-prefixed (`MoneyController`) |
| Entities | `*.dto.dart` / `*.model.dart` |
| Providers | `fooProvider` |
| Route builder | `buildFooRoutes` |
| i18n files | `<feature>_en.i18n.json` / `_fa.i18n.json` |

Workspace imports use `show`:

```dart
import 'package:core/core.dart' show AppRoutes, buildRoutePage;
import 'package:ui_kit/ui_kit.dart' show KitEmpty, AppSpacing;
import 'package:feature_money/money.dart' show buildMoneyRoutes;
```

Never import `package:feature_x/src/...` from another package.

Do: tokens (`AppSpacing`), `Kit*` widgets, en+fa together.
Don't: strings in widgets, `print`, `apps/.../features/`, cross-feature imports, backend.
