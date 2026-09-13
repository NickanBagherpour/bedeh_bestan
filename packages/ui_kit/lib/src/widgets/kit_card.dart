import 'package:flutter/material.dart';

import '../haptics/app_haptics.dart';
import '../theme/app_spacing.dart';

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
}
