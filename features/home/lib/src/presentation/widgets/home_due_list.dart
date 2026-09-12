import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart'
    show AppColors, AppHaptics, AppSpacing, KitCard, KitIconBadge;

import '../../application/home_dashboard.dart';

class HomeDueList extends StatelessWidget {
  const HomeDueList({
    super.key,
    required this.title,
    required this.icon,
    required this.emptyLabel,
    required this.rows,
    required this.amountOf,
    required this.dueOf,
    required this.statusOf,
    required this.accentOf,
    required this.iconOf,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final String emptyLabel;
  final List<HomeDueRow> rows;
  final String Function(HomeDueRow row) amountOf;
  final String Function(HomeDueRow row) dueOf;
  final String Function(HomeDueRow row) statusOf;
  final Color Function(HomeDueRow row) accentOf;
  final IconData Function(HomeDueRow row) iconOf;
  final ValueChanged<HomeDueRow> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return KitCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (rows.isEmpty)
            Text(
              emptyLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            for (final row in rows)
              InkWell(
                onTap: () {
                  AppHaptics.selection();
                  onTap(row);
                },
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Row(
                    children: [
                      KitIconBadge(
                        icon: iconOf(row),
                        color: accentOf(row),
                        size: 40,
                        filled: false,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              row.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall,
                            ),
                            Text(
                              '${row.partyName} · ${statusOf(row)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            amountOf(row),
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: AppColors.onTint(accentOf(row)),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(dueOf(row), style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
