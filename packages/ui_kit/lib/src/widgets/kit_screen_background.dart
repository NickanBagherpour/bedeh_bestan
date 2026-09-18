import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/kit_surface_style.dart';

/// Ambient aurora background painted behind every primary destination.
///
/// Three soft radial color washes on the scaffold color give the app a
/// premium sense of depth. This is intentionally **static** and blur-free:
/// the radial gradients fade to transparent on their own, so we avoid the
/// per-frame `MaskFilter.blur` / continuous repaint that would tank scroll
/// performance on real devices. It paints once and is cached behind a
/// [RepaintBoundary].
class KitScreenBackground extends StatelessWidget {
  const KitScreenBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ambientBoost = KitSurfaceStyle.of(context).ambientBoost;
    return Stack(
      children: [
        // Base scaffold color so the ambient layer is self-contained and can
        // sit behind a transparent Scaffold (body + floating nav bar).
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _AuroraPainter(
                isDark: isDark,
                base: theme.scaffoldBackgroundColor,
                boost: ambientBoost,
              ),
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}

class _AuroraPainter extends CustomPainter {
  const _AuroraPainter({
    required this.isDark,
    required this.base,
    this.boost = 1,
  });

  final bool isDark;
  final Color base;

  /// Ambient strength multiplier (the glass skin turns the aurora up so it
  /// glows through the frosted surfaces).
  final double boost;

  static const List<_Blob> _blobs = [
    _Blob(AppColors.brand, Offset(0.12, 0.05), 0.62),
    _Blob(AppColors.receive, Offset(0.92, 0.14), 0.58),
    _Blob(AppColors.reminder, Offset(0.16, 0.82), 0.56),
    _Blob(AppColors.pay, Offset(0.9, 0.9), 0.54),
    _Blob(AppColors.brandMid, Offset(0.55, 0.5), 0.5),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Depth base: a soft diagonal tint instead of a flat wash. Stronger under
    // the glass skin so frosted surfaces have real color to refract.
    final tint = (isDark ? 0.14 : 0.08) * boost;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(base, AppColors.brand, tint.clamp(0.0, 0.5))!,
            base,
            Color.lerp(base, AppColors.receive, (tint * 0.7).clamp(0.0, 0.4))!,
          ],
        ).createShader(rect),
    );

    final alpha = ((isDark ? 0.20 : 0.14) * boost).clamp(0.0, 0.5);
    for (final blob in _blobs) {
      final center = Offset(
        blob.anchor.dx * size.width,
        blob.anchor.dy * size.height,
      );
      final radius = blob.radiusFactor * size.longestSide;
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            blob.color.withValues(alpha: alpha),
            blob.color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_AuroraPainter oldDelegate) =>
      oldDelegate.isDark != isDark ||
      oldDelegate.base != base ||
      oldDelegate.boost != boost;
}

class _Blob {
  const _Blob(this.color, this.anchor, this.radiusFactor);

  final Color color;
  final Offset anchor;
  final double radiusFactor;
}
