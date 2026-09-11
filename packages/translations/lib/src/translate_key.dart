import 'generated/strings.g.dart';

/// Runtime lookup for slang keys coming from data (status ids, seed copy).
///
/// Typed `t.home.title` stays the default for UI copy. Use this when the key
/// is data. Add the string to `*_en.i18n.json` / `*_fa.i18n.json` and run
/// `melos run translations`.
extension TranslationsLookup on Translations {
  String translate(String key) {
    if (key.isEmpty) return key;
    final value = this[key];
    return value is String && value.isNotEmpty ? value : key;
  }

  String message(String text, {required bool shouldTranslate}) {
    if (!shouldTranslate) return text;
    return translate(text);
  }
}
