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
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: [
          _chip(
            label: eventsLabel,
            selected: showEvents,
            color: AppColors.reminder,
            onSelected: onEvents,
          ),
          _chip(
            label: birthdaysLabel,
            selected: showBirthdays,
            color: AppColors.birthday,
            onSelected: onBirthdays,
          ),
          _chip(
            label: moneyLabel,
            selected: showMoney,
            color: AppColors.pay,
            onSelected: onMoney,
          ),
        ],
      ),
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required Color color,
    required ValueChanged<bool> onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (value) {
        AppHaptics.selection();
        onSelected(value);
      },
      selectedColor: color.withValues(alpha: 0.22),
      checkmarkColor: color,
      side: BorderSide(color: color.withValues(alpha: selected ? 0.8 : 0.35)),
    );
  }
}
