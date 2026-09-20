---
name: efficient-slice
description: >-
  Runs a large BedeBestan change as a thin vertical slice to save tokens and
  keep diffs reviewable. Use for multi-file features, refactors, “huge”
  development, or when the user asks to work efficiently / save usage.
---

# Efficient slice

## Before coding

1. Restate the goal in one sentence + acceptance check.
2. List the **few** files/packages you expect to touch.
3. Read only the mapped doc from `docs/AGENTS.md` (not the whole tree).

## While coding

- One slice: data **or** UI **or** i18n wiring — finish that slice before expanding.
- Prefer `@path` / grep over opening whole packages.
- Use melos/shell for verify loops; do not re-explore the repo after each fix.
- Escalate model/depth only if blocked; otherwise stay on the default agent model.

## Done when

- Acceptance check passes
- `melos run analyze && melos run test` green (or report exact failures)
- Short file list + how to run — no long recap
