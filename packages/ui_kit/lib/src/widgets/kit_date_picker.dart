import 'package:core/core.dart'
    show
        CalendarType,
        DateRange,
        calendarDayOfMonth,
        dateOnly,
        formatLongDate,
        formatMonthYear,
        formatWeekday,
        isSameDate,
        monthBounds,
        monthGridCells,
        shiftCalendarMonths,
        toPersianDigits;
import 'package:flutter/material.dart';

import '../haptics/app_haptics.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Calendar-aware date dialog. Jalali months stay Shamsi (not «سپتامبر»).
Future<DateTime?> showKitDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required CalendarType calendar,
  required bool persian,
  required List<String> weekdayLabels,
  required String confirmLabel,
  required String cancelLabel,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  return showDialog<DateTime>(
    context: context,
    builder: (dialogContext) {
      return _KitDatePickerDialog(
        initialDate: dateOnly(initialDate),
        calendar: calendar,
        persian: persian,
        weekdayLabels: weekdayLabels,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        firstDate: dateOnly(firstDate ?? DateTime(2000)),
        lastDate: dateOnly(lastDate ?? DateTime(2100, 12, 31)),
      );
    },
  );
}

class _KitDatePickerDialog extends StatefulWidget {
  const _KitDatePickerDialog({
    required this.initialDate,
    required this.calendar,
    required this.persian,
    required this.weekdayLabels,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime initialDate;
  final CalendarType calendar;
  final bool persian;
  final List<String> weekdayLabels;
  final String confirmLabel;
  final String cancelLabel;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_KitDatePickerDialog> createState() => _KitDatePickerDialogState();
}

class _KitDatePickerDialogState extends State<_KitDatePickerDialog> {
  late DateTime _focus;
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _focus = widget.initialDate;
    _selected = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final month = monthBounds(_focus, widget.calendar);
    final cells = monthGridCells(_focus, widget.calendar);
    final heading = formatWeekday(_selected, persian: widget.persian);
    final longDate = formatLongDate(_selected, widget.calendar);
    final title = widget.persian
        ? toPersianDigits('$heading $longDate')
        : '$heading $longDate';
    final monthTitle = widget.persian
        ? toPersianDigits(
            formatMonthYear(_focus, widget.calendar, persian: widget.persian),
          )
        : formatMonthYear(_focus, widget.calendar, persian: widget.persian);

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        0,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      title: Text(title, style: theme.textTheme.titleMedium),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => _shift(-1),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                Expanded(
                  child: Text(
                    monthTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _shift(1),
                  icon: const Icon(Icons.arrow_forward_rounded),
                ),
              ],
            ),
            Row(
              children: [
                for (final label in widget.weekdayLabels)
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            for (var i = 0; i < cells.length; i += 7)
              Row(
                children: [
                  for (var j = 0; j < 7; j++)
                    Expanded(child: _cell(theme, cells[i + j], month)),
                ],
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelLabel),
        ),
        FilledButton(
          onPressed: () {
            AppHaptics.selection();
            Navigator.of(context).pop(_selected);
          },
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }

  Widget _cell(ThemeData theme, DateTime day, DateRange month) {
    final selected = isSameDate(day, _selected);
    final outside = !month.containsDate(day);
    final disabled = day.isBefore(widget.firstDate) || day.isAfter(widget.lastDate);
    final raw = '${calendarDayOfMonth(day, widget.calendar)}';
    final label = widget.persian ? toPersianDigits(raw) : raw;
    return InkWell(
      onTap: disabled
          ? null
          : () {
              AppHaptics.selection();
              setState(() {
                _selected = dateOnly(day);
                if (!month.containsDate(day)) _focus = dateOnly(day);
              });
            },
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: SizedBox(
        height: 40,
        child: Center(
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.reminder.withValues(alpha: 0.22)
                  : null,
              shape: BoxShape.circle,
            ),
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: selected ? FontWeight.w800 : null,
                color: disabled
                    ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.28)
                    : outside
                        ? theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.45)
                        : theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _shift(int months) {
    AppHaptics.selection();
    setState(() {
      _focus = dateOnly(shiftCalendarMonths(_focus, months, widget.calendar));
    });
  }
}
