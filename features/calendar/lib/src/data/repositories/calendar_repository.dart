import 'package:local_db/local_db.dart'
    show AppDatabase, MoneyItem, Reminder, newEntityId;

final class CalendarRepository {
  CalendarRepository({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  Stream<List<Reminder>> watchReminders() => _database.watchReminders();

  Stream<List<MoneyItem>> watchMoneyItems() => _database.watchMoneyItems();

  Future<Reminder?> getReminder(String id) => _database.getReminder(id);

  Future<void> upsertReminder(Reminder reminder) {
    return _database.upsertReminder(reminder);
  }

  Future<void> deleteReminder(String id) => _database.deleteReminder(id);

  String nextId() => newEntityId('rem');
}
