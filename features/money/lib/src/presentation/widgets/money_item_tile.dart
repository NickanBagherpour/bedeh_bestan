import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart'
    show AppColors, AppSpacing, KitCard, KitIconBadge;

import 'money_status_chip.dart';

class MoneyItemTile extends StatelessWidget {
  const MoneyItemTile({
    super.key,
    required this.title,
    required this.partyName,
    required this.amountLabel,
    required this.dueLabel,
    required this.statusLabel,
    required this.accent,
    required this.icon,
    required this.statusColor,
    required this.onTap,
  });

  final String title;
  final String partyName;
  final String amountLabel;
  final String dueLabel;
  final String statusLabel;
  final Color accent;
  final IconData icon;
  final Color statusColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return KitCard(
      onTap: onTap,
      accent: accent,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          KitIconBadge(icon: icon, color: accent, size: 48),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    MoneyStatusChip(label: statusLabel, color: statusColor),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  partyName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        amountLabel,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.onTint(accent),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      dueLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
