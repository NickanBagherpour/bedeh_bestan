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

  final String id;
  final String name;
  final PartyKind kind;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
}
