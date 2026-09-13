# Feature: profile hub (nav menu + assets entry)

**Package:** `apps/bedeh_bestan` + new `features/profile` (recommended)
**Type:** feature / shell
**Hosts:** [manual-assets-net-worth.md](manual-assets-net-worth.md), future account features

## Read first

- `docs/architecture/03-feature-anatomy.md`
- `apps/bedeh_bestan/lib/src/navigation/app_shell.dart`
- `docs/prompts/new-feature.md`

## Goal

A **profile** entry point (not a fifth bottom-tab) that groups **personal /
protected** areas:

- **دارایی‌ها / Assets** → asset accounts + net worth ([manual-assets-net-worth.md](manual-assets-net-worth.md))
- **Settings** (move or duplicate link from home gear — home can keep shortcut)
- Placeholder rows for **future**: account / login, privacy lock, export (optional)

Bottom nav stays **خانه | حساب | تقویم | یادداشت** (four tabs).

## Entry UX

Pick one (implementer chooses best fit with existing `KitHeroHeader`):

- **Home:** avatar / person icon in hero header (next to settings) → `/profile`
- **App shell:** small profile affordance on all primary tabs (top-leading or
  trailing) — prefer **home-only** in v1 to avoid clutter.

Route: `AppRoutes.profile` overlay or full-screen stack under shell
(`/profile`, `/profile/assets`, …).

## `features/profile`

- `profile_page.dart` — hub list (assets tile, settings tile, version footer).
- `buildProfileRoutes(Ref)` registered in `app_router.dart`.
- en + fa i18n in feature package.

## Future auth (design only — no login in this task)

Structure routes so a later **`AuthGate`** can wrap **only** the profile subtree:

```
ShellRoute (public: home, money, calendar, notes)
  → ProfileShellRoute (future: requires session / biometric)
      → /profile, /profile/assets, …
```

Document in code: `// TODO(auth): redirect to sign-in when AuthSession empty`.

Local-only v1: profile is **not** locked; all routes open.

## Acceptance

- [ ] User opens profile from home; sees Assets entry and Settings link.
- [ ] Assets spec routes under profile (stub page OK until assets feature ships).
- [ ] Paths only in `AppRoutes`.
- [ ] `melos run analyze && melos run test` pass.
