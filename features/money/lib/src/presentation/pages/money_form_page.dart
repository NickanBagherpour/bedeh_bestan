import 'package:core/core.dart'
    show
        AppRoutes,
        CalendarType,
        appSettingsProvider,
        formatLongDate,
        formatToman,
        parseTomanInput,
        toPersianDigits;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart'
    show MoneyDirection, MoneyItem, MoneySchedule, Party, PartyKind;
import 'package:translations/translations.dart' show Translations;
import 'package:ui_kit/ui_kit.dart' show AppColors, AppSpacing, KitCard;

import '../../application/controllers/money_list_controller.dart';
import '../../application/state/money_list_state.dart';
import '../money_style.dart';

class MoneyFormPage extends ConsumerStatefulWidget {
  const MoneyFormPage({
    super.key,
    this.itemId,
    this.initialDirection,
  });

  final String? itemId;
  final MoneyDirection? initialDirection;

  @override
  ConsumerState<MoneyFormPage> createState() => _MoneyFormPageState();
}

class _MoneyFormPageState extends ConsumerState<MoneyFormPage> {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  final _installmentAmount = TextEditingController();
  final _periods = TextEditingController();
  final _note = TextEditingController();
  final _partyName = TextEditingController();

  MoneyDirection _direction = MoneyDirection.pay;
  MoneySchedule _schedule = MoneySchedule.oneTime;
  PartyKind _partyKind = PartyKind.person;
  String? _partyId;
  bool _newParty = false;
  DateTime _start = DateTime.now();
  DateTime _due = DateTime.now();
  bool _loaded = false;
  bool _saving = false;

  bool get _isEdit => widget.itemId != null;

  @override
  void initState() {
    super.initState();
    _direction = widget.initialDirection ?? MoneyDirection.pay;
    final today = DateTime.now();
    _start = DateTime(today.year, today.month, today.day);
    _due = _start;
  }

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    _installmentAmount.dispose();
    _periods.dispose();
    _note.dispose();
    _partyName.dispose();
    super.dispose();
  }

  void _hydrate(MoneyItem item, Party? party) {
    if (_loaded) return;
    _loaded = true;
    _direction = item.direction;
    _schedule = item.schedule;
    _partyId = item.partyId;
    _title.text = item.title;
    _amount.text = item.totalAmount.toString();
    _note.text = item.note ?? '';
    _start = item.startDate;
    _due = item.nextDueDate;
    if (item.schedule == MoneySchedule.installment) {
      _periods.text = '${item.installmentCount ?? ''}';
      _installmentAmount.text = '${item.installmentAmount ?? ''}';
    }
    if (party != null) _partyKind = party.kind;
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final list = ref.watch(moneyListControllerProvider);
    final calendar = ref.watch(appSettingsProvider).resolvedCalendar;
    final persian = Localizations.localeOf(context).languageCode == 'fa';
    final parties = list.parties.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    if (_isEdit && !_loaded) {
      final item = _itemFrom(list);
      if (item != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _loaded) return;
          setState(() => _hydrate(item, list.partyFor(item.partyId)));
        });
      }
    } else if (!_newParty && _partyId == null && parties.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _partyId != null || _newParty) return;
        setState(() => _partyId = parties.first.id);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? t.money.editTitle : t.money.newTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Row(
            children: [
              Expanded(
                child: _DirectionCard(
                  selected: _direction == MoneyDirection.pay,
                  label: t.money.fabPay,
                  color: AppColors.pay,
                  onTap: () => setState(() => _direction = MoneyDirection.pay),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _DirectionCard(
                  selected: _direction == MoneyDirection.receive,
                  label: t.money.fabReceive,
                  color: AppColors.receive,
                  onTap: () =>
                      setState(() => _direction = MoneyDirection.receive),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(_newParty ? t.money.newParty : t.money.existingParty),
            value: _newParty,
            onChanged: parties.isEmpty
                ? null
                : (value) => setState(() {
                      _newParty = value;
                      if (!value && parties.isNotEmpty) {
                        _partyId ??= parties.first.id;
                      }
                    }),
          ),
          if (_newParty || parties.isEmpty) ...[
            TextField(
              controller: _partyName,
              decoration: InputDecoration(labelText: t.money.partyName),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              children: [
                for (final kind in PartyKind.values)
                  ChoiceChip(
                    label: Text(_kindLabel(t, kind)),
                    selected: _partyKind == kind,
                    onSelected: (_) => setState(() => _partyKind = kind),
                  ),
              ],
            ),
          ] else
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final party in parties)
                  ChoiceChip(
                    label: Text(party.name),
                    selected: _partyId == party.id,
                    onSelected: (_) => setState(() => _partyId = party.id),
                  ),
              ],
            ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _title,
            decoration: InputDecoration(labelText: t.money.titleField),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          SegmentedButton<MoneySchedule>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: MoneySchedule.oneTime,
                label: Text(t.money.oneTime),
              ),
              ButtonSegment(
                value: MoneySchedule.installment,
                label: Text(t.money.installment),
              ),
            ],
            selected: {_schedule},
            onSelectionChanged: (value) {
              setState(() => _schedule = value.first);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          if (_schedule == MoneySchedule.oneTime)
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: t.money.amount,
                suffixText: t.app.currency,
              ),
            )
          else ...[
            TextField(
              controller: _periods,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: t.money.periods),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _installmentAmount,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: t.money.installmentAmount,
                suffixText: t.app.currency,
              ),
              onChanged: (_) => setState(() {}),
            ),
            if (_computedTotal() != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                t.money.computedTotal(
                  amount: formatToman(
                    _computedTotal()!,
                    currencyLabel: t.app.currency,
                    persianDigits: persian,
                  ),
                ),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: moneyAccentFor(_direction),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
          const SizedBox(height: AppSpacing.md),
          _DateField(
            label: _schedule == MoneySchedule.installment
                ? t.money.firstDue
                : t.money.dueDate,
            value: _due,
            calendar: calendar,
            persian: persian,
            onPick: () => _pickDate(isDue: true),
          ),
          const SizedBox(height: AppSpacing.sm),
          _DateField(
            label: t.money.startDate,
            value: _start,
            calendar: calendar,
            persian: persian,
            onPick: () => _pickDate(isDue: false),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _note,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: t.money.note,
              hintText: t.money.optional,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: _saving ? null : () => _save(t),
            child: Text(t.money.save),
          ),
        ],
      ),
    );
  }

  MoneyItem? _itemFrom(MoneyListState list) {
    final id = widget.itemId;
    if (id == null) return null;
    for (final item in list.items) {
      if (item.id == id) return item;
    }
    return null;
  }

  int? _computedTotal() {
    final count = parseTomanInput(_periods.text);
    final each = parseTomanInput(_installmentAmount.text);
    if (count == null || each == null || count <= 0 || each <= 0) return null;
    return count * each;
  }

  Future<void> _pickDate({required bool isDue}) async {
    final initial = isDue ? _due : _start;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (isDue) {
        _due = DateTime(picked.year, picked.month, picked.day);
      } else {
        _start = DateTime(picked.year, picked.month, picked.day);
      }
    });
  }

  Future<void> _save(Translations t) async {
    final title = _title.text.trim();
    if (title.isEmpty) {
      _snack(t.money.missingTitle);
      return;
    }

    var partyId = _partyId;
    if (_newParty || partyId == null) {
      final name = _partyName.text.trim();
      if (name.isEmpty) {
        _snack(t.money.missingParty);
        return;
      }
      final party = await ref.read(moneyListControllerProvider.notifier).saveParty(
            name: name,
            kind: _partyKind,
          );
      if (!mounted) return;
      partyId = party.id;
    }

    int? total;
    int? installmentCount;
    int? installmentAmount;
    if (_schedule == MoneySchedule.oneTime) {
      total = parseTomanInput(_amount.text);
    } else {
      installmentCount = parseTomanInput(_periods.text);
      installmentAmount = parseTomanInput(_installmentAmount.text);
      if (installmentCount != null && installmentAmount != null) {
        total = installmentCount * installmentAmount;
      }
    }
    if (total == null || total <= 0) {
      _snack(t.money.invalidAmount);
      return;
    }
    if (_schedule == MoneySchedule.installment &&
        (installmentCount == null ||
            installmentCount < 2 ||
            installmentAmount == null ||
            installmentAmount <= 0)) {
      _snack(t.money.invalidAmount);
      return;
    }

    setState(() => _saving = true);
    try {
      final id = await ref.read(moneyListControllerProvider.notifier).saveDraft(
            MoneyDraft(
              id: widget.itemId,
              partyId: partyId,
              direction: _direction,
              title: title,
              totalAmount: total,
              schedule: _schedule,
              startDate: _start,
              nextDueDate: _due,
              installmentCount: installmentCount,
              installmentAmount: installmentAmount,
              note: _note.text.trim().isEmpty ? null : _note.text.trim(),
            ),
          );
      if (!mounted) return;
      context.go(AppRoutes.moneyItemPath(id));
    } catch (_) {
      if (!mounted) return;
      _snack(t.money.saveError);
      setState(() => _saving = false);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _DirectionCard extends StatelessWidget {
  const _DirectionCard({
    required this.selected,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final bool selected;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return KitCard(
      color: color.withValues(alpha: selected ? 0.16 : 0.06),
      onTap: onTap,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.calendar,
    required this.persian,
    required this.onPick,
  });

  final String label;
  final DateTime value;
  final CalendarType calendar;
  final bool persian;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final formatted = formatLongDate(value, calendar);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(persian ? toPersianDigits(formatted) : formatted),
      trailing: const Icon(Icons.event_rounded),
      onTap: onPick,
    );
  }
}

String _kindLabel(Translations t, PartyKind kind) {
  return switch (kind) {
    PartyKind.person => t.money.partyKind.person,
    PartyKind.bank => t.money.partyKind.bank,
    PartyKind.shop => t.money.partyKind.shop,
    PartyKind.custom => t.money.partyKind.custom,
  };
}
