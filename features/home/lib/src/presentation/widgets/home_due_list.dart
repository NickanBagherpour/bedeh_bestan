import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart' show AppColors, AppHaptics, AppSpacing, KitCard;

import '../../application/home_dashboard.dart';

class HomeDueList extends StatelessWidget {
  const HomeDueList({
    super.key,
    required this.title,
    required this.emptyLabel,
    required this.rows,
    required this.amountOf,
    required this.dueOf,
    required this.statusOf,
    required this.accentOf,
    required this.onTap,
  });

  final String title;
  final String emptyLabel;
  final List<HomeDueRow> rows;
  final String Function(HomeDueRow row) amountOf;
  final String Function(HomeDueRow row) dueOf;
  final String Function(HomeDueRow row) statusOf;
  final Color Function(HomeDueRow row) accentOf;
  final ValueChanged<HomeDueRow> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return KitCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(row.title, style: theme.textTheme.titleSmall),
                            Text(
                              '${row.partyName} · ${statusOf(row)}',
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
