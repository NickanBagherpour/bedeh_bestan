import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart' show AppColors, AppSpacing, KitCard;

class CalendarAgendaList extends StatelessWidget {
  const CalendarAgendaList({
    super.key,
    required this.title,
    required this.emptyLabel,
    required this.rows,
    required this.timeOf,
    required this.repeatOf,
    required this.onTap,
    this.dateOf,
    this.addLabel,
    this.onAdd,
  });

  final String title;
  final String emptyLabel;
  final List<CalendarAgendaRow> rows;
  final String Function(CalendarAgendaRow row) timeOf;
  final String Function(CalendarAgendaRow row) repeatOf;
  final String Function(CalendarAgendaRow row)? dateOf;
  final ValueChanged<CalendarAgendaRow> onTap;
  final String? addLabel;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (addLabel != null && onAdd != null)
              TextButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(addLabel!),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (rows.isEmpty)
          Text(
            emptyLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: KitCard(
                onTap: () => onTap(row),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.reminder,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            row.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            [
                              if (dateOf != null) dateOf!(row),
                              '${timeOf(row)} · ${repeatOf(row)}',
                            ].join(' · '),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}

final class CalendarAgendaRow {
  const CalendarAgendaRow({
    required this.id,
    required this.title,
    required this.at,
    required this.allDay,
    required this.repeatKey,
  });

  final String id;
  final String title;
  final DateTime at;
  final bool allDay;
  final String repeatKey;
}
