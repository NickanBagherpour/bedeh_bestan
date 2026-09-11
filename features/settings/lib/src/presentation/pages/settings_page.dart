import 'package:core/core.dart' show AppCurrency, CalendarPreference;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translations/translations.dart' show Translations;
import 'package:ui_kit/ui_kit.dart' show AppSpacing;

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
      appBar: AppBar(title: Text(t.settings.title)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          SettingsSection(
            title: t.settings.theme,
            child: SettingsChoiceRow<ThemeMode>(
              label: t.app.theme.label,
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
            title: t.settings.language,
            child: SettingsChoiceRow<String>(
              label: t.app.language.label,
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
              label: t.settings.calendar,
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
              label: t.settings.currency,
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
