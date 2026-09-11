final class Note {
  const Note({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.pinned,
    required this.createdAt,
    required this.updatedAt,
    this.partyId,
    this.moneyItemId,
  });

  Note copyWith({
    String? id,
    String? title,
    String? body,
    List<String>? tags,
    bool? pinned,
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
  final String? partyId;
  final String? moneyItemId;
  final DateTime createdAt;
  final DateTime updatedAt;
}
