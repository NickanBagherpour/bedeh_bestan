import 'package:local_db/local_db.dart' show MoneyItem, Note, Party;

import '../note_query.dart';

enum NotesStatus { initial, loading, loaded, error }

final class NotesState {
  const NotesState({
    this.status = NotesStatus.initial,
    this.notes = const [],
    this.parties = const {},
    this.moneyItems = const {},
    this.query = '',
    this.tag,
    this.errorKey,
  });

  final NotesStatus status;
  final List<Note> notes;
  final Map<String, Party> parties;
  final Map<String, MoneyItem> moneyItems;
  final String query;
  final String? tag;
  final String? errorKey;

  List<Note> get visible => visibleNotes(
        notes: notes,
        query: query,
        tag: tag,
      );

  List<String> get tags => uniqueTags(notes);

  Note? noteById(String id) {
    for (final note in notes) {
      if (note.id == id) return note;
    }
    return null;
  }

  Party? partyFor(String? id) => id == null ? null : parties[id];

  MoneyItem? moneyFor(String? id) => id == null ? null : moneyItems[id];

  NotesState copyWith({
    NotesStatus? status,
    List<Note>? notes,
    Map<String, Party>? parties,
    Map<String, MoneyItem>? moneyItems,
    String? query,
    String? tag,
    String? errorKey,
    bool clearTag = false,
    bool clearError = false,
  }) {
    return NotesState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      parties: parties ?? this.parties,
      moneyItems: moneyItems ?? this.moneyItems,
      query: query ?? this.query,
      tag: clearTag ? null : (tag ?? this.tag),
      errorKey: clearError ? null : (errorKey ?? this.errorKey),
    );
  }
}

final class NoteDraft {
  const NoteDraft({
    this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.pinned,
    this.partyId,
    this.moneyItemId,
  });

  final String? id;
  final String title;
  final String body;
  final List<String> tags;
  final bool pinned;
  final String? partyId;
  final String? moneyItemId;
}
