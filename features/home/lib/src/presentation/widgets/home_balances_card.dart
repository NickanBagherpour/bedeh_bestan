import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart'
    show AppColors, AppSpacing, KitCard, KitMonogram;

import '../../application/home_dashboard.dart';

class HomeBalancesCard extends StatelessWidget {
  const HomeBalancesCard({
    super.key,
    required this.title,
    required this.emptyLabel,
    required this.balances,
    required this.payLabelOf,
    required this.receiveLabelOf,
  });

  final String title;
  final String emptyLabel;
  final List<HomePartyBalance> balances;
  final String Function(HomePartyBalance row) payLabelOf;
  final String Function(HomePartyBalance row) receiveLabelOf;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return KitCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.groups_rounded,
                size: 20,
                color: theme.colorScheme.primary,
              ),
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
          if (balances.isEmpty)
            Text(
              emptyLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            for (final row in balances)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  children: [
                    KitMonogram(
                      name: row.partyName,
                      color: row.receiveRemaining >= row.payRemaining
                          ? AppColors.receive
                          : AppColors.pay,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            row.partyName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (row.payRemaining > 0)
                            Text(
                              payLabelOf(row),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.pay,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          if (row.receiveRemaining > 0)
                            Text(
                              receiveLabelOf(row),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.receive,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
