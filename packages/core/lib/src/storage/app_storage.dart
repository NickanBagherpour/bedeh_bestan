import 'package:shared_preferences/shared_preferences.dart';

/// Single gateway for persisted key/value data (settings, small flags).
///
/// Structured domain data (money, events, notes) uses the local database
/// introduced in a later phase; this is only for lightweight preferences.
final class AppStorage {
  AppStorage({required SharedPreferences preferences})
      : _preferences = preferences;

  final SharedPreferences _preferences;

  String? readString(String key) => _preferences.getString(key);

  Future<void> writeString(String key, String value) =>
      _preferences.setString(key, value);

  Map<String, String> exportKeyed(Iterable<String> keys) {
    final out = <String, String>{};
    for (final key in keys) {
      final value = readString(key);
      if (value != null) out[key] = value;
    }
    return out;
  }

  Future<void> importKeyed(Map<String, String> values) async {
    for (final entry in values.entries) {
      await writeString(entry.key, entry.value);
    }
  }

  Future<void> remove(String key) => _preferences.remove(key);

  Future<void> clear() => _preferences.clear();
}
