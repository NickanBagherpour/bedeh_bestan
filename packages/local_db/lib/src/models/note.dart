final class Note {
  const Note({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.pinned,
    required this.createdAt,
    required this.updatedAt,
    this.checklist = const [],
    this.partyId,
    this.moneyItemId,
  });

  Note copyWith({
    String? id,
    String? title,
    String? body,
    List<String>? tags,
    bool? pinned,
    List<ChecklistItem>? checklist,
    String? partyId,
    String? moneyItemId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearPartyId = false,
    bool clearMoneyItemId = false,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      tags: tags ?? this.tags,
      pinned: pinned ?? this.pinned,
      checklist: checklist ?? this.checklist,
      partyId: clearPartyId ? null : (partyId ?? this.partyId),
      moneyItemId: clearMoneyItemId ? null : (moneyItemId ?? this.moneyItemId),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  final String id;
  final String title;
  final String body;
  final List<String> tags;
  final bool pinned;

  /// Ordered checklist items. Empty when the note has no checklist.
  final List<ChecklistItem> checklist;
  final String? partyId;
  final String? moneyItemId;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Number of checked items over total, e.g. for a compact `2/5` progress.
  int get checklistDone {
    var done = 0;
    for (final item in checklist) {
      if (item.checked) done++;
    }
    return done;
  }
}

/// A single checklist row on a [Note]: stable [id], [text], and [checked] state.
final class ChecklistItem {
  const ChecklistItem({
    required this.id,
    required this.text,
    required this.checked,
  });

  final String id;
  final String text;
  final bool checked;

  ChecklistItem copyWith({
    String? id,
    String? text,
    bool? checked,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      text: text ?? this.text,
      checked: checked ?? this.checked,
    );
  }
}
