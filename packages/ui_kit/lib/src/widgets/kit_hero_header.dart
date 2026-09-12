import 'package:flutter/material.dart';

import '../theme/app_gradients.dart';
import '../theme/app_spacing.dart';

/// A bold, gradient hero panel for the top of a primary destination.
///
/// Carries the app/section identity: a title, subtitle, a large decorative
/// watermark glyph, and an optional trailing action (e.g. settings). The
/// [gradient] defaults to the signature brand sweep.
class KitHeroHeader extends StatelessWidget {
  const KitHeroHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.watermark = Icons.auto_awesome_rounded,
    this.gradient,
    this.trailing,
    this.leading,
    this.footer,
  });

  final String title;
  final String? subtitle;
  final IconData watermark;
  final Gradient? gradient;
  final Widget? trailing;
  final Widget? leading;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final grad = gradient ?? AppGradients.brand;
    final radius = BorderRadius.circular(AppSpacing.radiusXl);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: AppGradients.glow(grad.colors.first, strength: 0.30),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: DecoratedBox(
          decoration: BoxDecoration(gradient: grad),
          child: Stack(
            children: [
              // Decorative watermark glyph, bled off the trailing edge.
              PositionedDirectional(
                end: -18,
                top: -14,
                child: Icon(
                  watermark,
                  size: 132,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (leading != null) ...[
                          leading!,
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              if (subtitle != null) ...[
                                const SizedBox(height: AppSpacing.xxs),
                                Text(
                                  subtitle!,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.82),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        ?trailing,
                      ],
                    ),
                    if (footer != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      footer!,
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
