import 'package:core/core.dart'
    show
        AppCurrency,
        AppRoutes,
        AppStyle,
        CalendarPreference,
        MoneyReminderMode,
        overlayAppBar;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:translations/translations.dart' show Translations;
import 'package:ui_kit/ui_kit.dart'
    show AppHaptics, AppSpacing, KitReminderDaysPicker;

import '../../application/controllers/settings_controller.dart';
import '../widgets/settings_choice_row.dart';
import '../widgets/settings_section.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: overlayAppBar(
        context: context,
        title: Text(t.settings.title),
        fallbackPath: AppRoutes.home.path,
        backTooltip: t.app.actions.back,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          SettingsSection(
            title: t.settings.theme,
            child: SettingsChoiceRow<ThemeMode>(
              value: settings.themeMode,
              options: const [
                ThemeMode.system,
                ThemeMode.light,
                ThemeMode.dark,
              ],
              labelFor: (mode) => switch (mode) {
                ThemeMode.light => t.app.theme.light,
                ThemeMode.dark => t.app.theme.dark,
                ThemeMode.system => t.app.theme.system,
              },
              onChanged: controller.setThemeMode,
            ),
          ),
          SettingsSection(
            title: t.settings.style,
            footer: t.settings.styleHint,
            child: SettingsChoiceRow<AppStyle>(
              value: settings.appStyle,
              options: AppStyle.values,
              labelFor: (style) => switch (style) {
                AppStyle.classic => t.app.style.classic,
                AppStyle.glass => t.app.style.glass,
              },
              onChanged: controller.setAppStyle,
            ),
          ),
          SettingsSection(
            title: t.settings.language,
            child: SettingsChoiceRow<String>(
              value: settings.locale.languageCode,
              options: const ['fa', 'en'],
              labelFor: (code) =>
                  code == 'fa' ? t.app.language.fa : t.app.language.en,
              onChanged: (code) => controller.setLocale(Locale(code)),
            ),
          ),
          SettingsSection(
            title: t.settings.calendar,
            footer: t.settings.calendarHint,
            child: SettingsChoiceRow<CalendarPreference>(
              value: settings.calendar,
              options: CalendarPreference.values,
              labelFor: (value) => switch (value) {
                CalendarPreference.jalali => t.settings.jalali,
                CalendarPreference.gregorian => t.settings.gregorian,
              },
              onChanged: controller.setCalendar,
            ),
          ),
          SettingsSection(
            title: t.settings.currency,
            footer: t.settings.currencyHint,
            child: SettingsChoiceRow<AppCurrency>(
              value: settings.currency,
              options: AppCurrency.values,
              labelFor: (value) => switch (value) {
                AppCurrency.toman => t.app.currency.toman,
                AppCurrency.rial => t.app.currency.rial,
                AppCurrency.usd => t.app.currency.usd,
              },
              onChanged: controller.setCurrency,
            ),
          ),
          SettingsSection(
            title: t.settings.calendarItems,
            footer: t.settings.calendarItemsHint,
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(t.settings.showEvents),
                  value: settings.showCalendarEvents,
                  onChanged: controller.setShowCalendarEvents,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(t.settings.showBirthdays),
                  value: settings.showCalendarBirthdays,
                  onChanged: controller.setShowCalendarBirthdays,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(t.settings.showMoney),
                  value: settings.showCalendarMoney,
                  onChanged: controller.setShowCalendarMoney,
                ),
              ],
            ),
          ),
          SettingsSection(
            title: t.settings.reminders,
            footer: t.settings.remindersHint,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SettingsChoiceRow<MoneyReminderMode>(
                  value: settings.moneyReminderMode,
                  options: MoneyReminderMode.values,
                  labelFor: (mode) => switch (mode) {
                    MoneyReminderMode.exactDay => t.settings.reminderExactDay,
                    MoneyReminderMode.range => t.settings.reminderRange,
                  },
                  onChanged: controller.setMoneyReminderMode,
                ),
                if (settings.moneyReminderMode == MoneyReminderMode.range) ...[
                  const SizedBox(height: AppSpacing.sm),
                  KitReminderDaysPicker(
                    selected: settings.moneyReminderDaysBefore,
                    onChanged: controller.setMoneyReminderDaysBefore,
                    daysBeforeLabel: t.settings.reminderDaysBefore,
                    customLabel: t.settings.reminderCustomDay,
                    addLabel: t.settings.reminderAddDay,
                    labelFor: (day) => switch (day) {
                      7 => t.settings.reminderDay7,
                      3 => t.settings.reminderDay3,
                      2 => t.settings.reminderDay2,
                      1 => t.settings.reminderDay1,
                      _ => t.settings.reminderDay1.replaceFirst('1', '$day'),
                    },
                  ),
                ],
                const SizedBox(height: AppSpacing.xs),
                Text(
                  t.settings.reminderTimeHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SettingsSection(
            title: t.settings.backup,
            footer: t.settings.backupHint,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.file_upload_outlined),
                  title: Text(t.settings.exportBackup),
                  onTap: () => _runBackup(
                    context,
                    t,
                    () => controller.exportBackup(
                      fileName: t.settings.backupFileName,
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.file_download_outlined),
                  title: Text(t.settings.importBackup),
                  onTap: () => _runBackup(context, t, controller.importBackup),
                ),
              ],
            ),
          ),
          SettingsSection(
            title: t.settings.about,
            footer: t.settings.privacyBody,
            child: const _AppVersionTile(),
          ),
          Text(
            t.app.latinName,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _runBackup(
  BuildContext context,
  Translations t,
  Future<BackupActionResult> Function() action,
) async {
  AppHaptics.selection();
  final result = await action();
  if (!context.mounted) return;
  final message = switch (result) {
    BackupActionResult.saved => t.settings.backupSaved,
    BackupActionResult.restored => t.settings.backupRestored,
    BackupActionResult.cancelled => t.settings.backupCancelled,
    BackupActionResult.failed => t.settings.backupFailed,
  };
  if (result == BackupActionResult.saved ||
      result == BackupActionResult.restored) {
    AppHaptics.confirm();
  }
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

class _AppVersionTile extends StatelessWidget {
  const _AppVersionTile();

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return FutureBuilder<PackageInfo?>(
      future: _packageInfo(),
      builder: (context, snapshot) {
        final version = snapshot.data?.version;
        if (version == null || version.isEmpty) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.info_outline_rounded),
            title: Text(t.settings.privacy),
          );
        }
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.info_outline_rounded),
          title: Text(t.settings.version(version: version)),
          subtitle: Text(t.settings.privacy),
        );
      },
    );
  }
}

Future<PackageInfo?> _packageInfo() async {
  try {
    return await PackageInfo.fromPlatform();
  } catch (_) {
    return null;
  }
}
