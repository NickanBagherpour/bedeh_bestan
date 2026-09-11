import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart' show AppColors, AppSpacing, KitCard;

class HomeReportCard extends StatelessWidget {
  const HomeReportCard({
    super.key,
    required this.title,
    required this.paidOutLabel,
    required this.paidInLabel,
    required this.stillOweLabel,
    required this.dueByEndLabel,
  });

  final String title;
  final String paidOutLabel;
  final String paidInLabel;
  final String stillOweLabel;
  final String dueByEndLabel;

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
          Text(
            paidOutLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.pay,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            paidInLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.receive,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            stillOweLabel,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            dueByEndLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
