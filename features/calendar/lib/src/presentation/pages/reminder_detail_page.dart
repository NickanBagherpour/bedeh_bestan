import 'package:core/core.dart'
    show
        AppRoutes,
        CalendarType,
        appSettingsProvider,
        formatLongDate,
        formatTime,
        toPersianDigits;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart' show Reminder, RepeatRule;
import 'package:translations/translations.dart'
    show Translations, TranslationsLookup;
import 'package:ui_kit/ui_kit.dart' show AppColors, AppSpacing, KitCard, KitEmpty;

import '../../application/controllers/calendar_controller.dart';
import '../../application/state/calendar_state.dart';

class ReminderDetailPage extends ConsumerWidget {
  const ReminderDetailPage({super.key, required this.reminderId});

  final String reminderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(calendarControllerProvider);
    final calendar = ref.watch(appSettingsProvider).resolvedCalendar;
    final persian = Localizations.localeOf(context).languageCode == 'fa';
    final reminder = state.reminderById(reminderId);

    return Scaffold(
      appBar: AppBar(
        title: Text(reminder?.title ?? t.calendar.title),
        actions: [
          if (reminder != null)
            IconButton(
              tooltip: t.calendar.edit,
              onPressed: () =>
                  context.push(AppRoutes.reminderEditPath(reminderId)),
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
      ),
      body: _body(context, ref, t, theme, state, reminder, calendar, persian),
    );
  }

  Widget _body(
    BuildContext context,
    WidgetRef ref,
    Translations t,
    ThemeData theme,
    CalendarState state,
    Reminder? reminder,
    CalendarType calendar,
    bool persian,
  ) {
    if (state.status == CalendarStatus.error && reminder == null) {
      return KitEmpty(
        icon: Icons.error_outline_rounded,
        title: t.message(
          state.errorKey ?? 'calendar.missingItem',
          shouldTranslate: true,
        ),
      );
    }
    if (reminder == null) {
      if (state.status == CalendarStatus.loaded) {
        return KitEmpty(
          icon: Icons.event_busy_rounded,
          title: t.calendar.missingItem,
        );
      }
      return const Center(child: CircularProgressIndicator());
    }

    final when = formatLongDate(reminder.startAt, calendar);
    final time = reminder.allDay ? t.calendar.allDay : formatTime(reminder.startAt);
    final whenLabel = persian ? toPersianDigits(when) : when;
    final timeLabel = reminder.allDay
        ? time
        : (persian ? toPersianDigits(time) : time);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        KitCard(
          color: AppColors.reminder.withValues(alpha: 0.10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                reminder.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (reminder.body != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(reminder.body!),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _kv(theme, t.calendar.date, whenLabel),
        _kv(theme, t.calendar.time, timeLabel),
        _kv(theme, t.calendar.repeat, _repeatLabel(t, reminder.repeatRule)),
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton(
          onPressed: () async {
            await ref
                .read(calendarControllerProvider.notifier)
                .deleteReminder(reminderId);
            if (!context.mounted) return;
            context.pop();
          },
          child: Text(t.calendar.delete),
        ),
      ],
    );
  }
}

Widget _kv(ThemeData theme, String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(value, style: theme.textTheme.bodyMedium),
      ],
    ),
  );
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
