import 'enums.dart';

final class Party {
  const Party({
    required this.id,
    required this.name,
    required this.kind,
    required this.createdAt,
    required this.updatedAt,
    this.note,
  });

  Party copyWith({
    String? id,
    String? name,
    PartyKind? kind,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearNote = false,
  }) {
    return Party(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      note: clearNote ? null : (note ?? this.note),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  final String id;
  final String name;
  final PartyKind kind;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
}
