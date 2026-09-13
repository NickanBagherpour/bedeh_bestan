import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart'
    show AppColors, AppHaptics, AppSpacing, KitMonogram;

import '../../application/home_dashboard.dart';

class HomeBalancesCard extends StatelessWidget {
  const HomeBalancesCard({
    super.key,
    required this.balances,
    required this.emptyLabel,
    required this.payLabelOf,
    required this.receiveLabelOf,
    required this.onPartyTap,
  });

  final List<HomePartyBalance> balances;
  final String emptyLabel;
  final String Function(HomePartyBalance row) payLabelOf;
  final String Function(HomePartyBalance row) receiveLabelOf;
  final ValueChanged<HomePartyBalance> onPartyTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (balances.isEmpty) {
      return Text(
        emptyLabel,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }
    return Column(
      children: [
        for (final row in balances)
          InkWell(
            onTap: () {
              AppHaptics.selection();
              onPartyTap(row);
            },
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Padding(
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
                  Icon(
                    Icons.chevron_left_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
