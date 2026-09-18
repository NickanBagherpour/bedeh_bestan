import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart' show AppColors, AppHaptics, AppSpacing;

class CalendarFilterBar extends StatelessWidget {
  const CalendarFilterBar({
    super.key,
    required this.eventsLabel,
    required this.birthdaysLabel,
    required this.moneyLabel,
    required this.showEvents,
    required this.showBirthdays,
    required this.showMoney,
    required this.onEvents,
    required this.onBirthdays,
    required this.onMoney,
  });

  final String eventsLabel;
  final String birthdaysLabel;
  final String moneyLabel;
  final bool showEvents;
  final bool showBirthdays;
  final bool showMoney;
  final ValueChanged<bool> onEvents;
  final ValueChanged<bool> onBirthdays;
  final ValueChanged<bool> onMoney;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xxs,
          children: [
            _DotToggle(
              label: eventsLabel,
              selected: showEvents,
              color: AppColors.reminder,
              onSelected: onEvents,
            ),
            _DotToggle(
              label: birthdaysLabel,
              selected: showBirthdays,
              color: AppColors.birthday,
              onSelected: onBirthdays,
            ),
            _DotToggle(
              label: moneyLabel,
              selected: showMoney,
              color: AppColors.pay,
              onSelected: onMoney,
            ),
          ],
        ),
      ),
    );
  }
}

class _DotToggle extends StatelessWidget {
  const _DotToggle({
    required this.label,
    required this.selected,
    required this.color,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final Color color;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final faded = theme.colorScheme.onSurfaceVariant;
    return InkWell(
      onTap: () {
        AppHaptics.selection();
        onSelected(!selected);
      },
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: selected ? color : faded.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? theme.colorScheme.onSurface : faded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
