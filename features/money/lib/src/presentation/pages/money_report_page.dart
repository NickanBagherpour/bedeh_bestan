import 'package:core/core.dart'
    show
        AppCurrency,
        AppRoutes,
        CalendarType,
        appSettingsProvider,
        formatLongDate,
        overlayAppBar,
        toPersianDigits;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart' show MoneyStatus, Party;
import 'package:translations/translations.dart'
    show Translations, TranslationsLookup;
import 'package:ui_kit/ui_kit.dart'
    show
        AppColors,
        AppHaptics,
        AppSpacing,
        KitCard,
        KitError,
        KitLoading,
        showKitDatePicker;

import '../../application/controllers/money_report_controller.dart';
import '../../application/money_period_report.dart';
import '../../application/state/money_report_state.dart';
import '../money_style.dart';

class MoneyReportPage extends ConsumerWidget {
  const MoneyReportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(moneyReportControllerProvider);
    final calendar = ref.watch(appSettingsProvider).resolvedCalendar;
    final currency = ref.watch(appSettingsProvider).currency;
    final persian = Localizations.localeOf(context).languageCode == 'fa';
    final now = DateTime.now();
    final report = state.report(now: now);

    return Scaffold(
      appBar: overlayAppBar(
        context: context,
        title: Text(t.money.reports.title),
        fallbackPath: AppRoutes.money.path,
        backTooltip: t.app.actions.back,
        actions: [
          IconButton(
            tooltip: t.money.reports.resetMonth,
            onPressed: () {
              AppHaptics.selection();
              ref
                  .read(moneyReportControllerProvider.notifier)
                  .resetToCurrentMonth();
            },
            icon: const Icon(Icons.today_outlined),
          ),
        ],
      ),
      body: _body(
        context: context,
        ref: ref,
        t: t,
        theme: theme,
        state: state,
        report: report,
        calendar: calendar,
        currency: currency,
        persian: persian,
      ),
    );
  }

  Widget _body({
    required BuildContext context,
    required WidgetRef ref,
    required Translations t,
    required ThemeData theme,
    required MoneyReportState state,
    required MoneyPeriodReport? report,
    required CalendarType calendar,
    required AppCurrency currency,
    required bool persian,
  }) {
    if (state.status == MoneyReportStatus.error) {
      return KitError(
        message: t.message(
          state.errorKey ?? 'money.loadError',
          shouldTranslate: true,
        ),
        retryLabel: t.app.actions.retry,
        onRetry: () => ref.read(moneyReportControllerProvider.notifier).retry(),
      );
    }
    if (report == null || state.status == MoneyReportStatus.loading) {
      return const KitLoading();
    }

    String money(int amount) => formatItemMoney(
          amount,
          t: t,
          currency: currency,
          persianDigits: persian,
        );
    String date(DateTime value) {
      final formatted = formatLongDate(value, calendar);
      return persian ? toPersianDigits(formatted) : formatted;
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _filters(
          context: context,
          ref: ref,
          t: t,
          theme: theme,
          state: state,
          calendar: calendar,
          persian: persian,
          date: date,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          t.money.reports.summary,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _summaryCard(
          theme: theme,
          title: t.money.reports.dueInPeriod,
          payLabel: t.money.reports.duePay(amount: money(report.duePayInPeriod)),
          receiveLabel: t.money.reports.dueReceive(
            amount: money(report.dueReceiveInPeriod),
          ),
        ),
        _summaryCard(
          theme: theme,
          title: t.money.reports.settledInPeriod,
          payLabel: t.money.reports.settledPay(
            amount: money(report.settledPayInPeriod),
          ),
          receiveLabel: t.money.reports.settledReceive(
            amount: money(report.settledReceiveInPeriod),
          ),
        ),
        _summaryCard(
          theme: theme,
          title: t.money.reports.openBalances,
          subtitle: t.money.reports.openBalancesHint,
          payLabel: t.money.reports.openPay(
            amount: money(report.openPayRemaining),
          ),
          receiveLabel: t.money.reports.openReceive(
            amount: money(report.openReceiveRemaining),
          ),
        ),
        if (report.assetsTotal > 0 || report.approxNetWorth != 0)
          KitCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.money.reports.assets,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(t.money.reports.assetsTotal(amount: money(report.assetsTotal))),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  t.money.reports.approxNetWorth(
                    amount: money(report.approxNetWorth.abs()),
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: report.approxNetWorth >= 0
                        ? AppColors.receive
                        : AppColors.pay,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        if (report.partyBalances.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            t.money.reports.topParties,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final row in report.partyBalances.take(5))
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(row.partyName),
              subtitle: Text(
                [
                  if (row.payRemaining > 0)
                    t.money.reports.openPay(amount: money(row.payRemaining)),
                  if (row.receiveRemaining > 0)
                    t.money.reports.openReceive(
                      amount: money(row.receiveRemaining),
                    ),
                ].join(' · '),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(AppRoutes.partyItemPath(row.partyId)),
            ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Text(
          t.money.reports.byItem,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (report.itemsInPeriod.isEmpty)
          Text(
            t.money.reports.emptyItems,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          for (final row in report.itemsInPeriod)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                moneyIconFor(row.direction),
                color: moneyAccentFor(row.direction),
              ),
              title: Text(row.title),
              subtitle: Text(
                '${row.partyName} · ${date(row.dueDate)} · ${_statusLabel(t, row.status)}',
              ),
              trailing: Text(
                money(row.suggestedAmount),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: moneyAccentFor(row.direction),
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: () => context.push(AppRoutes.moneyItemPath(row.id)),
            ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          t.money.reports.byParty,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (report.partyBalances.isEmpty)
          Text(
            t.money.reports.emptyParties,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          for (final row in report.partyBalances)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(row.partyName),
              subtitle: Text(
                [
                  if (row.payRemaining > 0)
                    t.money.reports.openPay(amount: money(row.payRemaining)),
                  if (row.receiveRemaining > 0)
                    t.money.reports.openReceive(
                      amount: money(row.receiveRemaining),
                    ),
                ].join(' · '),
              ),
              onTap: () => context.push(AppRoutes.partyItemPath(row.partyId)),
            ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          t.money.reports.paymentsLog,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (report.paymentsInPeriod.isEmpty)
          Text(
            t.money.reports.emptyPayments,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          for (final row in report.paymentsInPeriod)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(row.itemTitle),
              subtitle: Text('${row.partyName} · ${date(row.paidAt)}'),
              trailing: Text(
                money(row.amount),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: moneyAccentFor(row.direction),
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: () =>
                  context.push(AppRoutes.moneyItemPath(row.moneyItemId)),
            ),
      ],
    );
  }

  Widget _filters({
    required BuildContext context,
    required WidgetRef ref,
    required Translations t,
    required ThemeData theme,
    required MoneyReportState state,
    required CalendarType calendar,
    required bool persian,
    required String Function(DateTime) date,
  }) {
    final controller = ref.read(moneyReportControllerProvider.notifier);
    final parties = state.parties.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    final selectedParty =
        state.partyId == null ? null : state.parties[state.partyId!];

    return KitCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.money.reports.filters,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _dateChip(
                  label: t.money.reports.fromDate,
                  value: date(state.rangeStart!),
                  onTap: () => _pickBound(
                    context: context,
                    ref: ref,
                    t: t,
                    calendar: calendar,
                    persian: persian,
                    isStart: true,
                    current: state.rangeStart!,
                    other: state.rangeEnd!,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _dateChip(
                  label: t.money.reports.toDate,
                  value: date(state.rangeEnd!),
                  onTap: () => _pickBound(
                    context: context,
                    ref: ref,
                    t: t,
                    calendar: calendar,
                    persian: persian,
                    isStart: false,
                    current: state.rangeEnd!,
                    other: state.rangeStart!,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(t.money.reports.partyFilter),
            subtitle: Text(
              selectedParty?.name ?? t.money.reports.allParties,
            ),
            trailing: const Icon(Icons.arrow_drop_down_rounded),
            onTap: () => _pickParty(context, t, parties, controller),
          ),
          const SizedBox(height: AppSpacing.xs),
          SegmentedButton<MoneyReportDirectionFilter>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: MoneyReportDirectionFilter.all,
                label: Text(t.money.filterAll),
              ),
              ButtonSegment(
                value: MoneyReportDirectionFilter.pay,
                label: Text(t.money.filterPay),
              ),
              ButtonSegment(
                value: MoneyReportDirectionFilter.receive,
                label: Text(t.money.filterReceive),
              ),
            ],
            selected: {state.direction},
            onSelectionChanged: (value) {
              AppHaptics.selection();
              controller.setDirection(value.first);
            },
          ),
        ],
      ),
    );
  }

  Widget _dateChip({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Text(value, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required ThemeData theme,
    required String title,
    required String payLabel,
    required String receiveLabel,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: KitCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xs),
            Text(payLabel, style: const TextStyle(color: AppColors.pay)),
            const SizedBox(height: AppSpacing.xxs),
            Text(receiveLabel, style: const TextStyle(color: AppColors.receive)),
          ],
        ),
      ),
    );
  }

  Future<void> _pickBound({
    required BuildContext context,
    required WidgetRef ref,
    required Translations t,
    required CalendarType calendar,
    required bool persian,
    required bool isStart,
    required DateTime current,
    required DateTime other,
  }) async {
    final w = t.calendar.weekday;
    final weekdayLabels = calendar == CalendarType.jalali
        ? [w.sat, w.sun, w.mon, w.tue, w.wed, w.thu, w.fri]
        : [w.mon, w.tue, w.wed, w.thu, w.fri, w.sat, w.sun];
    final picked = await showKitDatePicker(
      context: context,
      initialDate: current,
      calendar: calendar,
      persian: persian,
      weekdayLabels: weekdayLabels,
      confirmLabel: t.app.actions.confirm,
      cancelLabel: t.app.actions.cancel,
    );
    if (picked == null) return;
    final day = DateTime(picked.year, picked.month, picked.day);
    final controller = ref.read(moneyReportControllerProvider.notifier);
    if (isStart) {
      controller.setRange(start: day, end: other);
    } else {
      controller.setRange(start: other, end: day);
    }
  }

  Future<void> _pickParty(
    BuildContext context,
    Translations t,
    List<Party> parties,
    MoneyReportController controller,
  ) async {
    final selected = await showModalBottomSheet<_PartyFilterChoice>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(t.money.reports.allParties),
                onTap: () => Navigator.of(context).pop(
                  const _PartyFilterChoice.all(),
                ),
              ),
              for (final party in parties)
                ListTile(
                  title: Text(party.name),
                  onTap: () => Navigator.of(context).pop(
                    _PartyFilterChoice.party(party.id),
                  ),
                ),
            ],
          ),
        );
      },
    );
    if (selected == null) return;
    AppHaptics.selection();
    controller.setPartyId(selected.partyId);
  }

  String _statusLabel(Translations t, MoneyStatus status) {
    return switch (status) {
      MoneyStatus.upcoming => t.money.status.upcoming,
      MoneyStatus.dueToday => t.money.status.dueToday,
      MoneyStatus.overdue => t.money.status.overdue,
      MoneyStatus.settled => t.money.status.settled,
    };
  }
}

final class _PartyFilterChoice {
  const _PartyFilterChoice.all() : partyId = null;
  const _PartyFilterChoice.party(this.partyId);

  final String? partyId;
}
