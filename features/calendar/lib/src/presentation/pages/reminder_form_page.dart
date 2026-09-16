import 'package:core/core.dart'
    show
        AppRoutes,
        CalendarType,
        appSettingsProvider,
        dateOnly,
        formatLongDate,
        overlayAppBar,
        toPersianDigits;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart' show ReminderKind, RepeatRule;
import 'package:translations/translations.dart'
    show Translations, TranslationsLookup;
import 'package:ui_kit/ui_kit.dart'
    show AppHaptics, AppSpacing, KitError, KitLoading, showKitDatePicker;

import '../../application/controllers/calendar_controller.dart';
import '../../application/state/calendar_state.dart';

class ReminderFormPage extends ConsumerStatefulWidget {
  const ReminderFormPage({
    super.key,
    this.reminderId,
    this.initialDay,
  });

  final String? reminderId;
  final DateTime? initialDay;

  @override
  ConsumerState<ReminderFormPage> createState() => _ReminderFormPageState();
}

class _ReminderFormPageState extends ConsumerState<ReminderFormPage> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  final _everyN = TextEditingController(text: '2');

  DateTime _day = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  bool _allDay = false;
  RepeatRule _repeat = RepeatRule.none;
  ReminderKind _kind = ReminderKind.event;
  bool _notifyOnTime = true;
  bool _notifyDayBefore = false;
  bool _loaded = false;
  bool _saving = false;

  bool get _isEdit => widget.reminderId != null;

  @override
  void initState() {
    super.initState();
    final seed = widget.initialDay ?? DateTime.now();
    _day = dateOnly(seed);
    _time = TimeOfDay.fromDateTime(DateTime.now());
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _everyN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final calendar = ref.watch(appSettingsProvider).resolvedCalendar;
    final persian = Localizations.localeOf(context).languageCode == 'fa';
    final list = ref.watch(calendarControllerProvider);

    if (_isEdit && !_loaded) {
      final reminder = list.reminderById(widget.reminderId!);
      if (reminder != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _loaded) return;
          setState(() {
            _loaded = true;
            _title.text = reminder.title;
            _body.text = reminder.body ?? '';
            _day = dateOnly(reminder.startAt);
            _time = TimeOfDay.fromDateTime(reminder.startAt);
            _allDay = reminder.allDay;
            _kind = reminder.kind;
            _repeat = reminder.repeatRule;
            _everyN.text = '${reminder.repeatEveryN ?? 2}';
            _notifyOnTime = reminder.notifyOnTime;
            _notifyDayBefore = reminder.notifyDayBefore;
          });
        });
      } else if (list.status == CalendarStatus.loaded ||
          list.status == CalendarStatus.error) {
        return Scaffold(
          appBar: overlayAppBar(
            context: context,
            title: Text(t.calendar.editTitle),
            fallbackPath: AppRoutes.calendar.path,
            backTooltip: t.app.actions.back,
          ),
          body: list.status == CalendarStatus.error
              ? KitError(
                  message: t.message(
                    list.errorKey ?? 'calendar.missingItem',
                    shouldTranslate: true,
                  ),
                  retryLabel: t.app.actions.retry,
                  onRetry: () =>
                      ref.read(calendarControllerProvider.notifier).retry(),
                )
              : KitError(message: t.calendar.missingItem),
        );
      } else {
        return Scaffold(
          appBar: overlayAppBar(
            context: context,
            title: Text(t.calendar.editTitle),
            fallbackPath: AppRoutes.calendar.path,
            backTooltip: t.app.actions.back,
          ),
          body: const KitLoading(),
        );
      }
    }

    return Scaffold(
      appBar: overlayAppBar(
        context: context,
        title: Text(_isEdit ? t.calendar.editTitle : t.calendar.newTitle),
        fallbackPath: AppRoutes.calendar.path,
        backTooltip: t.app.actions.back,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          TextField(
            controller: _title,
            decoration: InputDecoration(labelText: t.calendar.titleField),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _body,
            decoration: InputDecoration(labelText: t.calendar.bodyField),
            minLines: 2,
            maxLines: 4,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(t.calendar.kindLabel, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final kind in ReminderKind.values)
                ChoiceChip(
                  label: Text(_kindLabel(t, kind)),
                  selected: _kind == kind,
                  onSelected: (_) {
                    AppHaptics.selection();
                    setState(() {
                      _kind = kind;
                      if (kind == ReminderKind.birthday &&
                          _repeat == RepeatRule.none) {
                        _repeat = RepeatRule.yearly;
                      }
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(t.calendar.allDay),
            value: _allDay,
            onChanged: (value) => setState(() => _allDay = value),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(t.calendar.date),
            subtitle: Text(_dateLabel(calendar, persian)),
            trailing: const Icon(Icons.event_rounded),
            onTap: _pickDate,
          ),
          if (!_allDay)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(t.calendar.time),
              subtitle: Text(_timeLabel(persian)),
              trailing: const Icon(Icons.schedule_rounded),
              onTap: _pickTime,
            ),
          const SizedBox(height: AppSpacing.sm),
          Text(t.calendar.repeat, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final rule in RepeatRule.values)
                ChoiceChip(
                  label: Text(_repeatLabel(t, rule)),
                  selected: _repeat == rule,
                  onSelected: (_) {
                    AppHaptics.selection();
                    setState(() => _repeat = rule);
                  },
                ),
            ],
          ),
          if (_repeat == RepeatRule.everyNDays) ...[
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _everyN,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: t.calendar.everyN),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(t.calendar.notifyOnTime),
            value: _notifyOnTime,
            onChanged: (value) => setState(() => _notifyOnTime = value),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(t.calendar.notifyDayBefore),
            value: _notifyDayBefore,
            onChanged: (value) => setState(() => _notifyDayBefore = value),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: _saving ? null : () => _save(t),
            child: Text(t.calendar.save),
          ),
        ],
      ),
    );
  }

  String _dateLabel(CalendarType calendar, bool persian) {
    final formatted = formatLongDate(_day, calendar);
    return persian ? toPersianDigits(formatted) : formatted;
  }

  String _timeLabel(bool persian) {
    final formatted =
        '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
    return persian ? toPersianDigits(formatted) : formatted;
  }

  Future<void> _pickDate() async {
    final t = Translations.of(context);
    final calendar = ref.read(appSettingsProvider).resolvedCalendar;
    final persian = Localizations.localeOf(context).languageCode == 'fa';
    final picked = await showKitDatePicker(
      context: context,
      initialDate: _day,
      calendar: calendar,
      persian: persian,
      weekdayLabels: _pickerWeekdays(t, calendar),
      confirmLabel: t.app.actions.confirm,
      cancelLabel: t.app.actions.cancel,
    );
    if (picked == null) return;
    setState(() => _day = dateOnly(picked));
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked == null) return;
    setState(() => _time = picked);
  }

  Future<void> _save(Translations t) async {
    final title = _title.text.trim();
    if (title.isEmpty) {
      _snack(t.calendar.missingTitle);
      return;
    }
    int? everyN;
    if (_repeat == RepeatRule.everyNDays) {
      everyN = int.tryParse(_everyN.text.trim());
      if (everyN == null || everyN < 2) {
        _snack(t.calendar.invalidRepeat);
        return;
      }
    }
    final startAt = _allDay
        ? _day
        : DateTime(_day.year, _day.month, _day.day, _time.hour, _time.minute);
    setState(() => _saving = true);
    try {
      await ref.read(calendarControllerProvider.notifier).saveDraft(
            ReminderDraft(
              id: widget.reminderId,
              title: title,
              body: _body.text,
              startAt: startAt,
              allDay: _allDay,
              kind: _kind,
              repeatRule: _repeat,
              repeatEveryN: everyN,
              notifyOnTime: _notifyOnTime,
              notifyDayBefore: _notifyDayBefore,
            ),
          );
      if (!mounted) return;
      AppHaptics.confirm();
      context.pop();
    } catch (_) {
      if (!mounted) return;
      _snack(t.calendar.saveError);
      setState(() => _saving = false);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

String _kindLabel(Translations t, ReminderKind kind) {
  return switch (kind) {
    ReminderKind.event => t.calendar.kind.event,
    ReminderKind.birthday => t.calendar.kind.birthday,
  };
}

String _repeatLabel(Translations t, RepeatRule rule) {
  return switch (rule) {
    RepeatRule.none => t.calendar.repeatRule.none,
    RepeatRule.daily => t.calendar.repeatRule.daily,
    RepeatRule.weekly => t.calendar.repeatRule.weekly,
    RepeatRule.monthly => t.calendar.repeatRule.monthly,
    RepeatRule.yearly => t.calendar.repeatRule.yearly,
    RepeatRule.everyNDays => t.calendar.repeatRule.everyNDays,
  };
}

List<String> _pickerWeekdays(Translations t, CalendarType calendar) {
  final w = t.calendar.weekday;
  return calendar == CalendarType.jalali
      ? [w.sat, w.sun, w.mon, w.tue, w.wed, w.thu, w.fri]
      : [w.mon, w.tue, w.wed, w.thu, w.fri, w.sat, w.sun];
}
