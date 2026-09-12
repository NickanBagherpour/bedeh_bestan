import 'package:flutter/material.dart';

import '../theme/app_gradients.dart';
import '../theme/app_spacing.dart';

/// Calm empty state — a softly floating gradient glyph, title, body and action.
class KitEmpty extends StatefulWidget {
  const KitEmpty({
    super.key,
    required this.title,
    this.body,
    this.icon = Icons.inbox_outlined,
    this.action,
    this.accent,
  });

  final String title;
  final String? body;
  final IconData icon;
  final Widget? action;
  final Color? accent;

  @override
  State<KitEmpty> createState() => _KitEmptyState();
}

class _KitEmptyState extends State<KitEmpty>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tint = widget.accent ?? theme.colorScheme.primary;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final t = Curves.easeInOut.transform(_controller.value);
                  return Transform.translate(
                    offset: Offset(0, -6 * t),
                    child: child,
                  );
                },
                child: Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                    gradient: AppGradients.accent(tint),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: AppGradients.glow(tint, strength: 0.30),
                  ),
                  child: Icon(widget.icon, size: 46, color: Colors.white),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (widget.body != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  widget.body!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (widget.action != null) ...[
                const SizedBox(height: AppSpacing.lg),
                widget.action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
