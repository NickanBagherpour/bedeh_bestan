import 'package:flutter/material.dart';

import '../haptics/app_haptics.dart';
import '../theme/app_spacing.dart';

/// Form field that opens a searchable list — for long party / account lists.
class KitSearchSelect<T> extends StatelessWidget {
  const KitSearchSelect({
    super.key,
    required this.label,
    required this.searchHint,
    required this.items,
    required this.labelOf,
    required this.onSelected,
    this.value,
    this.noneLabel,
    this.emptyLabel,
    this.enabled = true,
  });

  final String label;
  final String searchHint;
  final String? noneLabel;
  final String? emptyLabel;
  final List<T> items;
  final T? value;
  final String Function(T item) labelOf;
  final ValueChanged<T?> onSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = value;
    final text = selected == null ? '' : labelOf(selected);
    final isEmpty = text.isEmpty;
    return InkWell(
      onTap: enabled ? () => _open(context) : null,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          // Keep the label floated so it never sits on top of the empty-state
          // placeholder (`hintText`) — this is what caused the overlap.
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: noneLabel,
          enabled: enabled,
          suffixIcon: const Icon(Icons.search_rounded),
        ),
        // Drives `hintText` visibility: shown only while nothing is selected.
        isEmpty: isEmpty,
        child: isEmpty
            ? null
            : Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge,
              ),
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    AppHaptics.selection();
    final picked = await showModalBottomSheet<_Pick<T>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return _SearchSheet<T>(
          title: label,
          searchHint: searchHint,
          noneLabel: noneLabel,
          emptyLabel: emptyLabel,
          items: items,
          labelOf: labelOf,
          selected: value,
        );
      },
    );
    if (picked == null) return;
    onSelected(picked.clear ? null : picked.item);
  }
}

final class _Pick<T> {
  const _Pick({this.item, this.clear = false});

  final T? item;
  final bool clear;
}

class _SearchSheet<T> extends StatefulWidget {
  const _SearchSheet({
    required this.title,
    required this.searchHint,
    required this.items,
    required this.labelOf,
    required this.selected,
    this.noneLabel,
    this.emptyLabel,
  });

  final String title;
  final String searchHint;
  final String? noneLabel;
  final String? emptyLabel;
  final List<T> items;
  final String Function(T item) labelOf;
  final T? selected;

  @override
  State<_SearchSheet<T>> createState() => _SearchSheetState<T>();
}

class _SearchSheetState<T> extends State<_SearchSheet<T>> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = _query.text.trim().toLowerCase();
    final visible = [
      for (final item in widget.items)
        if (q.isEmpty || widget.labelOf(item).toLowerCase().contains(q)) item,
    ];
    final height = MediaQuery.sizeOf(context).height * 0.72;
    return SizedBox(
      height: height,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _query,
              autofocus: widget.items.length > 8,
              decoration: InputDecoration(
                labelText: widget.searchHint,
                prefixIcon: const Icon(Icons.search_rounded),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: visible.isEmpty && widget.noneLabel == null
                  ? Center(
                      child: Text(
                        widget.emptyLabel ?? widget.searchHint,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView(
                      children: [
                        if (widget.noneLabel != null)
                          ListTile(
                            title: Text(widget.noneLabel!),
                            selected: widget.selected == null,
                            onTap: () {
                              AppHaptics.selection();
                              Navigator.of(context).pop(
                                _Pick<T>(clear: true),
                              );
                            },
                          ),
                        for (final item in visible)
                          ListTile(
                            title: Text(widget.labelOf(item)),
                            selected: item == widget.selected,
                            onTap: () {
                              AppHaptics.selection();
                              Navigator.of(context).pop(_Pick<T>(item: item));
                            },
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
