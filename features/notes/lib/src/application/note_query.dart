import 'package:local_db/local_db.dart' show Note;

List<String> parseTagInput(String raw) {
  final out = <String>[];
  final seen = <String>{};
  for (final part in raw.split(RegExp(r'[,،]'))) {
    final tag = part.trim();
    if (tag.isEmpty) continue;
    final key = tag.toLowerCase();
    if (seen.add(key)) out.add(tag);
  }
  return out;
}

List<Note> visibleNotes({
  required List<Note> notes,
  required String query,
  String? tag,
}) {
  final q = query.trim().toLowerCase();
  final filtered = [
    for (final note in notes)
      if (_matches(note, query: q, tag: tag)) note,
  ];
  filtered.sort((a, b) {
    if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
    return b.updatedAt.compareTo(a.updatedAt);
  });
  return filtered;
}

List<String> uniqueTags(List<Note> notes) {
  final tags = <String>{};
  for (final note in notes) {
    tags.addAll(note.tags);
  }
  final list = tags.toList()..sort();
  return list;
}

bool _matches(Note note, {required String query, String? tag}) {
  if (tag != null && tag.isNotEmpty && !note.tags.contains(tag)) {
    return false;
  }
  if (query.isEmpty) return true;
  if (note.title.toLowerCase().contains(query)) return true;
  if (note.body.toLowerCase().contains(query)) return true;
  return note.tags.any((value) => value.toLowerCase().contains(query));
}
