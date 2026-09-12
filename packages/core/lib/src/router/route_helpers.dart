import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Soft SPA-style enter — matches ui_kit motion (easeOutCubic, ~220ms).
const _routeTransitionDuration = Duration(milliseconds: 220);

/// Pops an overlay, or [fallbackPath] when the stack has nowhere to go.
void popOrGo(BuildContext context, String fallbackPath) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(fallbackPath);
  }
}

/// App bar for nested screens — always shows a back control to the parent tab.
AppBar overlayAppBar({
  required BuildContext context,
  required Widget title,
  required String fallbackPath,
  List<Widget>? actions,
  String? backTooltip,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    leading: IconButton(
      tooltip: backTooltip,
      icon: const BackButtonIcon(),
      onPressed: () => popOrGo(context, fallbackPath),
    ),
    title: title,
    actions: actions,
  );
}

/// Platform-aware page transition for every [GoRoute].
///
/// Web gets a short fade + slight Y slide; native mobile fades only
/// (less motion on small screens).
Page<void> buildRoutePage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: _routeTransitionDuration,
    reverseTransitionDuration: _routeTransitionDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      const begin = kIsWeb ? Offset(0, 0.012) : Offset.zero;
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position:
              Tween<Offset>(begin: begin, end: Offset.zero).animate(curved),
          child: child,
        ),
      );
    },
  );
}
