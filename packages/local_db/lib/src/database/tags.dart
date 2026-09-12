import 'dart:convert';

List<String> decodeTags(String raw) {
  try {
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      return [for (final item in decoded) item.toString()];
    }
  } catch (_) {}
  return const [];
}

String encodeTags(List<String> tags) => jsonEncode(tags);
