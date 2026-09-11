import 'package:flutter/material.dart';
import 'package:translations/translations.dart' show Translations;
import 'package:ui_kit/ui_kit.dart' show KitEmpty;

/// یادداشت — placeholder notes screen.
class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.notes.title)),
      body: KitEmpty(
        icon: Icons.sticky_note_2_rounded,
        title: t.notes.emptyTitle,
        body: t.notes.emptyBody,
      ),
    );
  }
}
