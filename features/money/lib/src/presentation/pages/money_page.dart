import 'package:core/core.dart'
    show
        AppCurrency,
        AppRoutes,
        CalendarType,
        appSettingsProvider,
        formatLongDate,
        toPersianDigits;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart' show MoneyDirection, MoneyItem, MoneyStatus;
import 'package:translations/translations.dart'
    show Translations, TranslationsLookup;
import 'package:ui_kit/ui_kit.dart'
    show
        AppHaptics,
        AppSpacing,
        KitEmpty,
        KitError,
        KitLoading,
        KitScrollHideFab,
        showKitConfirmDialog;

import '../../application/controllers/money_list_controller.dart';
import '../../application/money_query.dart';
import '../../application/state/money_list_state.dart';
import '../money_style.dart';
import '../widgets/direction_choice_sheet.dart';
import '../widgets/money_item_tile.dart';

class MoneyPage extends ConsumerWidget {
  const MoneyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final state = ref.watch(moneyListControllerProvider);
    final calendar = ref.watch(appSettingsProvider).resolvedCalendar;
    final currency = ref.watch(appSettingsProvider).currency;
    final persian = Localizations.localeOf(context).languageCode == 'fa';
    final now = DateTime.now();
    final visible = state.visible(now: now);

    return KitScrollHideFab(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(t.money.title),
        actions: [
          IconButton(
            tooltip: t.money.parties,
            onPressed: () {
              AppHaptics.selection();
              context.push(AppRoutes.parties.path);
            },
            icon: const Icon(Icons.people_alt_outlined),
          ),
        ],
      ),
      fab: FloatingActionButton.extended(
        onPressed: () {
          AppHaptics.light();
          _pickDirection(context, t);
        },
        icon: const Icon(Icons.add_rounded),
        label: Text(t.money.add),
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
                  SegmentedButton<MoneyListFilter>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment(
                        value: MoneyListFilter.all,
                        label: Text(t.money.filterAll),
                      ),
                      ButtonSegment(
                        value: MoneyListFilter.pay,
                        label: Text(t.money.filterPay),
                      ),
                      ButtonSegment(
                        value: MoneyListFilter.receive,
                        label: Text(t.money.filterReceive),
                      ),
                    ],
                    selected: {state.filter},
                    onSelectionChanged: (value) {
                      AppHaptics.selection();
                      ref
                          .read(moneyListControllerProvider.notifier)
                          .setFilter(value.first);
                    },
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: () {
                        ref
                            .read(moneyListControllerProvider.notifier)
                            .setHideSettled(hide: !state.hideSettled);
                      },
                      child: Text(
                        state.hideSettled
                            ? t.money.showSettled
                            : t.money.hideSettled,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ..._bodySlivers(
            context,
            ref,
            t,
            state,
            visible,
            calendar,
            persian,
            currency,
          ),
        ],
      ),
    );
  }

  List<Widget> _bodySlivers(
    BuildContext context,
    WidgetRef ref,
    Translations t,
    MoneyListState state,
    List<MoneyItem> visible,
    CalendarType calendar,
    bool persian,
    AppCurrency currency,
  ) {
    if (state.status == MoneyListStatus.error) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: KitError(
            message: t.message(
              state.errorKey ?? 'money.loadError',
              shouldTranslate: true,
            ),
            retryLabel: t.app.actions.retry,
            onRetry: () =>
                ref.read(moneyListControllerProvider.notifier).retry(),
          ),
        ),
      ];
    }
    if (state.status == MoneyListStatus.loading) {
      return [
        const SliverFillRemaining(
          hasScrollBody: false,
          child: KitLoading(),
        ),
      ];
    }
    if (state.items.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: KitEmpty(
            icon: Icons.account_balance_wallet_rounded,
            title: t.money.emptyTitle,
            body: t.money.emptyBody,
            action: FilledButton.tonal(
              onPressed: () {
                AppHaptics.light();
                _pickDirection(context, t);
              },
              child: Text(t.money.add),
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
            title: t.money.emptyFilter,
            body: t.money.emptyBody,
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
            final item = visible[index];
            final party = state.partyFor(item.partyId);
            final status = item.statusOn(DateTime.now());
            return Dismissible(
              key: ValueKey(item.id),
              direction: DismissDirection.endToStart,
              confirmDismiss: (_) => _confirmDelete(context, t),
              onDismissed: (_) {
                ref
                    .read(moneyListControllerProvider.notifier)
                    .deleteItem(item.id);
              },
              background: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      end: AppSpacing.md,
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ),
              child: MoneyItemTile(
                title: item.title,
                partyName: party?.name ?? item.partyId,
                amountLabel: formatItemMoney(
                  item.remainingAmount,
                  t: t,
                  currency: currency,
                  persianDigits: persian,
                ),
                dueLabel: _dueLabel(t, item.nextDueDate, calendar, persian),
                statusLabel: _statusLabel(t, status),
                accent: moneyAccentFor(item.direction),
                icon: moneyIconFor(item.direction),
                statusColor:
                    moneyStatusColor(status, Theme.of(context).colorScheme),
                onTap: () => context.push(AppRoutes.moneyItemPath(item.id)),
                partyLinkTooltip: t.money.partyLink,
                onPartyTap: item.partyId.isEmpty
                    ? null
                    : () => context.push(AppRoutes.partyItemPath(item.partyId)),
              ),
            );
          },
        ),
      ),
    ];
  }

  Future<bool> _confirmDelete(BuildContext context, Translations t) {
    return showKitConfirmDialog(
      context: context,
      title: t.money.delete,
      body: t.money.deleteConfirm,
      confirmLabel: t.app.actions.delete,
      cancelLabel: t.app.actions.cancel,
    );
  }

  Future<void> _pickDirection(BuildContext context, Translations t) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return DirectionChoiceSheet(
          title: t.money.add,
          payLabel: t.money.fabPay,
          receiveLabel: t.money.fabReceive,
          onPay: () {
            Navigator.of(sheetContext).pop();
            context.push(AppRoutes.moneyNewPath(direction: MoneyDirection.pay.name));
          },
          onReceive: () {
            Navigator.of(sheetContext).pop();
            context.push(
              AppRoutes.moneyNewPath(direction: MoneyDirection.receive.name),
            );
          },
        );
      },
    );
  }
}

String _statusLabel(Translations t, MoneyStatus status) {
  return switch (status) {
    MoneyStatus.upcoming => t.money.status.upcoming,
    MoneyStatus.dueToday => t.money.status.dueToday,
    MoneyStatus.overdue => t.money.status.overdue,
    MoneyStatus.settled => t.money.status.settled,
  };
}

String _dueLabel(
  Translations t,
  DateTime due,
  CalendarType calendar,
  bool persian,
) {
  final date = formatLongDate(due, calendar);
  final digits = persian ? toPersianDigits(date) : date;
  return '${t.money.due} $digits';
}
