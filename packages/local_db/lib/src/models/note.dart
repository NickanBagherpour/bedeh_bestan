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
