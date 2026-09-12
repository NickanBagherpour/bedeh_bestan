import 'package:local_db/local_db.dart' show AppDatabase, Reminder, newEntityId;

final class CalendarRepository {
  CalendarRepository({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  Stream<List<Reminder>> watchReminders() => _database.watchReminders();

  Future<Reminder?> getReminder(String id) => _database.getReminder(id);

  Future<void> upsertReminder(Reminder reminder) {
    return _database.upsertReminder(reminder);
  }

  Future<void> deleteReminder(String id) => _database.deleteReminder(id);

  String nextId() => newEntityId('rem');
}
