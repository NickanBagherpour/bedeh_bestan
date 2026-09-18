import 'package:core/core.dart'
    show
        AppCurrency,
        AppRoutes,
        CalendarType,
        GroupedAmountFormatter,
        MoneyItemReminderPolicy,
        appSettingsProvider,
        decodeDaysBeforeJson,
        encodeDaysBeforeJson,
        formatLongDate,
        formatMoney,
        groupAmount,
        moneyItemReminderPolicyFromStorage,
        moneyItemReminderPolicyToStorage,
        overlayAppBar,
        parseStoredAmount,
        parseTomanInput,
        toPersianDigits;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart'
    show MoneyDirection, MoneyItem, MoneySchedule, Party, PartyKind;
import 'package:translations/translations.dart' show Translations;
import 'package:ui_kit/ui_kit.dart'
    show
        AppColors,
        AppHaptics,
        AppSpacing,
        KitCard,
        KitReminderDaysPicker,
        KitSearchSelect,
        showKitDatePicker;

import '../../application/controllers/money_list_controller.dart';
import '../../application/money_query.dart';
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
  MoneyItemReminderPolicy _reminderPolicy = MoneyItemReminderPolicy.defaultPolicy;
  List<int> _reminderDays = const [7, 2];
  List<InstallmentDraftRow> _installmentRows = const [];
  bool _scheduleCustomized = false;
  String? _lastScheduleSeed;

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

  void _hydrate(
    MoneyItem item,
    Party? party, {
    required AppCurrency currency,
    required bool persian,
    required CalendarType calendar,
  }) {
    if (_loaded) return;
    _loaded = true;
    _direction = item.direction;
    _schedule = item.schedule;
    _partyId = item.partyId;
    _title.text = item.title;
    _amount.text = groupAmount(
      currency.toDisplay(item.totalAmount),
      persianDigits: persian,
    );
    _note.text = item.note ?? '';
    _start = item.startDate;
    _due = item.nextDueDate;
    _reminderPolicy = moneyItemReminderPolicyFromStorage(item.reminderPolicy);
    final customDays = decodeDaysBeforeJson(item.reminderDaysBeforeJson);
    _reminderDays = customDays.isEmpty ? const [7, 2] : customDays;
    if (item.schedule == MoneySchedule.installment) {
      _periods.text = '${item.installmentCount ?? ''}';
      final each = item.installmentAmount;
      _installmentAmount.text = each == null
          ? ''
          : groupAmount(currency.toDisplay(each), persianDigits: persian);
      if (item.installments.isNotEmpty) {
        _installmentRows = [
          for (final row in item.installments)
            InstallmentDraftRow(
              id: row.id,
              index: row.index,
              dueDate: row.dueDate,
              amount: row.amount,
            ),
        ];
        final baseline = each ?? _installmentRows.first.amount;
        _scheduleCustomized =
            _installmentRows.any((row) => row.amount != baseline);
      } else {
        final count = item.installmentCount;
        final amount = each ??
            (count != null && count > 0
                ? (item.totalAmount / count).round()
                : null);
        if (count != null && amount != null && amount > 0) {
          _installmentRows = buildEqualInstallmentDraft(
            count: count,
            amount: amount,
            startDate: item.startDate,
            calendar: calendar,
          );
        }
      }
      _lastScheduleSeed = _scheduleSeed(calendar, currency);
    }
    if (party != null) _partyKind = party.kind;
  }

  String _scheduleSeed(CalendarType calendar, AppCurrency currency) {
    final count = parseTomanInput(_periods.text) ?? 0;
    final each = parseStoredAmount(_installmentAmount.text, currency) ?? 0;
    return '$count|$each|${_due.toIso8601String()}|${calendar.name}';
  }

  void _syncInstallmentSchedule(CalendarType calendar, AppCurrency currency) {
    if (_schedule != MoneySchedule.installment || _scheduleCustomized) return;
    final count = parseTomanInput(_periods.text);
    final each = parseStoredAmount(_installmentAmount.text, currency);
    if (count == null || each == null || count < 2 || each <= 0) {
      if (_installmentRows.isNotEmpty) {
        setState(() {
          _installmentRows = const [];
          _lastScheduleSeed = null;
        });
      }
      return;
    }
    final seed = _scheduleSeed(calendar, currency);
    if (seed == _lastScheduleSeed && _installmentRows.length == count) {
      return;
    }
    setState(() {
      _installmentRows = buildEqualInstallmentDraft(
        count: count,
        amount: each,
        startDate: _due,
        calendar: calendar,
        previous: _installmentRows,
      );
      _lastScheduleSeed = seed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final list = ref.watch(moneyListControllerProvider);
    final calendar = ref.watch(appSettingsProvider).resolvedCalendar;
    final currency = ref.watch(appSettingsProvider).currency;
    final persian = Localizations.localeOf(context).languageCode == 'fa';
    final currencyLabel = currencyLabelOf(t, currency);
    final parties = list.parties.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    if (_isEdit && !_loaded) {
      final item = _itemFrom(list);
      if (item != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _loaded) return;
          setState(
            () => _hydrate(
              item,
              list.partyFor(item.partyId),
              currency: currency,
              persian: persian,
              calendar: calendar,
            ),
          );
        });
      }
    } else if (!_newParty && _partyId == null && parties.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _partyId != null || _newParty) return;
        setState(() => _partyId = parties.first.id);
      });
    }

    if (_schedule == MoneySchedule.installment && !_scheduleCustomized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _syncInstallmentSchedule(calendar, currency);
      });
    }

    return Scaffold(
      appBar: overlayAppBar(
        context: context,
        title: Text(_isEdit ? t.money.editTitle : t.money.newTitle),
        fallbackPath: AppRoutes.money.path,
        backTooltip: t.app.actions.back,
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
                  onTap: () {
                    AppHaptics.selection();
                    setState(() => _direction = MoneyDirection.pay);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _DirectionCard(
                  selected: _direction == MoneyDirection.receive,
                  label: t.money.fabReceive,
                  color: AppColors.receive,
                  onTap: () {
                    AppHaptics.selection();
                    setState(() => _direction = MoneyDirection.receive);
                  },
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
                    label: Text(partyKindLabel(t, kind)),
                    selected: _partyKind == kind,
                    onSelected: (_) {
                      AppHaptics.selection();
                      setState(() => _partyKind = kind);
                    },
                  ),
              ],
            ),
          ] else ...[
            KitSearchSelect<Party>(
              label: t.money.party,
              searchHint: t.money.searchParty,
              emptyLabel: t.money.emptyPartyFilter,
              items: parties,
              value: _selectedParty(parties),
              labelOf: (party) => party.name,
              onSelected: (party) {
                if (party == null) return;
                setState(() => _partyId = party.id);
              },
            ),
            if (_isEdit && _partyId != null && _partyId!.isNotEmpty)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: () =>
                      context.push(AppRoutes.partyItemPath(_partyId!)),
                  child: Text(t.money.viewParty),
                ),
              ),
          ],
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
              AppHaptics.selection();
              setState(() {
                _schedule = value.first;
                if (_schedule != MoneySchedule.installment) {
                  _installmentRows = const [];
                  _scheduleCustomized = false;
                  _lastScheduleSeed = null;
                }
              });
            },
          ),
          const SizedBox(height: AppSpacing.md),
          if (_schedule == MoneySchedule.oneTime)
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              inputFormatters: [
                GroupedAmountFormatter(persianDigits: persian),
              ],
              decoration: InputDecoration(
                labelText: t.money.amount,
                suffixText: currencyLabel,
              ),
            )
          else ...[
            TextField(
              controller: _periods,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: t.money.periods),
              onChanged: (_) {
                _scheduleCustomized = false;
                setState(() {});
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _installmentAmount,
              keyboardType: TextInputType.number,
              inputFormatters: [
                GroupedAmountFormatter(persianDigits: persian),
              ],
              decoration: InputDecoration(
                labelText: t.money.installmentAmount,
                suffixText: currencyLabel,
              ),
              onChanged: (_) {
                _scheduleCustomized = false;
                setState(() {});
              },
            ),
            if (_computedTotal() != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                t.money.computedTotal(
                  amount: formatMoney(
                    _computedTotal()!,
                    currencyLabel: currencyLabel,
                    persianDigits: persian,
                  ),
                ),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: moneyAccentFor(_direction),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            if (_installmentRows.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                t.money.scheduleTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                t.money.installments.editHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final row in _installmentRows)
                Dismissible(
                  key: ValueKey('draft-inst-${row.index}'),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) async {
                    await _editInstallmentRow(
                      row,
                      t: t,
                      currency: currency,
                      calendar: calendar,
                      persian: persian,
                      currencyLabel: currencyLabel,
                    );
                    return false;
                  },
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    padding: const EdgeInsetsDirectional.only(
                      end: AppSpacing.md,
                    ),
                    color: theme.colorScheme.primaryContainer,
                    child: Text(
                      t.money.installments.editAmount,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(t.money.installmentRow(index: '${row.index}')),
                    subtitle: Text(
                      persian
                          ? toPersianDigits(
                              formatLongDate(row.dueDate, calendar),
                            )
                          : formatLongDate(row.dueDate, calendar),
                    ),
                    trailing: Text(
                      formatMoney(
                        row.amount,
                        currencyLabel: currencyLabel,
                        persianDigits: persian,
                      ),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: () => _editInstallmentRow(
                      row,
                      t: t,
                      currency: currency,
                      calendar: calendar,
                      persian: persian,
                      currencyLabel: currencyLabel,
                    ),
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
          Text(
            t.money.reminder.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            children: [
              for (final policy in MoneyItemReminderPolicy.values)
                ChoiceChip(
                  label: Text(switch (policy) {
                    MoneyItemReminderPolicy.defaultPolicy =>
                      t.money.reminder.defaultPolicy,
                    MoneyItemReminderPolicy.exactDay => t.money.reminder.exactDay,
                    MoneyItemReminderPolicy.customRange =>
                      t.money.reminder.customRange,
                  }),
                  selected: _reminderPolicy == policy,
                  onSelected: (_) {
                    AppHaptics.selection();
                    setState(() => _reminderPolicy = policy);
                  },
                ),
            ],
          ),
          if (_reminderPolicy == MoneyItemReminderPolicy.customRange) ...[
            const SizedBox(height: AppSpacing.sm),
            KitReminderDaysPicker(
              selected: _reminderDays,
              onChanged: (days) => setState(() => _reminderDays = days),
              daysBeforeLabel: t.money.reminder.daysBefore,
              customLabel: t.settings.reminderCustomDay,
              addLabel: t.settings.reminderAddDay,
              labelFor: (day) => switch (day) {
                7 => t.money.reminder.day7,
                3 => t.money.reminder.day3,
                2 => t.money.reminder.day2,
                1 => t.money.reminder.day1,
                _ => t.money.reminder.day1.replaceFirst('1', '$day'),
              },
            ),
          ],
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
            onPressed: _saving ? null : () => _save(t, currency, calendar),
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

  Party? _selectedParty(List<Party> parties) {
    final id = _partyId;
    if (id == null) return null;
    for (final party in parties) {
      if (party.id == id) return party;
    }
    return null;
  }

  int? _computedTotal() {
    if (_installmentRows.isNotEmpty) {
      final sum = installmentDraftTotal(_installmentRows);
      return sum > 0 ? sum : null;
    }
    final count = parseTomanInput(_periods.text);
    final each = parseTomanInput(_installmentAmount.text);
    if (count == null || each == null || count <= 0 || each <= 0) return null;
    return count * each;
  }

  Future<void> _editInstallmentRow(
    InstallmentDraftRow row, {
    required Translations t,
    required AppCurrency currency,
    required CalendarType calendar,
    required bool persian,
    required String currencyLabel,
  }) async {
    final amountController = TextEditingController(
      text: groupAmount(
        currency.toDisplay(row.amount),
        persianDigits: persian,
      ),
    );
    var dueDate = row.dueDate;
    final result = await showModalBottomSheet<_InstallmentEditResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.sm,
            bottom:
                MediaQuery.viewInsetsOf(sheetContext).bottom + AppSpacing.md,
          ),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    t.money.installments.editAmount,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(t.money.installmentRow(index: '${row.index}')),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: amountController,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      GroupedAmountFormatter(persianDigits: persian),
                    ],
                    decoration: InputDecoration(
                      labelText: t.money.amount,
                      suffixText: currencyLabel,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(t.money.dueDate),
                    subtitle: Text(
                      persian
                          ? toPersianDigits(formatLongDate(dueDate, calendar))
                          : formatLongDate(dueDate, calendar),
                    ),
                    trailing: const Icon(Icons.event_rounded),
                    onTap: () async {
                      final picked = await showKitDatePicker(
                        context: context,
                        initialDate: dueDate,
                        calendar: calendar,
                        persian: persian,
                        weekdayLabels: _pickerWeekdays(t, calendar),
                        confirmLabel: t.app.actions.confirm,
                        cancelLabel: t.app.actions.cancel,
                      );
                      if (picked == null) return;
                      setSheetState(() {
                        dueDate = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                        );
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton(
                    onPressed: () {
                      final amount =
                          parseStoredAmount(amountController.text, currency);
                      if (amount == null || amount <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text(t.money.installments.invalidRowAmount),
                          ),
                        );
                        return;
                      }
                      Navigator.of(sheetContext).pop(
                        _InstallmentEditResult(
                          amount: amount,
                          dueDate: dueDate,
                        ),
                      );
                    },
                    child: Text(t.app.actions.confirm),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
    amountController.dispose();
    if (result == null || !mounted) return;
    setState(() {
      _scheduleCustomized = true;
      _installmentRows = [
        for (final existing in _installmentRows)
          if (existing.index == row.index)
            existing.copyWith(amount: result.amount, dueDate: result.dueDate)
          else
            existing,
      ];
    });
  }

  Future<void> _pickDate({required bool isDue}) async {
    final t = Translations.of(context);
    final calendar = ref.read(appSettingsProvider).resolvedCalendar;
    final persian = Localizations.localeOf(context).languageCode == 'fa';
    final initial = isDue ? _due : _start;
    final picked = await showKitDatePicker(
      context: context,
      initialDate: initial,
      calendar: calendar,
      persian: persian,
      weekdayLabels: _pickerWeekdays(t, calendar),
      confirmLabel: t.app.actions.confirm,
      cancelLabel: t.app.actions.cancel,
    );
    if (picked == null) return;
    setState(() {
      if (isDue) {
        _due = DateTime(picked.year, picked.month, picked.day);
        if (!_scheduleCustomized) {
          _lastScheduleSeed = null;
        }
      } else {
        _start = DateTime(picked.year, picked.month, picked.day);
      }
    });
  }

  Future<void> _save(
    Translations t,
    AppCurrency currency,
    CalendarType calendar,
  ) async {
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
    var installmentRows = _installmentRows;
    if (_schedule == MoneySchedule.oneTime) {
      total = parseStoredAmount(_amount.text, currency);
      installmentRows = const [];
    } else {
      installmentCount = parseTomanInput(_periods.text);
      installmentAmount = parseStoredAmount(_installmentAmount.text, currency);
      if (installmentRows.isEmpty &&
          installmentCount != null &&
          installmentAmount != null &&
          installmentCount >= 2 &&
          installmentAmount > 0) {
        installmentRows = buildEqualInstallmentDraft(
          count: installmentCount,
          amount: installmentAmount,
          startDate: _due,
          calendar: calendar,
        );
      }
      if (installmentRows.isNotEmpty) {
        total = installmentDraftTotal(installmentRows);
        installmentCount = installmentRows.length;
        if (installmentAmount == null || installmentAmount <= 0) {
          installmentAmount = installmentRows.first.amount;
        }
      } else if (installmentCount != null && installmentAmount != null) {
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
            installmentAmount <= 0 ||
            installmentRows.length != installmentCount)) {
      _snack(t.money.invalidAmount);
      return;
    }
    if (_schedule == MoneySchedule.installment &&
        installmentDraftTotal(installmentRows) != total) {
      _snack(t.money.installments.totalMismatch);
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
              installments: installmentRows,
              note: _note.text.trim().isEmpty ? null : _note.text.trim(),
              reminderPolicy: moneyItemReminderPolicyToStorage(_reminderPolicy),
              reminderDaysBeforeJson: encodeDaysBeforeJson(_reminderDays),
            ),
          );
      if (!mounted) return;
      AppHaptics.confirm();
      context.pushReplacement(AppRoutes.moneyItemPath(id));
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

final class _InstallmentEditResult {
  const _InstallmentEditResult({
    required this.amount,
    required this.dueDate,
  });

  final int amount;
  final DateTime dueDate;
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
              color: AppColors.onTint(color),
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

List<String> _pickerWeekdays(Translations t, CalendarType calendar) {
  final w = t.calendar.weekday;
  return calendar == CalendarType.jalali
      ? [w.sat, w.sun, w.mon, w.tue, w.wed, w.thu, w.fri]
      : [w.mon, w.tue, w.wed, w.thu, w.fri, w.sat, w.sun];
}
