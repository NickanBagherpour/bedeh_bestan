import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// Override in `main.dart` after [AppDatabase.open] + seed.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw StateError('appDatabaseProvider must be overridden in main.dart');
});
