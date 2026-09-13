import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart'
    show AppColors, AppSpacing, KitCard, KitStatTile;

class HomeReportCard extends StatelessWidget {
  const HomeReportCard({
    super.key,
    required this.title,
    required this.periodRangeLabel,
    required this.paidOutValue,
    required this.paidInValue,
    required this.duePayInMonthValue,
    required this.dueReceiveInMonthValue,
    required this.openPayValue,
    required this.openReceiveValue,
    required this.paidOutCaption,
    required this.paidInCaption,
    required this.duePayInMonthCaption,
    required this.dueReceiveInMonthCaption,
    required this.openPayCaption,
    required this.openReceiveCaption,
  });

  final String title;
  final String periodRangeLabel;
  final String paidOutValue;
  final String paidInValue;
  final String duePayInMonthValue;
  final String dueReceiveInMonthValue;
  final String openPayValue;
  final String openReceiveValue;
  final String paidOutCaption;
  final String paidInCaption;
  final String duePayInMonthCaption;
  final String dueReceiveInMonthCaption;
  final String openPayCaption;
  final String openReceiveCaption;

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
                Icons.insights_rounded,
                size: 20,
                color: theme.colorScheme.primary,
              ),
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
                    Text(
                      periodRangeLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: KitStatTile(
                  icon: Icons.south_west_rounded,
                  color: AppColors.pay,
                  value: paidOutValue,
                  caption: paidOutCaption,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: KitStatTile(
                  icon: Icons.north_east_rounded,
                  color: AppColors.receive,
                  value: paidInValue,
                  caption: paidInCaption,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: KitStatTile(
                  icon: Icons.event_rounded,
                  color: AppColors.reminder,
                  value: duePayInMonthValue,
                  caption: duePayInMonthCaption,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: KitStatTile(
                  icon: Icons.event_available_rounded,
                  color: AppColors.receive,
                  value: dueReceiveInMonthValue,
                  caption: dueReceiveInMonthCaption,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: KitStatTile(
                  icon: Icons.account_balance_wallet_rounded,
                  color: AppColors.brand,
                  value: openPayValue,
                  caption: openPayCaption,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: KitStatTile(
                  icon: Icons.savings_outlined,
                  color: AppColors.pay,
                  value: openReceiveValue,
                  caption: openReceiveCaption,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
