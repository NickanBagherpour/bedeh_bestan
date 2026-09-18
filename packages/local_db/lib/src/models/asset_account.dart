import 'enums.dart';

final class AssetAccount {
  const AssetAccount({
    required this.id,
    required this.name,
    required this.kind,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
    this.note,
  });

  final String id;
  final String name;
  final AssetAccountKind kind;
  final int balance;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
}
