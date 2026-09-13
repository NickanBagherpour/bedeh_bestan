import 'package:flutter/material.dart';
import 'package:local_db/local_db.dart' show MoneyDirection;
import 'package:ui_kit/ui_kit.dart'
    show AppColors, AppHaptics, AppSpacing, KitIconBadge;

import '../../application/home_dashboard.dart';

class HomeDueList extends StatelessWidget {
  const HomeDueList({
    super.key,
    required this.rows,
    required this.emptyLabel,
    required this.amountOf,
    required this.dueOf,
    required this.statusOf,
    required this.accentOf,
    required this.iconOf,
    required this.onTap,
    this.onQuickPay,
    this.busyItemId,
    this.quickPayLabel = '',
    this.quickReceiveLabel = '',
  });

  final List<HomeDueRow> rows;
  final String emptyLabel;
  final String Function(HomeDueRow row) amountOf;
  final String Function(HomeDueRow row) dueOf;
  final String Function(HomeDueRow row) statusOf;
  final Color Function(HomeDueRow row) accentOf;
  final IconData Function(HomeDueRow row) iconOf;
  final ValueChanged<HomeDueRow> onTap;
  final Future<void> Function(HomeDueRow row)? onQuickPay;
  final String? busyItemId;
  final String quickPayLabel;
  final String quickReceiveLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (rows.isEmpty) {
      return Text(
        emptyLabel,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }
    return Column(
      children: [
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
                  if (onQuickPay != null) ...[
                    const SizedBox(width: AppSpacing.xs),
                    FilledButton.tonal(
                      onPressed: busyItemId == row.id
                          ? null
                          : () {
                              AppHaptics.light();
                              onQuickPay!(row);
                            },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Text(
                        row.direction == MoneyDirection.pay
                            ? quickPayLabel
                            : quickReceiveLabel,
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                  ],
                  const SizedBox(width: AppSpacing.xs),
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
    );
  }
}
