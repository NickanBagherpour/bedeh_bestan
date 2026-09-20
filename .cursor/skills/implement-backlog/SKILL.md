---
name: implement-backlog
description: >-
  Implements one BedeBestan backlog or phase spec with minimal doc loading.
  Use when the user points at a docs/prompts spec, PHASES.md item, backlog
  task, or asks to implement a single linked ticket.
---

# Implement backlog item

## Read first

1. `AGENTS.md` / `docs/AGENTS.md`
2. The **one** spec the user named (under `docs/prompts/` or the phase section in `docs/project/bedeh-bestan/PHASES.md`)
3. Only architecture docs that spec lists — nothing else

## Workflow

```
- [ ] Scope = that spec only; no adjacent backlog items
- [ ] Touch owning feature / package; app only for router/pubspec if required
- [ ] en + fa strings if UI changes; melos run translations
- [ ] melos run analyze && melos run test
- [ ] If backlog tracks status, mark this item done only
```

## Chat opener (if user has no prompt)

Use `docs/prompts/new-chat.md` templates. Prefer:

```text
Read AGENTS.md, then implement only {SPEC}.
Follow docs/AGENTS.md non-negotiables. When done: melos run analyze && melos run test.
Do not start other backlog items.
```
