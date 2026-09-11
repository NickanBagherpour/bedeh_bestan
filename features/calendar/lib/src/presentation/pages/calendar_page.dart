import 'package:core/core.dart'
    show
        AppRoutes,
        CalendarType,
        appSettingsProvider,
        dateOnly,
        formatMonthYear,
        formatTime,
        monthBounds,
        monthGridCells,
        shiftCalendarMonths,
        toPersianDigits;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:translations/translations.dart'
    show Translations, TranslationsLookup;
import 'package:ui_kit/ui_kit.dart' show AppSpacing, KitEmpty;

import '../../application/controllers/calendar_controller.dart';
import '../../application/occurrences.dart';
import '../../application/state/calendar_state.dart';
import '../widgets/calendar_agenda_list.dart';
import '../widgets/calendar_month_grid.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  late DateTime _focus;
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focus = dateOnly(now);
    _selected = _focus;
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final state = ref.watch(calendarControllerProvider);
    final calendar = ref.watch(appSettingsProvider).resolvedCalendar;
    final persian = Localizations.localeOf(context).languageCode == 'fa';
    final month = monthBounds(_focus, calendar);
    final cells = monthGridCells(_focus, calendar);
    final occurrences = expandOccurrences(
      reminders: state.reminders,
      rangeStart: cells.first,
      rangeEnd: cells.last,
      calendar: calendar,
    );
    final eventDays = {
      for (final row in occurrences) dateOnly(row.at),
    };
    final dayRows = [
      for (final row in occurrences)
        if (dateOnly(row.at) == _selected)
          CalendarAgendaRow(
            id: row.reminder.id,
            title: row.reminder.title,
            at: row.at,
            allDay: row.reminder.allDay,
            repeatKey: 'calendar.repeatRule.${row.reminder.repeatRule.name}',
          ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(t.calendar.title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.reminderNewPath(day: _selected)),
        icon: const Icon(Icons.notification_add_outlined),
        label: Text(t.calendar.fab),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          88,
        ),
        children: [
          CalendarMonthHeader(
            title: _monthTitle(month.start, calendar, persian),
            todayLabel: t.calendar.today,
            onPrev: () => _shift(-1, calendar),
            onNext: () => _shift(1, calendar),
            onToday: () {
              final today = dateOnly(DateTime.now());
              setState(() {
                _focus = today;
                _selected = today;
              });
            },
          ),
          CalendarWeekdayRow(labels: _weekdayLabels(t, calendar)),
          CalendarMonthGrid(
            cells: cells,
            inMonth: month.containsDate,
            isToday: (day) => day == dateOnly(DateTime.now()),
            isSelected: (day) => day == _selected,
            hasEvents: eventDays.contains,
            labelOf: (day) {
              final raw = '${day.day}';
              return persian ? toPersianDigits(raw) : raw;
            },
            onSelect: (day) {
              setState(() {
                _selected = day;
                if (!month.containsDate(day)) _focus = day;
              });
            },
          ),
          const SizedBox(height: AppSpacing.md),
          if (state.status == CalendarStatus.error)
            KitEmpty(
              icon: Icons.error_outline_rounded,
              title: t.message(
                state.errorKey ?? 'calendar.loadError',
                shouldTranslate: true,
              ),
              body: t.calendar.emptyBody,
            )
          else
            CalendarAgendaList(
              title: t.calendar.agenda,
              emptyLabel: t.calendar.emptyDay,
              rows: dayRows,
              timeOf: (row) {
                if (row.allDay) return t.calendar.allDay;
                final time = formatTime(row.at);
                return persian ? toPersianDigits(time) : time;
              },
              repeatOf: (row) => t.message(row.repeatKey, shouldTranslate: true),
              onTap: (row) => context.push(AppRoutes.reminderPath(row.id)),
            ),
        ],
      ),
    );
  }

  void _shift(int months, CalendarType calendar) {
    final next = dateOnly(shiftCalendarMonths(_focus, months, calendar));
    setState(() {
      _focus = next;
      if (!monthBounds(next, calendar).containsDate(_selected)) {
        _selected = next;
      }
    });
  }

  String _monthTitle(DateTime day, CalendarType calendar, bool persian) {
    final title = formatMonthYear(day, calendar, persian: persian);
    return persian ? toPersianDigits(title) : title;
  }

  List<String> _weekdayLabels(Translations t, CalendarType calendar) {
    final sat = t.calendar.weekday.sat;
    final sun = t.calendar.weekday.sun;
    final mon = t.calendar.weekday.mon;
    final tue = t.calendar.weekday.tue;
    final wed = t.calendar.weekday.wed;
    final thu = t.calendar.weekday.thu;
    final fri = t.calendar.weekday.fri;
    return calendar == CalendarType.jalali
        ? [sat, sun, mon, tue, wed, thu, fri]
        : [mon, tue, wed, thu, fri, sat, sun];
  }
}
