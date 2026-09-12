import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;

import '../theme/app_motion.dart';

/// A [Scaffold] whose floating action button hides while the body scrolls
/// down and reveals again when the user scrolls up (or reaches the top).
///
/// Wraps the body in a [NotificationListener] so it works with any scroll
/// view (ListView, CustomScrollView, …) without needing a ScrollController.
class KitScrollHideFab extends StatefulWidget {
  const KitScrollHideFab({
    super.key,
    required this.body,
    required this.fab,
    this.appBar,
    this.backgroundColor,
    this.floatingActionButtonLocation,
  });

  final Widget body;

  /// The floating action button to show/hide.
  final Widget fab;

  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  State<KitScrollHideFab> createState() => _KitScrollHideFabState();
}

class _KitScrollHideFabState extends State<KitScrollHideFab> {
  bool _visible = true;

  bool _onNotification(UserScrollNotification notification) {
    // Ignore inner/secondary scrollables (e.g. horizontal chip rows).
    if (notification.metrics.axis != Axis.vertical) return false;

    switch (notification.direction) {
      case ScrollDirection.reverse:
        if (_visible) setState(() => _visible = false);
      case ScrollDirection.forward:
        if (!_visible) setState(() => _visible = true);
      case ScrollDirection.idle:
        break;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      backgroundColor: widget.backgroundColor,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      body: NotificationListener<UserScrollNotification>(
        onNotification: _onNotification,
        child: widget.body,
      ),
      floatingActionButton: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, 2),
        duration: AppMotion.normal,
        curve: AppMotion.easeOut,
        child: AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: AppMotion.fast,
          child: widget.fab,
        ),
      ),
    );
  }
}
