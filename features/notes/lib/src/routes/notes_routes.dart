import 'package:core/core.dart' show AppRoutes, buildRoutePage;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
