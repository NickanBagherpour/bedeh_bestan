import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Ambient aurora background painted behind every primary destination.
///
/// Three slowly drifting colored blobs on the scaffold color give the app a
/// living, premium depth. Motion is intentionally slow and low-contrast so it
/// never competes with content or hurts readability. Wrap page bodies with it.
class KitScreenBackground extends StatefulWidget {
  const KitScreenBackground({
    super.key,
    required this.child,
    this.animate = true,
  });

  final Widget child;
  final bool animate;

  @override
  State<KitScreenBackground> createState() => _KitScreenBackgroundState();
}

class _KitScreenBackgroundState extends State<KitScreenBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    );
    if (widget.animate) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Stack(
      children: [
        // Base scaffold color so the ambient layer is self-contained and can
        // sit behind a transparent Scaffold (body + floating nav bar).
        Positioned.fill(
          child: ColoredBox(color: theme.scaffoldBackgroundColor),
        ),
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _AuroraPainter(
                    t: _controller.value,
                    isDark: isDark,
                  ),
                );
              },
            ),
          ),
        ),
        Positioned.fill(child: widget.child),
      ],
    );
  }
}

class _AuroraPainter extends CustomPainter {
  _AuroraPainter({required this.t, required this.isDark});

  final double t;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final alpha = isDark ? 0.22 : 0.16;
    const blobs = <_Blob>[
      _Blob(AppColors.brand, Offset(0.15, 0.08), 0.55, 0.0),
      _Blob(AppColors.receive, Offset(0.9, 0.2), 0.5, 0.33),
      _Blob(AppColors.reminder, Offset(0.2, 0.85), 0.5, 0.66),
    ];

    for (final blob in blobs) {
      final phase = (t + blob.phase) * 2 * math.pi;
      final dx = blob.anchor.dx + math.sin(phase) * 0.06;
      final dy = blob.anchor.dy + math.cos(phase) * 0.05;
      final center = Offset(dx * size.width, dy * size.height);
      final radius = blob.radiusFactor * size.shortestSide;
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            blob.color.withValues(alpha: alpha),
            blob.color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_AuroraPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.isDark != isDark;
}

class _Blob {
  const _Blob(this.color, this.anchor, this.radiusFactor, this.phase);

  final Color color;
  final Offset anchor;
  final double radiusFactor;
  final double phase;
}
