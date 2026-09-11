import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart' show appDatabaseProvider;

import 'money_repository.dart';

final moneyRepositoryProvider = Provider<MoneyRepository>((ref) {
  return MoneyRepository(database: ref.watch(appDatabaseProvider));
});
