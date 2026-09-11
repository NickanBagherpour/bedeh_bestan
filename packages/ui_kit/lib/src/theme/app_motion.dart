import 'package:flutter/material.dart';

/// Shared motion tokens for consistent, calm UI motion.
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 140);
  static const Duration normal = Duration(milliseconds: 220);
  static const Duration entrance = Duration(milliseconds: 400);

  static const Curve easeOut = Curves.easeOutCubic;
  static const Curve easeInOut = Curves.easeInOut;

  /// Soft fade + slight upward slide — content enter / navigations.
  static Widget fadeSlideIn({
    required Animation<double> animation,
    required Widget child,
    Offset beginOffset = const Offset(0, 0.02),
  }) {
    final curved = CurvedAnimation(parent: animation, curve: easeOut);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position:
            Tween<Offset>(begin: beginOffset, end: Offset.zero).animate(curved),
        child: child,
      ),
    );
  }
}
