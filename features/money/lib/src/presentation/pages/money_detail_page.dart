import 'package:core/core.dart'
    show
        AppCurrency,
        AppRoutes,
        CalendarType,
        GroupedAmountFormatter,
        appSettingsProvider,
        formatLongDate,
        parseStoredAmount,
        toPersianDigits;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart' show MoneyDirection, MoneySchedule, MoneyStatus;
import 'package:translations/translations.dart'
    show Translations, TranslationsLookup;
import 'package:ui_kit/ui_kit.dart' show AppSpacing, KitCard, KitEmpty;

import '../../application/controllers/money_detail_controller.dart';
import '../../application/state/money_detail_state.dart';
import '../money_style.dart';
import '../widgets/money_status_chip.dart';

class MoneyDetailPage extends ConsumerStatefulWidget {
  const MoneyDetailPage({super.key, required this.itemId});

  final String itemId;

  @override
  ConsumerState<MoneyDetailPage> createState() => _MoneyDetailPageState();
}

class _MoneyDetailPageState extends ConsumerState<MoneyDetailPage> {
  final _amount = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(moneyDetailControllerProvider(widget.itemId));
    final calendar = ref.watch(appSettingsProvider).resolvedCalendar;
    final currency = ref.watch(appSettingsProvider).currency;
    final persian = Localizations.localeOf(context).languageCode == 'fa';

    return Scaffold(
      appBar: AppBar(
        title: Text(state.item?.title ?? t.money.title),
        actions: [
          if (state.item != null)
            IconButton(
              tooltip: t.money.edit,
              onPressed: () =>
                  context.push(AppRoutes.moneyEditPath(widget.itemId)),
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
      ),
      body: _body(context, t, theme, state, calendar, persian, currency),
    );
  }

  Widget _body(
    BuildContext context,
    Translations t,
    ThemeData theme,
    MoneyDetailState state,
    CalendarType calendar,
    bool persian,
    AppCurrency currency,
  ) {
    if (state.status == MoneyDetailStatus.error && state.item == null) {
      return KitEmpty(
        icon: Icons.error_outline_rounded,
        title: t.message(
          state.errorKey ?? 'money.missingItem',
          shouldTranslate: true,
        ),
      );
    }
    final item = state.item;
    if (item == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final status = item.statusOn(DateTime.now());
    final accent = moneyAccentFor(item.direction);
    final remaining = formatItemMoney(
      item.remainingAmount,
      t: t,
      currency: currency,
      persianDigits: persian,
    );
    final total = formatItemMoney(
      item.totalAmount,
      t: t,
      currency: currency,
      persianDigits: persian,
    );
    final paid = formatItemMoney(
      item.paidAmount,
      t: t,
      currency: currency,
      persianDigits: persian,
    );
    final due = formatLongDate(item.nextDueDate, calendar);
    final payments = state.payments;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        KitCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      state.party?.name ?? item.partyId,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  MoneyStatusChip(
                    label: _statusLabel(t, status),
                    color: moneyStatusColor(status, theme.colorScheme),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                item.direction == MoneyDirection.pay
                    ? t.money.direction.pay
                    : t.money.direction.receive,
                style: theme.textTheme.bodyMedium?.copyWith(color: accent),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                remaining,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                t.money.remaining,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _kv(theme, t.money.total, total),
              _kv(theme, t.money.paid, paid),
              _kv(
                theme,
                t.money.due,
                persian ? toPersianDigits(due) : due,
              ),
              if (item.schedule == MoneySchedule.installment) ...[
                const SizedBox(height: AppSpacing.sm),
                _kv(
                  theme,
                  t.money.installment,
                  t.money.periodsProgress(
                    paid: _count(item.periodsPaid, persian),
                    total: _count(item.installmentCount ?? 0, persian),
                  ),
                ),
              ],
              if (item.note != null && item.note!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(item.note!, style: theme.textTheme.bodyMedium),
              ],
            ],
          ),
        ),
        if (!item.isSettled) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            t.money.recordPayment,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _amount,
            keyboardType: TextInputType.number,
            inputFormatters: [
              GroupedAmountFormatter(persianDigits: persian),
            ],
            decoration: InputDecoration(
              labelText: t.money.paymentAmount,
              suffixText: currencyLabelOf(t, currency),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton(
            onPressed: state.busy ? null : () => _pay(context, t, currency),
            child: Text(
              item.direction == MoneyDirection.pay
                  ? t.money.payCta
                  : t.money.receiveCta,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Text(
          t.money.payments,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (payments.isEmpty)
          Text(
            t.money.noPayments,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          for (final payment in payments)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: KitCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatItemMoney(
                          payment.amount,
                          t: t,
                          currency: currency,
                          persianDigits: persian,
                        ),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      persian
                          ? toPersianDigits(
                              formatLongDate(payment.paidAt, calendar),
                            )
                          : formatLongDate(payment.paidAt, calendar),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  Future<void> _pay(
    BuildContext context,
    Translations t,
    AppCurrency currency,
  ) async {
    final amount = parseStoredAmount(_amount.text, currency);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.money.invalidAmount)),
      );
      return;
    }
    final error = await ref
        .read(moneyDetailControllerProvider(widget.itemId).notifier)
        .recordPayment(amount);
    if (!context.mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.message(error, shouldTranslate: true))),
      );
      return;
    }
    _amount.clear();
  }
}

Widget _kv(ThemeData theme, String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
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

String _statusLabel(Translations t, MoneyStatus status) {
  return switch (status) {
    MoneyStatus.upcoming => t.money.status.upcoming,
    MoneyStatus.dueToday => t.money.status.dueToday,
    MoneyStatus.overdue => t.money.status.overdue,
    MoneyStatus.settled => t.money.status.settled,
  };
}

String _count(int value, bool persian) {
  final raw = value.toString();
  return persian ? toPersianDigits(raw) : raw;
}
