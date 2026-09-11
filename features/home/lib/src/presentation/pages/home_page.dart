import 'package:core/core.dart'
    show
        AppCurrency,
        AppRoutes,
        CalendarType,
        appSettingsProvider,
        formatLongDate,
        formatStoredMoney,
        toPersianDigits;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart' show MoneyDirection, MoneyStatus;
import 'package:translations/translations.dart'
    show Translations, TranslationsLookup;
import 'package:ui_kit/ui_kit.dart' show AppColors, AppSpacing, KitCard, KitEmpty;

import '../../application/controllers/home_controller.dart';
import '../../application/home_dashboard.dart';
import '../../application/state/home_state.dart';
import '../widgets/home_balances_card.dart';
import '../widgets/home_due_list.dart';
import '../widgets/home_report_card.dart';

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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _pickDirection(context, t),
        icon: const Icon(Icons.add_rounded),
        label: Text(t.app.actions.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.app.appName,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      t.app.subtitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: t.home.settings,
                onPressed: () => context.push(AppRoutes.settings.path),
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          KitCard(
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.receive.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: const Icon(
                    Icons.swap_vert_rounded,
                    color: AppColors.receive,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.home.payAndReceive,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        t.home.offlineBlurb,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (state.status == HomeStatus.error)
            KitEmpty(
              icon: Icons.error_outline_rounded,
              title: t.message(
                state.errorKey ?? 'home.loadError',
                shouldTranslate: true,
              ),
              body: t.home.emptyBody,
            )
          else if (state.dashboard != null)
            ..._dashboard(
              context,
              t,
              state.dashboard!,
              calendar: calendar,
              currency: currency,
              persian: persian,
            )
          else
            KitEmpty(
              icon: Icons.auto_awesome_rounded,
              title: t.home.emptyTitle,
              body: t.home.emptyBody,
            ),
          const SizedBox(height: 72),
        ],
      ),
    );
  }

  List<Widget> _dashboard(
    BuildContext context,
    Translations t,
    HomeDashboard dashboard, {
    required CalendarType calendar,
    required AppCurrency currency,
    required bool persian,
  }) {
    String money(int amount) => formatStoredMoney(
          amount,
          currency: currency,
          currencyLabel: switch (currency) {
            AppCurrency.toman => t.app.currency.toman,
            AppCurrency.rial => t.app.currency.rial,
            AppCurrency.usd => t.app.currency.usd,
          },
          persianDigits: persian,
        );
    String due(HomeDueRow row) {
      final formatted = formatLongDate(row.dueDate, calendar);
      return persian ? toPersianDigits(formatted) : formatted;
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

    return [
      HomeReportCard(
        title: t.home.reportTitle,
        paidOutLabel: t.home.paidOut(amount: money(dashboard.report.paidOut)),
        paidInLabel: t.home.paidIn(amount: money(dashboard.report.paidIn)),
        stillOweLabel:
            t.home.stillOwe(amount: money(dashboard.report.remainingPay)),
        dueByEndLabel:
            t.home.dueByEnd(amount: money(dashboard.report.dueByPeriodEnd)),
      ),
      const SizedBox(height: AppSpacing.md),
      if (dashboard.overdue.isNotEmpty) ...[
        HomeDueList(
          title: t.home.overdue,
          emptyLabel: t.home.emptyBody,
          rows: dashboard.overdue,
          amountOf: (row) => money(row.remainingAmount),
          dueOf: due,
          statusOf: status,
          accentOf: accent,
          onTap: (row) => context.push(AppRoutes.moneyItemPath(row.id)),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
      HomeDueList(
        title: t.home.dueThisWeek,
        emptyLabel: t.home.emptyBody,
        rows: dashboard.dueThisWeek,
        amountOf: (row) => money(row.remainingAmount),
        dueOf: due,
        statusOf: status,
        accentOf: accent,
        onTap: (row) => context.push(AppRoutes.moneyItemPath(row.id)),
      ),
      const SizedBox(height: AppSpacing.md),
      HomeBalancesCard(
        title: t.home.whoOwes,
        emptyLabel: t.home.emptyBalances,
        balances: dashboard.balances,
        payLabelOf: (row) => t.home.iOwe(amount: money(row.payRemaining)),
        receiveLabelOf: (row) =>
            t.home.theyOwe(amount: money(row.receiveRemaining)),
      ),
    ];
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
              KitCard(
                color: AppColors.pay.withValues(alpha: 0.10),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.push(
                    AppRoutes.moneyNewPath(direction: MoneyDirection.pay.name),
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.south_west_rounded, color: AppColors.pay),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      t.home.fabPay,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.pay,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              KitCard(
                color: AppColors.receive.withValues(alpha: 0.10),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.push(
                    AppRoutes.moneyNewPath(
                      direction: MoneyDirection.receive.name,
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.north_east_rounded,
                      color: AppColors.receive,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      t.home.fabReceive,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.receive,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
