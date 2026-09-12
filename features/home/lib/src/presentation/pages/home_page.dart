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
        KitLoading;

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
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
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
          const SizedBox(height: AppSpacing.lg),
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
            ..._dashboard(
              context,
              t,
              state.dashboard!,
              calendar: calendar,
              currency: currency,
              persian: persian,
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

    IconData iconOf(HomeDueRow row) {
      return row.direction == MoneyDirection.pay
          ? Icons.south_west_rounded
          : Icons.north_east_rounded;
    }

    return [
      KitFadeIn(
        child: HomeReportCard(
          title: t.home.reportTitle,
          paidOutValue: money(dashboard.report.paidOut),
          paidInValue: money(dashboard.report.paidIn),
          stillOweValue: money(dashboard.report.remainingPay),
          dueByEndValue: money(dashboard.report.dueByPeriodEnd),
          paidOutCaption: t.home.capPaidOut,
          paidInCaption: t.home.capPaidIn,
          stillOweCaption: t.home.capStillOwe,
          dueByEndCaption: t.home.capDueByEnd,
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      if (dashboard.overdue.isNotEmpty) ...[
        KitFadeIn(
          delay: const Duration(milliseconds: 40),
          child: HomeDueList(
            title: t.home.overdue,
            icon: Icons.warning_amber_rounded,
            emptyLabel: t.home.emptyBody,
            rows: dashboard.overdue,
            amountOf: (row) => money(row.remainingAmount),
            dueOf: due,
            statusOf: status,
            accentOf: accent,
            iconOf: iconOf,
            onTap: (row) => context.push(AppRoutes.moneyItemPath(row.id)),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
      KitFadeIn(
        delay: const Duration(milliseconds: 80),
        child: HomeDueList(
          title: t.home.dueThisWeek,
          icon: Icons.event_available_rounded,
          emptyLabel: t.home.emptyBody,
          rows: dashboard.dueThisWeek,
          amountOf: (row) => money(row.remainingAmount),
          dueOf: due,
          statusOf: status,
          accentOf: accent,
          iconOf: iconOf,
          onTap: (row) => context.push(AppRoutes.moneyItemPath(row.id)),
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      KitFadeIn(
        delay: const Duration(milliseconds: 120),
        child: HomeBalancesCard(
          title: t.home.whoOwes,
          emptyLabel: t.home.emptyBalances,
          balances: dashboard.balances,
          payLabelOf: (row) => t.home.iOwe(amount: money(row.payRemaining)),
          receiveLabelOf: (row) =>
              t.home.theyOwe(amount: money(row.receiveRemaining)),
        ),
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

/// A colorful direction choice row inside the add sheet.
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
