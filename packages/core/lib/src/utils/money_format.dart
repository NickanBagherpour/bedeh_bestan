import 'package:flutter/services.dart';

import 'currency.dart';

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

/// Parses a typed amount (ASCII or Persian digits, optional grouping).
int? parseTomanInput(String input) {
  final normalized = fromPersianDigits(input).replaceAll(RegExp(r'[^0-9]'), '');
  if (normalized.isEmpty) return null;
  return int.tryParse(normalized);
}

/// Groups an integer with thousands separators.
///
/// Persian: `۱٬۲۳۴٬۵۶۷` (U+066C). Latin: `1,234,567`.
String groupAmount(int amount, {bool persianDigits = true}) {
  final negative = amount < 0;
  final digits = amount.abs().toString();
  final sep = persianDigits ? '٬' : ',';
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i != 0 && (digits.length - i) % 3 == 0) buffer.write(sep);
    buffer.write(digits[i]);
  }
  final grouped = buffer.toString();
  final out = persianDigits ? toPersianDigits(grouped) : grouped;
  return negative ? '−$out' : out;
}

/// Grouped amount plus [currencyLabel] (from slang).
String formatMoney(
  int amount, {
  String? currencyLabel,
  bool persianDigits = true,
}) {
  final grouped = groupAmount(amount, persianDigits: persianDigits);
  if (currencyLabel == null || currencyLabel.isEmpty) return grouped;
  return '$grouped $currencyLabel';
}

/// Formats a stored toman amount in the user's [currency].
String formatStoredMoney(
  int storedToman, {
  required AppCurrency currency,
  required String currencyLabel,
  bool persianDigits = true,
}) {
  return formatMoney(
    currency.toDisplay(storedToman),
    currencyLabel: currencyLabel,
    persianDigits: persianDigits,
  );
}

/// Parses a typed display amount back into stored toman units.
int? parseStoredAmount(String input, AppCurrency currency) {
  final displayed = parseTomanInput(input);
  if (displayed == null) return null;
  return currency.toStored(displayed);
}

/// @nodoc Kept for older call sites; prefer [formatMoney].
String formatToman(
  int amount, {
  String? currencyLabel,
  bool persianDigits = true,
}) {
  return formatMoney(
    amount,
    currencyLabel: currencyLabel,
    persianDigits: persianDigits,
  );
}

/// Live thousands grouping while typing.
class GroupedAmountFormatter extends TextInputFormatter {
  const GroupedAmountFormatter({required this.persianDigits});

  final bool persianDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final parsed = parseTomanInput(newValue.text);
    if (parsed == null) return oldValue;
    final grouped = groupAmount(parsed, persianDigits: persianDigits);
    return TextEditingValue(
      text: grouped,
      selection: TextSelection.collapsed(offset: grouped.length),
    );
  }
}
