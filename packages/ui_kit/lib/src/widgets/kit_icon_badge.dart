import 'package:flutter/material.dart';

import '../theme/app_gradients.dart';
import '../theme/app_spacing.dart';

/// A rounded, gradient-filled icon container — the app's signature accent chip.
///
/// Used across cards, list rows and headers to give every entity a colorful,
/// tactile glyph. Pass [filled] `false` for a soft tinted variant that keeps
/// the accent legible on light surfaces.
class KitIconBadge extends StatelessWidget {
  const KitIconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 48,
    this.filled = true,
    this.glow = false,
  });

  final IconData icon;
  final Color color;
  final double size;

  /// Solid gradient fill with a white glyph when `true`; soft tint otherwise.
  final bool filled;

  /// Adds a colored drop shadow for floating hero glyphs.
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * 0.32);
    final iconSize = size * 0.5;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: filled
            ? AppGradients.accent(color)
            : AppGradients.softTint(color, alpha: 0.20),
        borderRadius: radius,
        boxShadow: glow ? AppGradients.glow(color, strength: 0.30) : null,
        border: filled
            ? null
            : Border.all(color: color.withValues(alpha: 0.28)),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: iconSize,
        color: filled ? Colors.white : color,
      ),
    );
  }
}

/// A circular monogram avatar derived from a name — used for parties/people.
class KitMonogram extends StatelessWidget {
  const KitMonogram({
    super.key,
    required this.name,
    required this.color,
    this.size = 44,
  });

  final String name;
  final Color color;
  final double size;

  String get _initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '؟';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.characters.take(1).toString();
    }
    return (parts.first.characters.take(1).toString() +
        parts[1].characters.take(1).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppGradients.accent(color),
        shape: BoxShape.circle,
        boxShadow: AppGradients.glow(color, strength: 0.22),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.36,
          height: 1,
        ),
      ),
    );
  }
}

const double _badgeSpacing = AppSpacing.sm;

/// Convenience: badge + title/subtitle row used inside list rows.
class KitBadgeRow extends StatelessWidget {
  const KitBadgeRow({
    super.key,
    required this.badge,
    required this.child,
  });

  final Widget badge;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        badge,
        const SizedBox(width: _badgeSpacing),
        Expanded(child: child),
      ],
    );
  }
}
