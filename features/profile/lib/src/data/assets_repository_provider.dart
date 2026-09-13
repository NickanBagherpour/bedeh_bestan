import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart' show appDatabaseProvider;

import 'assets_repository.dart';

final assetsRepositoryProvider = Provider<AssetsRepository>((ref) {
  return AssetsRepository(database: ref.watch(appDatabaseProvider));
});
