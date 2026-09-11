import 'generated/strings.g.dart';

/// BedeBestan default locale is Persian (`fa`).
///
/// Call during app bootstrap (before `runApp`) so end-user strings resolve
/// to `fa` unless the user switches language.
Future<AppLocale> useAppDefaultLocale() {
  return LocaleSettings.setLocale(AppLocale.fa);
}

/// Maps a Flutter language code to [AppLocale], defaulting to `fa`.
AppLocale appLocaleFromLanguageCode(String? languageCode) {
  final code = languageCode?.toLowerCase() ?? 'fa';
  if (code == 'en' || code.startsWith('en_')) {
    return AppLocale.en;
  }
  return AppLocale.fa;
}
