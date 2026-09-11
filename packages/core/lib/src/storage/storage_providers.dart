import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_storage.dart';

/// Override in `main.dart` with `SharedPreferences.getInstance()`.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw StateError('sharedPreferencesProvider must be overridden in main.dart');
});

final appStorageProvider = Provider<AppStorage>((ref) {
  return AppStorage(preferences: ref.watch(sharedPreferencesProvider));
});
