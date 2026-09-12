# New Cursor chat — copy template

Replace `{SPEC}` with a file from [backlog.md](backlog.md) (e.g. `docs/prompts/installment-payment-prefill.md`).

## Standard task

```text
Read AGENTS.md, then implement only {SPEC}.

Follow docs/AGENTS.md non-negotiables. Read only the architecture docs that spec lists.
When done: melos run analyze && melos run test. Update backlog status if this item is finished.
Do not start other backlog items.
```

## Bug fix (ui_kit / shared widget)

```text
Read AGENTS.md. Implement {SPEC} only.

Touch the owning package; add or update tests in that package if the spec asks.
melos run analyze && melos run test before finishing.
```

## New feature (not in backlog yet)

```text
Read AGENTS.md and docs/prompts/new-feature.md.

Feature: {name}
Summary: {one sentence}

Fill in new-feature.md checklist. en + fa i18n. melos run translations.
melos run analyze && melos run test.
```

## Phase-aligned work

```text
Read AGENTS.md and docs/project/bedeh-bestan/PHASES.md.

Work only on {phase or feature area}. One slice; stop with file list and how to run.
melos run analyze && melos run test.
```
