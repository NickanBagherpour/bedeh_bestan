import 'package:core/core.dart'
    show
        AppRoutes,
        CalendarType,
        appSettingsProvider,
        calendarDayOfMonth,
        dateOnly,
        formatHeadingDate,
        formatMonthYear,
        formatTime,
        formatWeekday,
        isSameDate,
        monthBounds,
        monthGridCells,
        shiftCalendarMonths,
        toPersianDigits;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:translations/translations.dart'
    show Translations, TranslationsLookup;
import 'package:ui_kit/ui_kit.dart' show AppHaptics, AppSpacing, KitError, KitLoading;

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
  bool _monthOpen = true;

  @override
  void initState() {
    super.initState();
    final today = dateOnly(DateTime.now());
    _focus = today;
    _selected = today;
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final state = ref.watch(calendarControllerProvider);
    final calendar = ref.watch(appSettingsProvider).resolvedCalendar;
    final persian = Localizations.localeOf(context).languageCode == 'fa';
    final today = dateOnly(DateTime.now());
    final month = monthBounds(_focus, calendar);
    final cells = monthGridCells(_focus, calendar);
    final gridOccurrences = expandOccurrences(
      reminders: state.reminders,
      rangeStart: cells.first,
      rangeEnd: cells.last,
      calendar: calendar,
    );
    final eventDays = {
      for (final row in gridOccurrences) dateOnly(row.at),
    };
    CalendarAgendaRow agendaRowOf(CalendarOccurrence row) {
      return CalendarAgendaRow(
        id: row.reminder.id,
        title: row.reminder.title,
        at: row.at,
        allDay: row.reminder.allDay,
        repeatKey: 'calendar.repeatRule.${row.reminder.repeatRule.name}',
      );
    }

    final dayRows = [
      for (final row in gridOccurrences)
        if (isSameDate(row.at, _selected)) agendaRowOf(row),
    ];
    final monthRows = [
      for (final row in gridOccurrences)
        if (month.containsDate(row.at)) agendaRowOf(row),
    ];

    String timeLabel(CalendarAgendaRow row) {
      if (row.allDay) return t.calendar.allDay;
      final time = formatTime(row.at);
      return persian ? toPersianDigits(time) : time;
    }

    String repeatLabel(CalendarAgendaRow row) {
      return t.message(row.repeatKey, shouldTranslate: true);
    }

    String dateLabel(CalendarAgendaRow row) {
      final formatted = formatHeadingDate(row.at, calendar, persian: persian);
      return persian ? toPersianDigits(formatted) : formatted;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(t.calendar.title),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNew(context),
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
          CalendarTodayBanner(
            label: _todayHeading(t, today, calendar, persian),
          ),
          CalendarMonthHeader(
            title: _monthTitle(month.start, calendar, persian),
            todayLabel: t.calendar.today,
            monthToggleLabel:
                _monthOpen ? t.calendar.hideMonth : t.calendar.showMonth,
            monthOpen: _monthOpen,
            onPrev: () {
              AppHaptics.selection();
              _shift(-1, calendar);
            },
            onNext: () {
              AppHaptics.selection();
              _shift(1, calendar);
            },
            onToday: () {
              AppHaptics.selection();
              setState(() {
                _focus = today;
                _selected = today;
              });
            },
            onToggleMonth: () {
              AppHaptics.selection();
              setState(() => _monthOpen = !_monthOpen);
            },
          ),
          if (_monthOpen) ...[
            CalendarWeekdayRow(labels: _weekdayLabels(t, calendar)),
            CalendarMonthGrid(
              cells: cells,
              inMonth: month.containsDate,
              isToday: (day) => isSameDate(day, today),
              isSelected: (day) => isSameDate(day, _selected),
              hasEvents: eventDays.contains,
              labelOf: (day) {
                final raw = '${calendarDayOfMonth(day, calendar)}';
                return persian ? toPersianDigits(raw) : raw;
              },
              onSelect: (day) {
                AppHaptics.selection();
                setState(() {
                  _selected = dateOnly(day);
                  if (!month.containsDate(day)) _focus = dateOnly(day);
                });
              },
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          if (state.status == CalendarStatus.error)
            KitError(
              message: t.message(
                state.errorKey ?? 'calendar.loadError',
                shouldTranslate: true,
              ),
              retryLabel: t.app.actions.retry,
              onRetry: () =>
                  ref.read(calendarControllerProvider.notifier).retry(),
            )
          else if (state.status == CalendarStatus.loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
              child: KitLoading(),
            )
          else ...[
            CalendarAgendaList(
              title: t.calendar.agenda,
              emptyLabel: t.calendar.emptyDay,
              rows: dayRows,
              addLabel: t.calendar.addForDay,
              onAdd: () => _openNew(context),
              timeOf: timeLabel,
              repeatOf: repeatLabel,
              onTap: (row) => context.push(AppRoutes.reminderPath(row.id)),
            ),
            const SizedBox(height: AppSpacing.lg),
            CalendarAgendaList(
              title: t.calendar.monthAgenda,
              emptyLabel: t.calendar.emptyTitle,
              rows: monthRows,
              dateOf: dateLabel,
              timeOf: timeLabel,
              repeatOf: repeatLabel,
              onTap: (row) {
                setState(() => _selected = dateOnly(row.at));
                context.push(AppRoutes.reminderPath(row.id));
              },
            ),
          ],
        ],
      ),
    );
  }

  void _openNew(BuildContext context) {
    AppHaptics.light();
    context.push(AppRoutes.reminderNewPath(day: _selected));
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

  String _todayHeading(
    Translations t,
    DateTime today,
    CalendarType calendar,
    bool persian,
  ) {
    final weekday = formatWeekday(today, persian: persian);
    final date = formatHeadingDate(today, calendar, persian: persian);
    final heading = t.calendar.todayHeading(
      weekday: weekday,
      date: persian ? toPersianDigits(date) : date,
    );
    return heading;
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
