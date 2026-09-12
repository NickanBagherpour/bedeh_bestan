import 'package:local_db/local_db.dart'
    show AppDatabase, MoneyItem, Note, Party, newEntityId;

final class NotesRepository {
  NotesRepository({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  Stream<List<Note>> watchNotes() => _database.watchNotes();

  Stream<List<Party>> watchParties() => _database.watchParties();

  Stream<List<MoneyItem>> watchMoneyItems() => _database.watchMoneyItems();

  Future<Note?> getNote(String id) => _database.getNote(id);

  Future<void> upsertNote(Note note) => _database.upsertNote(note);

  Future<void> deleteNote(String id) => _database.deleteNote(id);

  String nextId() => newEntityId('note');

  String nextChecklistId() => newEntityId('chk');
}
