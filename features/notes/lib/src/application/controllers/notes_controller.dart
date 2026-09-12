import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart'
    show ChecklistItem, MoneyItem, Note, Party;

import '../../data/repositories/notes_repository_provider.dart';
import '../state/notes_state.dart';

final notesControllerProvider = NotifierProvider<NotesController, NotesState>(
  NotesController.new,
);

final class NotesController extends Notifier<NotesState> {
  @override
  NotesState build() {
    final repo = ref.watch(notesRepositoryProvider);
    var notes = <Note>[];
    var parties = <String, Party>{};
    var moneyItems = <String, MoneyItem>{};

    void emit() {
      state = state.copyWith(
        status: NotesStatus.loaded,
        notes: notes,
        parties: parties,
        moneyItems: moneyItems,
        clearError: true,
      );
    }

    void onError(_) {
      state = state.copyWith(
        status: NotesStatus.error,
        errorKey: 'notes.loadError',
      );
    }

    final notesSub = repo.watchNotes().listen(
      (value) {
        notes = value;
        emit();
      },
      onError: onError,
    );
    final partiesSub = repo.watchParties().listen(
      (value) {
        parties = {for (final party in value) party.id: party};
        emit();
      },
      onError: onError,
    );
    final moneySub = repo.watchMoneyItems().listen(
      (value) {
        moneyItems = {for (final item in value) item.id: item};
        emit();
      },
      onError: onError,
    );
    ref.onDispose(() {
      notesSub.cancel();
      partiesSub.cancel();
      moneySub.cancel();
    });
    return const NotesState(status: NotesStatus.loading);
  }

  void retry() => ref.invalidateSelf();

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setTag(String? tag) {
    state = state.copyWith(tag: tag, clearTag: tag == null || tag.isEmpty);
  }

  Future<String> saveDraft(NoteDraft draft) async {
    final repo = ref.read(notesRepositoryProvider);
    final now = DateTime.now();
    final existing = draft.id == null ? null : await repo.getNote(draft.id!);
    final note = Note(
      id: draft.id ?? repo.nextId(),
      title: draft.title.trim(),
      body: draft.body.trim(),
      tags: draft.tags,
      pinned: draft.pinned,
      checklist: _cleanChecklist(draft.checklist),
      partyId: _blankToNull(draft.partyId),
      moneyItemId: _blankToNull(draft.moneyItemId),
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
    await repo.upsertNote(note);
    return note.id;
  }

  Future<void> togglePin(String id) async {
    final existing = await ref.read(notesRepositoryProvider).getNote(id);
    if (existing == null) return;
    await ref.read(notesRepositoryProvider).upsertNote(
          existing.copyWith(pinned: !existing.pinned, updatedAt: DateTime.now()),
        );
  }

  Future<void> deleteNote(String id) {
    return ref.read(notesRepositoryProvider).deleteNote(id);
  }

  /// Flips the checked state of one checklist item and persists the note.
  Future<void> toggleChecklistItem(String noteId, String itemId) async {
    final repo = ref.read(notesRepositoryProvider);
    final existing = await repo.getNote(noteId);
    if (existing == null) return;
    var changed = false;
    final checklist = [
      for (final item in existing.checklist)
        if (item.id == itemId)
          () {
            changed = true;
            return item.copyWith(checked: !item.checked);
          }()
        else
          item,
    ];
    if (!changed) return;
    await repo.upsertNote(
      existing.copyWith(checklist: checklist, updatedAt: DateTime.now()),
    );
  }
}

List<ChecklistItem> _cleanChecklist(List<ChecklistItem> items) {
  return [
    for (final item in items)
      if (item.text.trim().isNotEmpty)
        item.copyWith(text: item.text.trim()),
  ];
}

String? _blankToNull(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  return value;
}
