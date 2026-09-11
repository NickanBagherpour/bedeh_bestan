import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart' show AppColors, AppSpacing, KitCard;

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
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
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
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      row.partyName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (row.payRemaining > 0)
                      Text(
                        payLabelOf(row),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.pay,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (row.receiveRemaining > 0)
                      Text(
                        receiveLabelOf(row),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.receive,
                          fontWeight: FontWeight.w600,
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
