import 'package:core/core.dart' show AppRoutes;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart' show Note;
import 'package:translations/translations.dart'
    show Translations, TranslationsLookup;
import 'package:ui_kit/ui_kit.dart' show AppColors, AppSpacing, KitCard, KitEmpty;

import '../../application/controllers/notes_controller.dart';
import '../../application/state/notes_state.dart';

class NoteDetailPage extends ConsumerWidget {
  const NoteDetailPage({super.key, required this.noteId});

  final String noteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(notesControllerProvider);
    final note = state.noteById(noteId);

    return Scaffold(
      appBar: AppBar(
        title: Text(note?.title ?? t.notes.title),
        actions: [
          if (note != null)
            IconButton(
              tooltip: t.notes.edit,
              onPressed: () => context.push(AppRoutes.noteEditPath(noteId)),
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
      ),
      body: _body(context, ref, t, theme, state, note),
    );
  }

  Widget _body(
    BuildContext context,
    WidgetRef ref,
    Translations t,
    ThemeData theme,
    NotesState state,
    Note? note,
  ) {
    if (state.status == NotesStatus.error && note == null) {
      return KitEmpty(
        icon: Icons.error_outline_rounded,
        title: t.message(
          state.errorKey ?? 'notes.loadError',
          shouldTranslate: true,
        ),
      );
    }
    if (note == null) {
      if (state.status == NotesStatus.loaded) {
        return KitEmpty(
          icon: Icons.sticky_note_2_outlined,
          title: t.notes.missingItem,
        );
      }
      return const Center(child: CircularProgressIndicator());
    }

    final party = state.partyFor(note.partyId);
    final money = state.moneyFor(note.moneyItemId);
    final isDark = theme.brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        KitCard(
          color: isDark ? null : AppColors.note.withValues(alpha: 0.55),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (note.pinned)
                    const Icon(
                      Icons.push_pin_rounded,
                      color: AppColors.reminder,
                    ),
                ],
              ),
              if (note.body.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(note.body),
              ],
            ],
          ),
        ),
        if (note.tags.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final tag in note.tags) Chip(label: Text(tag)),
            ],
          ),
        ],
        if (party != null) ...[
          const SizedBox(height: AppSpacing.md),
          _kv(theme, t.notes.party, party.name),
        ],
        if (money != null) ...[
          const SizedBox(height: AppSpacing.xs),
          _kv(theme, t.notes.money, money.title),
          const SizedBox(height: AppSpacing.md),
          FilledButton.tonal(
            onPressed: () => context.push(AppRoutes.moneyItemPath(money.id)),
            child: Text(t.notes.openMoney),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton(
          onPressed: () async {
            await ref.read(notesControllerProvider.notifier).deleteNote(noteId);
            if (!context.mounted) return;
            context.pop();
          },
          child: Text(t.notes.delete),
        ),
      ],
    );
  }
}

Widget _kv(ThemeData theme, String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(value, style: theme.textTheme.bodyMedium),
      ],
    ),
  );
}
