import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart' show AppColors, AppSpacing;

class CalendarMonthHeader extends StatelessWidget {
  const CalendarMonthHeader({
    super.key,
    required this.title,
    required this.todayLabel,
    required this.onPrev,
    required this.onNext,
    required this.onToday,
  });

  final String title;
  final String todayLabel;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
        TextButton(onPressed: onToday, child: Text(todayLabel)),
      ],
    );
  }
}

class CalendarWeekdayRow extends StatelessWidget {
  const CalendarWeekdayRow({super.key, required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        for (final label in labels)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class CalendarMonthGrid extends StatelessWidget {
  const CalendarMonthGrid({
    super.key,
    required this.cells,
    required this.inMonth,
    required this.isToday,
    required this.isSelected,
    required this.hasEvents,
    required this.labelOf,
    required this.onSelect,
  });

  final List<DateTime> cells;
  final bool Function(DateTime day) inMonth;
  final bool Function(DateTime day) isToday;
  final bool Function(DateTime day) isSelected;
  final bool Function(DateTime day) hasEvents;
  final String Function(DateTime day) labelOf;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < cells.length; i += 7) {
      rows.add(
        Row(
          children: [
            for (var j = 0; j < 7; j++)
              Expanded(child: _cell(context, cells[i + j])),
          ],
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _cell(BuildContext context, DateTime day) {
    final theme = Theme.of(context);
    final selected = isSelected(day);
    final today = isToday(day);
    final outside = !inMonth(day);
    return InkWell(
      onTap: () => onSelect(day),
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: SizedBox(
        height: 44,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.reminder.withValues(alpha: 0.22)
                    : null,
                border: today && !selected
                    ? Border.all(color: AppColors.reminder)
                    : null,
                shape: BoxShape.circle,
              ),
              child: Text(
                labelOf(day),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: selected || today ? FontWeight.w800 : null,
                  color: outside
                      ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.45)
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: hasEvents(day) ? AppColors.reminder : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
