import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart' show AppColors, AppSpacing, KitCard;

class DirectionChoiceSheet extends StatelessWidget {
  const DirectionChoiceSheet({
    super.key,
    required this.title,
    required this.payLabel,
    required this.receiveLabel,
    required this.onPay,
    required this.onReceive,
  });

  final String title;
  final String payLabel;
  final String receiveLabel;
  final VoidCallback onPay;
  final VoidCallback onReceive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          KitCard(
            color: AppColors.pay.withValues(alpha: 0.10),
            onTap: onPay,
            child: Row(
              children: [
                const Icon(Icons.south_west_rounded, color: AppColors.pay),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  payLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.pay,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          KitCard(
            color: AppColors.receive.withValues(alpha: 0.10),
            onTap: onReceive,
            child: Row(
              children: [
                const Icon(Icons.north_east_rounded, color: AppColors.receive),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  receiveLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.receive,
                        fontWeight: FontWeight.w800,
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
