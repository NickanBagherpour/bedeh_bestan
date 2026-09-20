---
name: i18n-change
description: >-
  Adds or updates BedeBestan UI strings with slang (en+fa) and regenerates
  translations. Use when adding labels, changing copy, fixing missing
  translations, or editing *.i18n.json.
---

# i18n change

## Steps

1. Locate the owning feature’s `src/translations/` (or shared package translations).
2. Add/update the **same keys** in `*_en.i18n.json` and `*_fa.i18n.json`.
3. Replace any hardcoded Dart string with the generated getter.
4. Run `melos run translations`.
5. Spot-check RTL/fa if the change is visible layout text (`docs/architecture/08-i18n-theming.md` only if needed).

## Do not

- Edit generated Dart under `packages/translations` by hand
- Ship en-only keys
- Invent a new JSON file when the feature already has one
