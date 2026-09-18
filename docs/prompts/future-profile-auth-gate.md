# Future: protect profile subtree after login

**Package:** `features/profile` + app router
**Type:** architecture placeholder — **do not implement login/backend** until product approves

## Intent

When cloud account or device lock arrives, **only the profile hub** (assets,
sensitive exports, account email) requires authentication. Main app (money,
calendar, notes) can stay usable offline without account — product decision.

## Requirements when implemented

- `AuthSession` provider (local token or biometric flag only at first).
- `redirect` on `GoRouter` for paths under `/profile/**` when session null.
- Sign-in / register screens live under `features/profile` or `features/auth`.
- **No** change to local-only money DB without explicit sync phase.

## Out of scope until requested

SMS OTP, Bazaar billing account, server APIs.

## Link

Implement after [profile-nav-hub.md](profile-nav-hub.md) route tree exists.
