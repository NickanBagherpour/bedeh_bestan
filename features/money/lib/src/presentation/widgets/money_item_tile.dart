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
    this.onPartyTap,
    this.partyLinkTooltip,
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

  /// Opens the party detail without triggering [onTap]. Null hides the link.
  final VoidCallback? onPartyTap;
  final String? partyLinkTooltip;

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
                _PartySubtitle(
                  partyName: partyName,
                  onPartyTap: onPartyTap,
                  tooltip: partyLinkTooltip,
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

/// Party name line with its own tap target so it does not steal the tile tap.
class _PartySubtitle extends StatelessWidget {
  const _PartySubtitle({
    required this.partyName,
    required this.onPartyTap,
    required this.tooltip,
  });

  final String partyName;
  final VoidCallback? onPartyTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(
      color: onPartyTap == null
          ? theme.colorScheme.onSurfaceVariant
          : theme.colorScheme.primary,
    );
    final name = Text(
      partyName,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
    if (onPartyTap == null) return name;
    return Row(
      children: [
        Expanded(
          child: Tooltip(
            message: tooltip ?? '',
            child: GestureDetector(
              onTap: onPartyTap,
              behavior: HitTestBehavior.opaque,
              child: name,
            ),
          ),
        ),
        IconButton(
          tooltip: tooltip,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 36, height: 36),
          iconSize: 20,
          onPressed: onPartyTap,
          icon: Icon(
            Icons.person_outline_rounded,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
