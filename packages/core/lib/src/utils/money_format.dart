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
String formatToman(int amount, {String? currencyLabel}) {
  final grouped = groupAmount(amount);
  if (currencyLabel == null || currencyLabel.isEmpty) return grouped;
  return '$grouped $currencyLabel';
}
