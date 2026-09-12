import 'dart:convert';

import '../models/note.dart';

/// Decodes a JSON array of `{id, text, checked}` objects into checklist items.
/// Bad rows are skipped; malformed JSON yields an empty list.
List<ChecklistItem> decodeChecklist(String raw) {
  try {
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      final out = <ChecklistItem>[];
      for (final entry in decoded) {
        if (entry is! Map) continue;
        final id = entry['id'];
        final text = entry['text'];
        if (id is String && id.isNotEmpty && text is String) {
          out.add(
            ChecklistItem(
              id: id,
              text: text,
              checked: entry['checked'] == true,
            ),
          );
        }
      }
      return out;
    }
  } catch (_) {}
  return const [];
}

String encodeChecklist(List<ChecklistItem> items) => jsonEncode(
      [for (final item in items) checklistItemJson(item)],
    );

Map<String, Object?> checklistItemJson(ChecklistItem item) => {
      'id': item.id,
      'text': item.text,
      'checked': item.checked,
    };
