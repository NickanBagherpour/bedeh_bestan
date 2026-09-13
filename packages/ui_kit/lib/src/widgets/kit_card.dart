import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../haptics/app_haptics.dart';
import '../theme/app_spacing.dart';
import '../theme/kit_surface_style.dart';

/// Surface card for interactive or content groupings.
///
/// Supports plain surface cards plus expressive variants:
/// * [gradient] — fill the card with a gradient (hero/CTA surfaces).
/// * [accent] — draw a colored leading edge + soft glow (categorized rows).
class KitCard extends StatelessWidget {
  const KitCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.margin,
    this.color,
    this.gradient,
    this.accent,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  /// Fill the card with a gradient instead of a flat surface color.
  final Gradient? gradient;

  /// Accent color for the leading edge strip + soft ambient glow.
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final surface = KitSurfaceStyle.of(context);
    // Gradient (hero/CTA) cards stay opaque even in glass — blurring behind an
    // opaque fill is wasted work — so they fall through to the classic path.
    if (surface.isGlass && gradient == null) {
      return _buildGlass(context, surface);
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final radius = BorderRadius.circular(AppSpacing.radiusLg);
    final bg = color ?? theme.cardTheme.color ?? theme.colorScheme.surface;

    final shadow = accent != null
        ? [
            BoxShadow(
              color: accent!.withValues(alpha: isDark ? 0.22 : 0.16),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ]
        : [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.28)
                  : const Color(0x1F3F3AA8),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ];

    Widget content = Padding(padding: padding, child: child);
    if (accent != null) {
      // A leading accent strip drawn via a Stack — no IntrinsicHeight, so no
      // extra layout pass per list item.
      content = Stack(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 5),
            child: content,
          ),
          PositionedDirectional(
            start: 0,
            top: 0,
            bottom: 0,
            width: 5,
            child: ColoredBox(color: accent!),
          ),
        ],
      );
    }

    final card = DecoratedBox(
      decoration: BoxDecoration(borderRadius: radius, boxShadow: shadow),
      child: Material(
        color: gradient != null ? Colors.transparent : bg,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: accent?.withValues(alpha: 0.35) ?? theme.dividerColor,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: gradient != null
              ? BoxDecoration(gradient: gradient, borderRadius: radius)
              : null,
          child: InkWell(
            onTap: onTap == null
                ? null
                : () {
                    AppHaptics.selection();
                    onTap!();
                  },
            child: content,
          ),
        ),
      ),
    );

    if (margin == null) return card;
    return Padding(padding: margin!, child: card);
  }

  /// Translucent, backdrop-blurred surface for the glass skin.
  ///
  /// The ambient aurora behind the page shows through the blur, and a bright
  /// diagonal sheen + luminous top edge sell the “pane of frosted glass” feel
  /// in both light and dark.
  Widget _buildGlass(BuildContext context, KitSurfaceStyle surface) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final radius = BorderRadius.circular(AppSpacing.radiusLg);

    // Very translucent fill so the colorful background reads through the blur.
    final base = color ?? theme.colorScheme.surface;
    final fill = base.withValues(
      alpha: isDark ? surface.surfaceAlpha + 0.06 : surface.surfaceAlpha,
    );

    // Luminous edge: brighter at the top-left where the "light" hits.
    final edgeColor = accent ?? Colors.white;
    final border = edgeColor.withValues(
      alpha: (accent != null ? 0.55 : (isDark ? 0.24 : 0.7)) * surface.borderAlpha,
    );

    // Diagonal glass sheen laid over the fill (behind the content).
    final sheen = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withValues(alpha: (isDark ? 0.16 : 0.42) * surface.sheenAlpha),
        Colors.white.withValues(alpha: (isDark ? 0.03 : 0.10) * surface.sheenAlpha),
        Colors.white.withValues(alpha: 0),
      ],
      stops: const [0, 0.35, 0.75],
    );

    Widget content = Padding(padding: padding, child: child);
    if (accent != null) {
      content = Stack(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 5),
            child: content,
          ),
          PositionedDirectional(
            start: 0,
            top: 0,
            bottom: 0,
            width: 5,
            child: ColoredBox(color: accent!),
          ),
        ],
      );
    }

    final interactive = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap == null
            ? null
            : () {
                AppHaptics.selection();
                onTap!();
              },
        child: content,
      ),
    );

    final glassBody = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: surface.blurSigma,
          sigmaY: surface.blurSigma,
        ),
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: fill)),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(gradient: sheen),
                ),
              ),
            ),
            interactive,
          ],
        ),
      ),
    );

    // Border drawn on top (foreground) so the blur can't soften the edge.
    final bordered = DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: border),
      ),
      child: glassBody,
    );

    final card = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: (accent ?? theme.colorScheme.shadow).withValues(
              alpha: (isDark ? 0.34 : 0.18) * surface.shadowAlpha,
            ),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: bordered,
    );

    if (margin == null) return card;
    return Padding(padding: margin!, child: card);
  }
}
