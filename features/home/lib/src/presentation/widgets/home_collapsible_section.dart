import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart' show AppHaptics, AppSpacing, KitCard;

/// Collapsible [KitCard] section for home list blocks.
class HomeCollapsibleSection extends StatelessWidget {
  const HomeCollapsibleSection({
    super.key,
    required this.title,
    required this.icon,
    required this.summary,
    required this.expanded,
    required this.onToggle,
    required this.child,
    this.expandTooltip,
    this.collapseTooltip,
  });

  final String title;
  final IconData icon;
  final String summary;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;
  final String? expandTooltip;
  final String? collapseTooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return KitCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () {
              AppHaptics.selection();
              onToggle();
            },
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (!expanded)
                          Text(
                            summary,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Tooltip(
                    message: expanded
                        ? (collapseTooltip ?? '')
                        : (expandTooltip ?? ''),
                    child: Icon(
                      expanded
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            const SizedBox(height: AppSpacing.sm),
            child,
          ],
        ],
      ),
    );
  }
}
