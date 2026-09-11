import 'package:local_db/local_db.dart' show AppDatabase, LibrarySnapshot;

final class HomeRepository {
  HomeRepository({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  Future<LibrarySnapshot> snapshot() => _database.snapshot();
}
