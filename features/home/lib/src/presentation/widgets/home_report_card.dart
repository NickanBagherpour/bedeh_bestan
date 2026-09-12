import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart'
    show AppColors, AppSpacing, KitCard, KitStatTile;

class HomeReportCard extends StatelessWidget {
  const HomeReportCard({
    super.key,
    required this.title,
    required this.paidOutValue,
    required this.paidInValue,
    required this.stillOweValue,
    required this.dueByEndValue,
    required this.paidOutCaption,
    required this.paidInCaption,
    required this.stillOweCaption,
    required this.dueByEndCaption,
  });

  final String title;
  final String paidOutValue;
  final String paidInValue;
  final String stillOweValue;
  final String dueByEndValue;
  final String paidOutCaption;
  final String paidInCaption;
  final String stillOweCaption;
  final String dueByEndCaption;

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
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
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
                  icon: Icons.account_balance_wallet_rounded,
                  color: AppColors.brand,
                  value: stillOweValue,
                  caption: stillOweCaption,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: KitStatTile(
                  icon: Icons.event_rounded,
                  color: AppColors.reminder,
                  value: dueByEndValue,
                  caption: dueByEndCaption,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
