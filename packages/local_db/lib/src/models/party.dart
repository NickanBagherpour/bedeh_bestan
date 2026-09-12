import 'enums.dart';

final class Party {
  const Party({
    required this.id,
    required this.name,
    required this.kind,
    required this.createdAt,
    required this.updatedAt,
    this.note,
    this.phone,
    this.nationalCode,
    this.birthDate,
    this.cardNumber,
    this.sheba,
  });

  Party copyWith({
    String? id,
    String? name,
    PartyKind? kind,
    String? note,
    String? phone,
    String? nationalCode,
    String? birthDate,
    String? cardNumber,
    String? sheba,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearNote = false,
    bool clearPhone = false,
    bool clearNationalCode = false,
    bool clearBirthDate = false,
    bool clearCardNumber = false,
    bool clearSheba = false,
  }) {
    return Party(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      note: clearNote ? null : (note ?? this.note),
      phone: clearPhone ? null : (phone ?? this.phone),
      nationalCode:
          clearNationalCode ? null : (nationalCode ?? this.nationalCode),
      birthDate: clearBirthDate ? null : (birthDate ?? this.birthDate),
      cardNumber: clearCardNumber ? null : (cardNumber ?? this.cardNumber),
      sheba: clearSheba ? null : (sheba ?? this.sheba),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  final String id;
  final String name;
  final PartyKind kind;
  final String? note;
  final String? phone;
  final String? nationalCode;
  final String? birthDate;
  final String? cardNumber;
  final String? sheba;
  final DateTime createdAt;
  final DateTime updatedAt;
}
