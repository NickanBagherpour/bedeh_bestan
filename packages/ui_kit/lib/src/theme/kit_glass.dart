import 'package:flutter/material.dart';

/// Luminous rim gradient for glass surfaces: bright where the light hits
/// (top-left), fading through the body, then a soft glow at the far edge.
/// Pass an [accent] to tint the rim (falls back to white).
LinearGradient kitGlassBorderGradient(
  Color base, {
  required bool isDark,
}) {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      base.withValues(alpha: isDark ? 0.44 : 0.9),
      base.withValues(alpha: isDark ? 0.06 : 0.16),
      base.withValues(alpha: isDark ? 0.26 : 0.5),
    ],
    stops: const [0.0, 0.55, 1.0],
  );
}

/// A rounded-rectangle border stroked with a [gradient] instead of a flat
/// color — the signature "lit glass rim".
///
/// Use it inside a [ShapeDecoration] (typically a *foreground* decoration) so
/// the backdrop blur underneath can't soften the crisp edge.
class KitGlassBorder extends ShapeBorder {
  const KitGlassBorder({
    required this.borderRadius,
    required this.gradient,
    this.width = 1.3,
  });

  final BorderRadius borderRadius;
  final Gradient gradient;
  final double width;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.toRRect(rect).deflate(width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.toRRect(rect));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final rrect = borderRadius.toRRect(rect).deflate(width / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..shader = gradient.createShader(rect);
    canvas.drawRRect(rrect, paint);
  }

  @override
  ShapeBorder scale(double t) => KitGlassBorder(
        borderRadius: borderRadius * t,
        gradient: gradient,
        width: width * t,
      );
}
