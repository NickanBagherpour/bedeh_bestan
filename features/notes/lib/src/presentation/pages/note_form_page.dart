import 'package:core/core.dart' show AppRoutes, overlayAppBar;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart' show ChecklistItem, MoneyItem, Party;
import 'package:translations/translations.dart' show Translations;
import 'package:ui_kit/ui_kit.dart'
    show AppHaptics, AppSpacing, KitError, KitLoading, KitSearchSelect;

import '../../application/controllers/notes_controller.dart';
import '../../application/note_query.dart';
import '../../application/state/notes_state.dart';
import '../../data/repositories/notes_repository_provider.dart';

class NoteFormPage extends ConsumerStatefulWidget {
  const NoteFormPage({super.key, this.noteId});

  final String? noteId;

  @override
  ConsumerState<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends ConsumerState<NoteFormPage> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  final _tags = TextEditingController();
  final List<_ChecklistRow> _checklist = [];
  bool _pinned = false;
  String? _partyId;
  String? _moneyItemId;
  bool _loaded = false;
  bool _saving = false;

  bool get _isEdit => widget.noteId != null;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _tags.dispose();
    for (final row in _checklist) {
      row.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final state = ref.watch(notesControllerProvider);

    if (_isEdit && !_loaded) {
      final note = state.noteById(widget.noteId!);
      if (note != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _loaded) return;
          setState(() {
            _loaded = true;
            _title.text = note.title;
            _body.text = note.body;
            _tags.text = note.tags.join('، ');
            _pinned = note.pinned;
            _partyId = note.partyId;
            _moneyItemId = note.moneyItemId;
            _checklist
              ..clear()
              ..addAll([
                for (final item in note.checklist)
                  _ChecklistRow(
                    id: item.id,
                    controller: TextEditingController(text: item.text),
                    checked: item.checked,
                  ),
              ]);
          });
        });
      }
      return Scaffold(
        appBar: overlayAppBar(
          context: context,
          title: Text(t.notes.editTitle),
          fallbackPath: AppRoutes.notes.path,
          backTooltip: t.app.actions.back,
        ),
        body: note == null && state.status == NotesStatus.loaded
            ? KitError(message: t.notes.missingItem)
            : const KitLoading(),
      );
    }

    final parties = state.parties.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    final moneyItems = [
      for (final item in state.moneyItems.values)
        if (_partyId == null || item.partyId == _partyId) item,
    ]..sort((a, b) => a.title.compareTo(b.title));
    Party? selectedParty;
    for (final party in parties) {
      if (party.id == _partyId) {
        selectedParty = party;
        break;
      }
    }
    MoneyItem? selectedMoney;
    for (final item in moneyItems) {
      if (item.id == _moneyItemId) {
        selectedMoney = item;
        break;
      }
    }

    return Scaffold(
      appBar: overlayAppBar(
        context: context,
        title: Text(_isEdit ? t.notes.editTitle : t.notes.newTitle),
        fallbackPath: AppRoutes.notes.path,
        backTooltip: t.app.actions.back,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          TextField(
            controller: _title,
            decoration: InputDecoration(labelText: t.notes.titleField),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _body,
            decoration: InputDecoration(labelText: t.notes.bodyField),
            minLines: 4,
            maxLines: 8,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _tags,
            decoration: InputDecoration(
              labelText: t.notes.tagsField,
              hintText: t.notes.tagsHint,
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(t.notes.pinned),
            value: _pinned,
            onChanged: (value) => setState(() => _pinned = value),
          ),
          const SizedBox(height: AppSpacing.sm),
          ..._checklistSection(t),
          const SizedBox(height: AppSpacing.sm),
          KitSearchSelect<Party>(
            label: t.notes.party,
            searchHint: t.notes.searchParty,
            noneLabel: t.notes.none,
            emptyLabel: t.notes.emptyFilter,
            items: parties,
            value: selectedParty,
            labelOf: (party) => party.name,
            onSelected: (party) {
              setState(() {
                _partyId = party?.id;
                final money = state.moneyFor(_moneyItemId);
                if (money != null &&
                    _partyId != null &&
                    money.partyId != _partyId) {
                  _moneyItemId = null;
                }
              });
            },
          ),
          const SizedBox(height: AppSpacing.md),
          KitSearchSelect<MoneyItem>(
            label: t.notes.money,
            searchHint: t.notes.searchMoney,
            noneLabel: t.notes.none,
            emptyLabel: t.notes.emptyFilter,
            items: moneyItems,
            value: selectedMoney,
            labelOf: (item) => item.title,
            onSelected: (item) {
              setState(() {
                _moneyItemId = item?.id;
                if (_moneyItemId != null) {
                  final partyId = state.moneyFor(_moneyItemId)?.partyId;
                  if (partyId != null && partyId != _partyId) {
                    _partyId = partyId;
                  }
                }
              });
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: _saving ? null : () => _save(t),
            child: Text(t.notes.save),
          ),
        ],
      ),
    );
  }

  List<Widget> _checklistSection(Translations t) {
    final theme = Theme.of(context);
    return [
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          t.notes.checklist,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.xs),
      for (final row in _checklist)
        Padding(
          key: ValueKey(row.id),
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Row(
            children: [
              Checkbox(
                value: row.checked,
                onChanged: (value) =>
                    setState(() => row.checked = value ?? false),
              ),
              Expanded(
                child: TextField(
                  controller: row.controller,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: t.notes.checklistItemHint,
                  ),
                ),
              ),
              IconButton(
                tooltip: t.notes.removeItem,
                onPressed: () => _removeChecklistRow(row),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton.icon(
          onPressed: _addChecklistRow,
          icon: const Icon(Icons.add_rounded),
          label: Text(t.notes.addItem),
        ),
      ),
    ];
  }

  void _addChecklistRow() {
    final id = ref.read(notesRepositoryProvider).nextChecklistId();
    setState(() {
      _checklist.add(
        _ChecklistRow(
          id: id,
          controller: TextEditingController(),
          checked: false,
        ),
      );
    });
  }

  void _removeChecklistRow(_ChecklistRow row) {
    setState(() => _checklist.remove(row));
    row.controller.dispose();
  }

  List<ChecklistItem> _collectChecklist() {
    return [
      for (final row in _checklist)
        if (row.controller.text.trim().isNotEmpty)
          ChecklistItem(
            id: row.id,
            text: row.controller.text.trim(),
            checked: row.checked,
          ),
    ];
  }

  Future<void> _save(Translations t) async {
    final title = _title.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.notes.missingTitle)),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(notesControllerProvider.notifier).saveDraft(
            NoteDraft(
              id: widget.noteId,
              title: title,
              body: _body.text,
              tags: parseTagInput(_tags.text),
              pinned: _pinned,
              checklist: _collectChecklist(),
              partyId: _partyId,
              moneyItemId: _moneyItemId,
            ),
          );
      if (!mounted) return;
      AppHaptics.confirm();
      context.pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.notes.saveError)),
      );
      setState(() => _saving = false);
    }
  }
}

class _ChecklistRow {
  _ChecklistRow({
    required this.id,
    required this.controller,
    required this.checked,
  });

  final String id;
  final TextEditingController controller;
  bool checked;
}
