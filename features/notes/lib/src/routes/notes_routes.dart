import 'package:core/core.dart' show AppRoutes, buildRoutePage;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/note_detail_page.dart';
import '../presentation/pages/note_form_page.dart';
import '../presentation/pages/notes_page.dart';

List<RouteBase> buildNotesRoutes(Ref ref) {
  return [
    GoRoute(
      path: AppRoutes.notes.path,
      name: AppRoutes.notes.name,
      pageBuilder: (context, state) =>
          buildRoutePage(state: state, child: const NotesPage()),
    ),
  ];
}

/// Form / detail sit above [AppShell] so the bottom nav is hidden.
List<RouteBase> buildNotesOverlayRoutes(Ref ref) {
  return [
    GoRoute(
      path: AppRoutes.notesNew.path,
      name: AppRoutes.notesNew.name,
      pageBuilder: (context, state) {
        return buildRoutePage(
          state: state,
          child: const NoteFormPage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.notesItem.path,
      name: AppRoutes.notesItem.name,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return buildRoutePage(
          state: state,
          child: NoteDetailPage(noteId: id),
        );
      },
      routes: [
        GoRoute(
          path: 'edit',
          name: AppRoutes.notesEdit.name,
          pageBuilder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return buildRoutePage(
              state: state,
              child: NoteFormPage(noteId: id),
            );
          },
        ),
      ],
    ),
  ];
}
