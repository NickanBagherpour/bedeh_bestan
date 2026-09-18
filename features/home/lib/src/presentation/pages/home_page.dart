import 'package:core/core.dart'
    show
        AppCurrency,
        AppRoutes,
        CalendarType,
        appSettingsProvider,
        formatLongDate,
        formatMonthYear,
        formatRangeEnds,
        formatStoredMoney,
        toPersianDigits;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart' show MoneyDirection, MoneyStatus;
import 'package:translations/translations.dart'
    show Translations, TranslationsLookup;
import 'package:ui_kit/ui_kit.dart'
    show
        AppColors,
        AppGradients,
        AppHaptics,
        AppSpacing,
        KitCard,
        KitError,
        KitFadeIn,
        KitHeroHeader,
        KitIconBadge,
        KitLoading,
        KitScrollHideFab,
        showKitConfirmDialog;

import '../../application/controllers/home_controller.dart';
import '../../application/home_dashboard.dart';
import '../../application/state/home_state.dart';
import '../widgets/home_balances_card.dart';
import '../widgets/home_collapsible_section.dart';
import '../widgets/home_due_list.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final state = ref.watch(homeControllerProvider);
    final calendar = ref.watch(appSettingsProvider).resolvedCalendar;
    final currency = ref.watch(appSettingsProvider).currency;
    final persian = Localizations.localeOf(context).languageCode == 'fa';

    return KitScrollHideFab(
      backgroundColor: Colors.transparent,
      fab: FloatingActionButton.extended(
        onPressed: () {
          AppHaptics.light();
          _pickDirection(context, t);
        },
        icon: const Icon(Icons.add_rounded),
        label: Text(t.app.actions.add),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.md,
        ),
        children: [
          KitFadeIn(
            child: KitHeroHeader(
              title: t.app.appName,
              subtitle: t.app.subtitle,
              watermark: Icons.swap_horiz_rounded,
              trailing: IconButton(
                tooltip: t.home.settings,
                onPressed: () {
                  AppHaptics.selection();
                  context.push(AppRoutes.settings.path);
                },
                icon: const Icon(Icons.settings_rounded, color: Colors.white),
              ),
              footer: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: const Icon(
                      Icons.shield_moon_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      t.home.offlineBlurb,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () {
                AppHaptics.selection();
                context.push(AppRoutes.moneyReports.path);
              },
              icon: const Icon(Icons.insights_outlined),
              label: Text(t.home.reportTitle),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (state.status == HomeStatus.error)
            KitError(
              message: t.message(
                state.errorKey ?? 'home.loadError',
                shouldTranslate: true,
              ),
              retryLabel: t.app.actions.retry,
              onRetry: () => ref.read(homeControllerProvider.notifier).retry(),
            )
          else if (state.status == HomeStatus.loading || state.dashboard == null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
              child: KitLoading(),
            )
          else
            _HomeDashboardBody(
              dashboard: state.dashboard!,
              busyPaymentItemId: state.busyPaymentItemId,
              calendar: calendar,
              currency: currency,
              persian: persian,
            ),
          const SizedBox(height: 72),
        ],
      ),
    );
  }

  Future<void> _pickDirection(BuildContext context, Translations t) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.xs,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                t.app.actions.add,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              _DirectionOption(
                icon: Icons.south_west_rounded,
                color: AppColors.pay,
                label: t.home.fabPay,
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.push(
                    AppRoutes.moneyNewPath(direction: MoneyDirection.pay.name),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              _DirectionOption(
                icon: Icons.north_east_rounded,
                color: AppColors.receive,
                label: t.home.fabReceive,
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.push(
                    AppRoutes.moneyNewPath(
                      direction: MoneyDirection.receive.name,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeDashboardBody extends ConsumerStatefulWidget {
  const _HomeDashboardBody({
    required this.dashboard,
    required this.busyPaymentItemId,
    required this.calendar,
    required this.currency,
    required this.persian,
  });

  final HomeDashboard dashboard;
  final String? busyPaymentItemId;
  final CalendarType calendar;
  final AppCurrency currency;
  final bool persian;

  @override
  ConsumerState<_HomeDashboardBody> createState() => _HomeDashboardBodyState();
}

class _HomeDashboardBodyState extends ConsumerState<_HomeDashboardBody> {
  late bool _overdueExpanded;
  late bool _weekExpanded;
  late bool _monthExpanded;
  late bool _balancesExpanded;

  @override
  void initState() {
    super.initState();
    final d = widget.dashboard;
    _overdueExpanded = homeSectionExpandedByDefault(d.overdue.length);
    _weekExpanded = homeSectionExpandedByDefault(d.dueThisWeek.length);
    _monthExpanded = homeSectionExpandedByDefault(d.dueThisMonth.length);
    _balancesExpanded = !homeBalancesCollapsedByDefault(d.balances.length);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final d = widget.dashboard;
    String money(int amount) => formatStoredMoney(
          amount,
          currency: widget.currency,
          currencyLabel: switch (widget.currency) {
            AppCurrency.toman => t.app.currency.toman,
            AppCurrency.rial => t.app.currency.rial,
            AppCurrency.usd => t.app.currency.usd,
          },
          persianDigits: widget.persian,
        );
    String due(HomeDueRow row) {
      final formatted = formatLongDate(row.dueDate, widget.calendar);
      return widget.persian ? toPersianDigits(formatted) : formatted;
    }

    String status(HomeDueRow row) {
      return switch (row.status) {
        MoneyStatus.upcoming => t.money.status.upcoming,
        MoneyStatus.dueToday => t.money.status.dueToday,
        MoneyStatus.overdue => t.money.status.overdue,
        MoneyStatus.settled => t.money.status.settled,
      };
    }

    Color accent(HomeDueRow row) {
      return row.direction == MoneyDirection.pay
          ? AppColors.pay
          : AppColors.receive;
    }

    IconData iconOf(HomeDueRow row) {
      return row.direction == MoneyDirection.pay
          ? Icons.south_west_rounded
          : Icons.north_east_rounded;
    }

    // Week/month headers sum the current قسط (suggestedAmount), not remaining.
    String amountSummary(
      List<HomeDueRow> rows, {
      required int Function(HomeDueRow row) amountOf,
    }) {
      var pay = 0;
      var receive = 0;
      for (final row in rows) {
        if (row.direction == MoneyDirection.pay) {
          pay += amountOf(row);
        } else {
          receive += amountOf(row);
        }
      }
      final parts = <String>[
        if (pay > 0) t.home.summaryPay(amount: money(pay)),
        if (receive > 0) t.home.summaryReceive(amount: money(receive)),
      ];
      if (parts.isEmpty) return t.home.sectionCount(count: rows.length);
      return parts.join(' · ');
    }

    final weekEnds = formatRangeEnds(
      d.weekRange.start,
      d.weekRange.endInclusive,
      widget.calendar,
      persian: widget.persian,
    );
    var weekSubtitle = t.home.weekRange(from: weekEnds.from, to: weekEnds.to);
    var monthSubtitle = formatMonthYear(
      d.report.periodStart,
      widget.calendar,
      persian: widget.persian,
    );
    if (widget.persian) {
      weekSubtitle = toPersianDigits(weekSubtitle);
      monthSubtitle = toPersianDigits(monthSubtitle);
    }

    Widget dueList(
      List<HomeDueRow> rows, {
      required bool enableQuickPay,
      required String emptyLabel,
      required int Function(HomeDueRow row) amountOf,
    }) {
      return HomeDueList(
        rows: rows,
        emptyLabel: emptyLabel,
        amountOf: (row) => money(amountOf(row)),
        dueOf: due,
        statusOf: status,
        accentOf: accent,
        iconOf: iconOf,
        onTap: (row) => context.push(AppRoutes.moneyItemPath(row.id)),
        busyItemId: widget.busyPaymentItemId,
        quickPayLabel: t.home.quickPay,
        quickReceiveLabel: t.home.quickReceive,
        onQuickPay: enableQuickPay ? (row) => _quickPay(context, t, row) : null,
      );
    }

    return Column(
      children: [
      if (d.overdue.isNotEmpty) ...[
        KitFadeIn(
          delay: const Duration(milliseconds: 40),
          child: HomeCollapsibleSection(
            title: t.home.overdue,
            icon: Icons.warning_amber_rounded,
            summary: amountSummary(
              d.overdue,
              amountOf: (row) => row.suggestedAmount,
            ),
            expandTooltip: t.home.sectionShowMore,
            collapseTooltip: t.home.sectionCollapse,
            expanded: _overdueExpanded,
            onToggle: () => setState(() => _overdueExpanded = !_overdueExpanded),
            child: dueList(
              d.overdue,
              enableQuickPay: true,
              emptyLabel: t.home.emptyBody,
              amountOf: (row) => row.suggestedAmount,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
      KitFadeIn(
        delay: const Duration(milliseconds: 80),
        child: HomeCollapsibleSection(
          title: t.home.dueThisWeek,
          icon: Icons.event_available_rounded,
          subtitle: weekSubtitle,
          summary: amountSummary(
            d.dueThisWeek,
            amountOf: (row) => row.suggestedAmount,
          ),
          expandTooltip: t.home.sectionShowMore,
          collapseTooltip: t.home.sectionCollapse,
          expanded: _weekExpanded,
          onToggle: () => setState(() => _weekExpanded = !_weekExpanded),
          child: dueList(
            d.dueThisWeek,
            enableQuickPay: true,
            emptyLabel: t.home.emptyBody,
            amountOf: (row) => row.suggestedAmount,
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      KitFadeIn(
        delay: const Duration(milliseconds: 100),
        child: HomeCollapsibleSection(
          title: t.home.dueThisMonth,
          icon: Icons.calendar_month_rounded,
          subtitle: monthSubtitle,
          summary: amountSummary(
            d.dueThisMonth,
            amountOf: (row) => row.suggestedAmount,
          ),
          expandTooltip: t.home.sectionShowMore,
          collapseTooltip: t.home.sectionCollapse,
          expanded: _monthExpanded,
          onToggle: () => setState(() => _monthExpanded = !_monthExpanded),
          child: dueList(
            d.dueThisMonth,
            enableQuickPay: true,
            emptyLabel: t.home.emptyThisMonth,
            amountOf: (row) => row.suggestedAmount,
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      KitFadeIn(
        delay: const Duration(milliseconds: 120),
        child: HomeCollapsibleSection(
          title: t.home.whoOwes,
          icon: Icons.groups_rounded,
          summary: t.home.sectionCount(count: d.balances.length),
          expandTooltip: t.home.sectionShowMore,
          collapseTooltip: t.home.sectionCollapse,
          expanded: _balancesExpanded,
          onToggle: () => setState(() => _balancesExpanded = !_balancesExpanded),
          child: HomeBalancesCard(
            balances: d.balances,
            emptyLabel: t.home.emptyBalances,
            payLabelOf: (row) => t.home.iOwe(amount: money(row.payRemaining)),
            receiveLabelOf: (row) =>
                t.home.theyOwe(amount: money(row.receiveRemaining)),
            onPartyTap: (row) =>
                context.push(AppRoutes.partyItemPath(row.partyId)),
          ),
        ),
      ),
      ],
    );
  }

  Future<void> _quickPay(
    BuildContext context,
    Translations t,
    HomeDueRow row,
  ) async {
    final repo = ref.read(homeControllerProvider.notifier);
    final amountLabel = money(row.suggestedAmount);
    final ok = await showKitConfirmDialog(
      context: context,
      title: row.direction == MoneyDirection.pay
          ? t.home.quickPayConfirmTitle
          : t.home.quickReceiveConfirmTitle,
      body: t.home.quickPayConfirmBody(
        title: row.title,
        amount: amountLabel,
      ),
      confirmLabel: t.app.actions.confirm,
      cancelLabel: t.app.actions.cancel,
    );
    if (!ok || !context.mounted) return;
    final errorKey = await repo.recordQuickPayment(row.id);
    if (!context.mounted) return;
    if (errorKey != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.message(errorKey, shouldTranslate: true))),
      );
      return;
    }
    AppHaptics.confirm();
  }

  String money(int amount) => formatStoredMoney(
        amount,
        currency: widget.currency,
        currencyLabel: switch (widget.currency) {
          AppCurrency.toman => Translations.of(context).app.currency.toman,
          AppCurrency.rial => Translations.of(context).app.currency.rial,
          AppCurrency.usd => Translations.of(context).app.currency.usd,
        },
        persianDigits: widget.persian,
      );
}

class _DirectionOption extends StatelessWidget {
  const _DirectionOption({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return KitCard(
      gradient: AppGradients.softTint(color, alpha: 0.16),
      accent: color,
      onTap: onTap,
      child: Row(
        children: [
          KitIconBadge(icon: icon, color: color, size: 44),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onTint(color),
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          Icon(
            Icons.chevron_left_rounded,
            color: AppColors.onTint(color),
          ),
        ],
      ),
    );
  }
}
