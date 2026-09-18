import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart' show AppColors, AppSpacing;

class CalendarTodayBanner extends StatelessWidget {
  const CalendarTodayBanner({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        label,
        style: theme.textTheme.titleMedium?.copyWith(
          color: AppColors.onTint(AppColors.reminder),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class CalendarMonthHeader extends StatelessWidget {
  const CalendarMonthHeader({
    super.key,
    required this.title,
    required this.todayLabel,
    required this.monthToggleLabel,
    required this.monthOpen,
    required this.onPrev,
    required this.onNext,
    required this.onToday,
    required this.onToggleMonth,
  });

  final String title;
  final String todayLabel;
  final String monthToggleLabel;
  final bool monthOpen;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onToday;
  final VoidCallback onToggleMonth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
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
          ],
        ),
        Row(
          children: [
            TextButton(onPressed: onToday, child: Text(todayLabel)),
            const Spacer(),
            TextButton.icon(
              onPressed: onToggleMonth,
              icon: Icon(
                monthOpen
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
              ),
              label: Text(monthToggleLabel),
            ),
          ],
        ),
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
    required this.eventColorsOf,
    required this.labelOf,
    required this.onSelect,
  });

  final List<DateTime> cells;
  final bool Function(DateTime day) inMonth;
  final bool Function(DateTime day) isToday;
  final bool Function(DateTime day) isSelected;
  final List<Color> Function(DateTime day) eventColorsOf;
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
        height: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.reminder.withValues(alpha: 0.22)
                    : null,
                border: today
                    ? Border.all(color: AppColors.reminder, width: 1.5)
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
            _EventDots(colors: eventColorsOf(day)),
          ],
        ),
      ),
    );
  }
}

class _EventDots extends StatelessWidget {
  const _EventDots({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final shown = colors.take(3).toList();
    if (shown.isEmpty) {
      return const SizedBox(width: 5, height: 5);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < shown.length; i++) ...[
          if (i > 0) const SizedBox(width: 2),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: shown[i],
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }
}
