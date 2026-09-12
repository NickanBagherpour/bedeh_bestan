import 'package:feature_notes/src/application/note_query.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart' show Note;

void main() {
  final now = DateTime(2026, 9, 11, 12);

  Note note({
    required String id,
    required String title,
    String body = '',
    List<String> tags = const [],
    bool pinned = false,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id,
      title: title,
      body: body,
      tags: tags,
      pinned: pinned,
      createdAt: now,
      updatedAt: updatedAt ?? now,
    );
  }

  test('parseTagInput splits on comma and Arabic comma and de-dupes', () {
    expect(
      parseTagInput(' بانک ، شبا, بانک,  '),
      ['بانک', 'شبا'],
    );
  });

  test('visibleNotes search title, body, and tags', () {
    final notes = [
      note(id: 'a', title: 'شبا بانک ملی', tags: const ['بانک']),
      note(id: 'b', title: 'قرار', body: 'پنجشنبه', tags: const ['طلب']),
      note(id: 'c', title: 'خرید خانه', tags: const ['خرید']),
    ];

    expect(
      visibleNotes(notes: notes, query: 'شبا').map((item) => item.id),
      ['a'],
    );
    expect(
      visibleNotes(notes: notes, query: 'پنجشنبه').map((item) => item.id),
      ['b'],
    );
    expect(
      visibleNotes(notes: notes, query: 'خرید').map((item) => item.id),
      ['c'],
    );
  });

  test('visibleNotes pins first then newest updatedAt', () {
    final older = now.subtract(const Duration(hours: 2));
    final notes = [
      note(id: 'old', title: 'کهنه', updatedAt: older),
      note(id: 'new', title: 'تازه', updatedAt: now),
      note(id: 'pin', title: 'سنجاق', pinned: true, updatedAt: older),
    ];

    expect(
      visibleNotes(notes: notes, query: '').map((item) => item.id),
      ['pin', 'new', 'old'],
    );
  });

  test('visibleNotes filters by exact tag and uniqueTags sorts', () {
    final notes = [
      note(id: 'a', title: 'one', tags: const ['بانک', 'شبا']),
      note(id: 'b', title: 'two', tags: const ['طلب']),
    ];
    expect(
      visibleNotes(notes: notes, query: '', tag: 'بانک').map((item) => item.id),
      ['a'],
    );
    expect(uniqueTags(notes), ['بانک', 'شبا', 'طلب']);
  });
}
