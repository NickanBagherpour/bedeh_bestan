const List<String> _persianDigits = [
  '۰',
  '۱',
  '۲',
  '۳',
  '۴',
  '۵',
  '۶',
  '۷',
  '۸',
  '۹',
];

/// Converts ASCII digits in [input] to Persian digits.
String toPersianDigits(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    if (rune >= 0x30 && rune <= 0x39) {
      buffer.write(_persianDigits[rune - 0x30]);
    } else {
      buffer.write(String.fromCharCode(rune));
    }
  }
  return buffer.toString();
}

/// Converts Persian / Arabic-Indic digits in [input] to ASCII.
String fromPersianDigits(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    if (rune >= 0x06F0 && rune <= 0x06F9) {
      buffer.writeCharCode(0x30 + (rune - 0x06F0));
    } else if (rune >= 0x0660 && rune <= 0x0669) {
      buffer.writeCharCode(0x30 + (rune - 0x0660));
    } else {
      buffer.write(String.fromCharCode(rune));
    }
  }
  return buffer.toString();
}

/// Parses a typed Toman amount (ASCII or Persian digits, optional grouping).
int? parseTomanInput(String input) {
  final normalized = fromPersianDigits(input).replaceAll(RegExp(r'[^0-9]'), '');
  if (normalized.isEmpty) return null;
  return int.tryParse(normalized);
}

/// Groups an integer amount with thousands separators.
///
/// `1234567` → `۱٬۲۳۴٬۵۶۷` (Arabic thousands separator U+066C).
String groupAmount(int amount, {bool persianDigits = true}) {
  final negative = amount < 0;
  final digits = amount.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i != 0 && (digits.length - i) % 3 == 0) buffer.write('٬');
    buffer.write(digits[i]);
  }
  final grouped = buffer.toString();
  final out = persianDigits ? toPersianDigits(grouped) : grouped;
  return negative ? '−$out' : out;
}

/// Grouped Toman amount. Pass [currencyLabel] from `t.app.currency` in UI.
String formatToman(
  int amount, {
  String? currencyLabel,
  bool persianDigits = true,
}) {
  final grouped = groupAmount(amount, persianDigits: persianDigits);
  if (currencyLabel == null || currencyLabel.isEmpty) return grouped;
  return '$grouped $currencyLabel';
}
