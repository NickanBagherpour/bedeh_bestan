import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

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
  const _AuroraPainter({required this.isDark, required this.base});

  final bool isDark;
  final Color base;

  static const List<_Blob> _blobs = [
    _Blob(AppColors.brand, Offset(0.15, 0.08), 0.55),
    _Blob(AppColors.receive, Offset(0.9, 0.2), 0.5),
    _Blob(AppColors.reminder, Offset(0.2, 0.85), 0.5),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = base);

    final alpha = isDark ? 0.20 : 0.14;
    for (final blob in _blobs) {
      final center = Offset(
        blob.anchor.dx * size.width,
        blob.anchor.dy * size.height,
      );
      final radius = blob.radiusFactor * size.shortestSide;
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
      oldDelegate.isDark != isDark || oldDelegate.base != base;
}

class _Blob {
  const _Blob(this.color, this.anchor, this.radiusFactor);

  final Color color;
  final Offset anchor;
  final double radiusFactor;
}
