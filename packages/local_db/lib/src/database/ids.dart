import 'dart:math';

/// Stable-enough local ids (`money-…`, `party-…`, `pay-…`).
String newEntityId(String prefix) {
  final stamp = DateTime.now().toUtc().microsecondsSinceEpoch;
  final n = Random().nextInt(1 << 32);
  return '$prefix-$stamp-${n.toRadixString(16)}';
}
