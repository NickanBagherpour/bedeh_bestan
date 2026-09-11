/// Font family resolution.
///
/// BedeBestan bundles [vazirmatn] (a modern Persian/Latin family) and uses it
/// for every locale so text never falls back to a downloaded web font.
abstract final class AppFonts {
  static const String vazirmatn = 'Vazirmatn';

  static String familyFor(String languageCode) => vazirmatn;

  static bool isRtlLanguage(String languageCode) {
    final code = languageCode.toLowerCase();
    return code == 'fa' || code.startsWith('fa_') || code == 'ar';
  }
}
