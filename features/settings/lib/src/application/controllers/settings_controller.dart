import 'dart:ui' show Locale;

import 'package:core/core.dart'
    show
        AppCurrency,
        AppSettings,
        AppSettingsKeys,
        AppStyle,
        CalendarPreference,
        MoneyReminderMode,
        UpdateCheckOutcome,
        appSettingsProvider,
        appStorageProvider,
        isUpdateAvailable;
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:local_db/local_db.dart'
    show BackupException, appDatabaseProvider;
import 'package:translations/translations.dart'
    show LocaleSettings, appLocaleFromLanguageCode;

import '../../data/backup_repository.dart';
import '../../data/bazaar_update_check.dart';
import '../../data/update_check_repository.dart';

enum BackupActionResult { saved, restored, cancelled, failed }

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

final class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.watch(appSettingsProvider);

  Future<void> setThemeMode(ThemeMode mode) {
    return ref.read(appSettingsProvider.notifier).setThemeMode(mode);
  }

  Future<void> setAppStyle(AppStyle style) {
    return ref.read(appSettingsProvider.notifier).setAppStyle(style);
  }

  Future<void> setLocale(Locale locale) async {
    await ref.read(appSettingsProvider.notifier).setLocale(locale);
    await LocaleSettings.setLocale(
      appLocaleFromLanguageCode(locale.languageCode),
    );
  }

  Future<void> setCalendar(CalendarPreference calendar) {
    return ref.read(appSettingsProvider.notifier).setCalendar(calendar);
  }

  Future<void> setCurrency(AppCurrency currency) {
    return ref.read(appSettingsProvider.notifier).setCurrency(currency);
  }

  Future<void> setMoneyReminderMode(MoneyReminderMode mode) {
    return ref.read(appSettingsProvider.notifier).setMoneyReminderMode(mode);
  }

  Future<void> setMoneyReminderDaysBefore(List<int> days) {
    return ref.read(appSettingsProvider.notifier).setMoneyReminderDaysBefore(days);
  }

  Future<void> setShowCalendarEvents(bool value) {
    return ref.read(appSettingsProvider.notifier).setShowCalendarEvents(value);
  }

  Future<void> setShowCalendarBirthdays(bool value) {
    return ref.read(appSettingsProvider.notifier).setShowCalendarBirthdays(value);
  }

  Future<void> setShowCalendarMoney(bool value) {
    return ref.read(appSettingsProvider.notifier).setShowCalendarMoney(value);
  }

  /// Bazaar update service on Android, else [store/version.json] over HTTPS.
  Future<({UpdateCheckOutcome outcome, String? latestVersion})>
      checkForStoreUpdate() async {
    try {
      final bazaar = await checkBazaarUpdateAvailable();
      if (bazaar == true) {
        return (
          outcome: UpdateCheckOutcome.updateAvailable,
          latestVersion: null,
        );
      }
      if (bazaar == false) {
        return (outcome: UpdateCheckOutcome.upToDate, latestVersion: null);
      }

      final info = await PackageInfo.fromPlatform();
      final installed = int.tryParse(info.buildNumber) ?? 0;
      final manifest =
          await ref.read(updateCheckRepositoryProvider).fetchLatestManifest();
      if (manifest == null) {
        return (outcome: UpdateCheckOutcome.checkFailed, latestVersion: null);
      }
      final newer = isUpdateAvailable(
        installedBuild: installed,
        latestBuild: manifest.latestBuild,
      );
      return (
        outcome: newer
            ? UpdateCheckOutcome.updateAvailable
            : UpdateCheckOutcome.upToDate,
        latestVersion: manifest.latestVersion,
      );
    } catch (_) {
      return (outcome: UpdateCheckOutcome.checkFailed, latestVersion: null);
    }
  }

  Future<BackupActionResult> exportBackup({required String fileName}) async {
    try {
      final repo = _backup();
      final json = await repo.buildFile();
      final saved = await repo.saveToDisk(json, fileName: fileName);
      return saved ? BackupActionResult.saved : BackupActionResult.cancelled;
    } catch (_) {
      return BackupActionResult.failed;
    }
  }

  Future<BackupActionResult> importBackup() async {
    try {
      final repo = _backup();
      final raw = await repo.pickFromDisk();
      if (raw == null) return BackupActionResult.cancelled;
      await repo.applyFile(raw);
      await ref.read(appSettingsProvider.notifier).reloadFromStorage();
      final next = ref.read(appSettingsProvider);
      await LocaleSettings.setLocale(
        appLocaleFromLanguageCode(next.locale.languageCode),
      );
      return BackupActionResult.restored;
    } on BackupException catch (_) {
      return BackupActionResult.failed;
    } catch (_) {
      return BackupActionResult.failed;
    }
  }

  BackupRepository _backup() {
    final storage = ref.read(appStorageProvider);
    return BackupRepository(
      database: ref.read(appDatabaseProvider),
      readSettings: () => storage.exportKeyed(AppSettingsKeys.all),
      writeSettings: storage.importKeyed,
    );
  }
}
