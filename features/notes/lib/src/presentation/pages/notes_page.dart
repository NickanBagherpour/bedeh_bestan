import 'package:core/core.dart' show AppRoutes;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart' show Note;
import 'package:translations/translations.dart'
    show Translations, TranslationsLookup;
import 'package:ui_kit/ui_kit.dart'
    show
        AppHaptics,
        AppSpacing,
        KitEmpty,
        KitError,
        KitLoading,
        KitScrollHideFab;

import '../../application/controllers/notes_controller.dart';
import '../../application/state/notes_state.dart';
import '../widgets/note_tile.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final state = ref.watch(notesControllerProvider);
    final visible = state.visible;

    return KitScrollHideFab(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(t.notes.title),
      ),
      fab: FloatingActionButton.extended(
        onPressed: () {
          AppHaptics.light();
          context.push(AppRoutes.notesNew.path);
        },
        icon: const Icon(Icons.note_add_outlined),
        label: Text(t.notes.fab),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.xs,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: t.notes.search,
                      prefixIcon: const Icon(Icons.search_rounded),
                    ),
                    onChanged: (value) {
                      ref.read(notesControllerProvider.notifier).setQuery(value);
                    },
                  ),
                  if (state.tags.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: [
                          FilterChip(
                            label: Text(t.notes.allTags),
                            selected: state.tag == null,
                            onSelected: (_) {
                              AppHaptics.selection();
                              ref
                                  .read(notesControllerProvider.notifier)
                                  .setTag(null);
                            },
                          ),
                          for (final tag in state.tags)
                            FilterChip(
                              label: Text(tag),
                              selected: state.tag == tag,
                              onSelected: (selected) {
                                AppHaptics.selection();
                                ref
                                    .read(notesControllerProvider.notifier)
                                    .setTag(selected ? tag : null);
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          ..._bodySlivers(context, ref, t, state, visible),
        ],
      ),
    );
  }

  List<Widget> _bodySlivers(
    BuildContext context,
    WidgetRef ref,
    Translations t,
    NotesState state,
    List<Note> visible,
  ) {
    if (state.status == NotesStatus.error) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: KitError(
            message: t.message(
              state.errorKey ?? 'notes.loadError',
              shouldTranslate: true,
            ),
            retryLabel: t.app.actions.retry,
            onRetry: () => ref.read(notesControllerProvider.notifier).retry(),
          ),
        ),
      ];
    }
    if (state.status == NotesStatus.loading) {
      return [
        const SliverFillRemaining(
          hasScrollBody: false,
          child: KitLoading(),
        ),
      ];
    }
    if (state.notes.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: KitEmpty(
            icon: Icons.sticky_note_2_rounded,
            title: t.notes.emptyTitle,
            body: t.notes.emptyBody,
            action: FilledButton.tonal(
              onPressed: () {
                AppHaptics.light();
                context.push(AppRoutes.notesNew.path);
              },
              child: Text(t.notes.fab),
            ),
          ),
        ),
      ];
    }
    if (visible.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: KitEmpty(
            icon: Icons.filter_alt_outlined,
            title: t.notes.emptyFilter,
            body: t.notes.emptyBody,
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          88,
        ),
        sliver: SliverList.separated(
          itemCount: visible.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final note = visible[index];
            final party = state.partyFor(note.partyId);
            final money = state.moneyFor(note.moneyItemId);
            final meta = [
              if (party != null) party.name,
              if (money != null) money.title,
            ].join(' · ');
            return NoteTile(
              title: note.title,
              body: note.body,
              tags: note.tags,
              pinned: note.pinned,
              meta: meta.isEmpty ? null : meta,
              checklistDone: note.checklistDone,
              checklistTotal: note.checklist.length,
              onTap: () => context.push(AppRoutes.notePath(note.id)),
              onPin: () {
                AppHaptics.selection();
                ref.read(notesControllerProvider.notifier).togglePin(note.id);
              },
            );
          },
        ),
      ),
    ];
  }
}
