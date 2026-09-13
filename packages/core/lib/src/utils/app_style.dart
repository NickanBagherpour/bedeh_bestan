/// Visual **skin** of the app, chosen independently from light/dark.
///
/// * [classic] — calm, solid surfaces (the original premium look).
/// * [glass] — modern “glassy” look: translucent, blurred surfaces that let
///   the ambient background glow through.
///
/// This is deliberately a *small* enum: the whole look is derived from it in
/// one place (`KitSurfaceStyle` in `ui_kit`), so adding a new skin later means
/// adding one enum value + one token preset — no per-widget changes.
enum AppStyle {
  classic,
  glass,
}
