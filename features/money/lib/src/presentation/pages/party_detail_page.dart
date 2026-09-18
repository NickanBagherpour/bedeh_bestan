import 'package:core/core.dart'
    show
        AppCurrency,
        AppRoutes,
        CalendarType,
        appSettingsProvider,
        formatLongDate,
        overlayAppBar,
        popOrGo,
        toPersianDigits;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart' show MoneyDirection, MoneyItem;
import 'package:share_plus/share_plus.dart' show ShareParams, SharePlus;
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
        showKitConfirmDialog;
import 'package:url_launcher/url_launcher.dart' show LaunchMode, launchUrl;

import '../../application/controllers/party_detail_controller.dart';
import '../../application/money_query.dart';
import '../../application/party_statement.dart';
import '../../application/state/party_detail_state.dart';
import '../money_style.dart';

class PartyDetailPage extends ConsumerWidget {
  const PartyDetailPage({super.key, required this.partyId});

  final String partyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(partyDetailControllerProvider(partyId));
    final calendar = ref.watch(appSettingsProvider).resolvedCalendar;
    final currency = ref.watch(appSettingsProvider).currency;
    final persian = Localizations.localeOf(context).languageCode == 'fa';
    final party = state.party;

    return Scaffold(
      appBar: overlayAppBar(
        context: context,
        title: Text(party?.name ?? t.money.parties),
        fallbackPath: AppRoutes.parties.path,
        backTooltip: t.app.actions.back,
        actions: [
          if (party != null) ...[
            IconButton(
              tooltip: t.money.shareStatement,
              onPressed: () =>
                  _share(context, t, state, calendar, persian, currency),
              icon: const Icon(Icons.ios_share_outlined),
            ),
            IconButton(
              tooltip: t.money.edit,
              onPressed: () => context.push(AppRoutes.partyEditPath(partyId)),
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ],
      ),
      body: _body(context, ref, t, theme, state, calendar, persian, currency),
    );
  }

  Widget _body(
    BuildContext context,
    WidgetRef ref,
    Translations t,
    ThemeData theme,
    PartyDetailState state,
    CalendarType calendar,
    bool persian,
    AppCurrency currency,
  ) {
    final party = state.party;
    if (state.status == PartyDetailStatus.error && party == null) {
      return KitError(
        message: t.message(
          state.errorKey ?? 'money.loadError',
          shouldTranslate: true,
        ),
        retryLabel: t.app.actions.retry,
        onRetry: () =>
            ref.read(partyDetailControllerProvider(partyId).notifier).retry(),
      );
    }
    if (party == null) {
      if (state.status == PartyDetailStatus.loaded) {
        return KitError(message: t.money.missingPartyItem);
      }
      return const KitLoading();
    }

    String fmtMoney(int storedToman) => formatItemMoney(
          storedToman,
          t: t,
          currency: currency,
          persianDigits: persian,
        );
    String fmtDate(DateTime date) {
      final formatted = formatLongDate(date, calendar);
      return persian ? toPersianDigits(formatted) : formatted;
    }

    final linked = state.items;
    final net = partyNetBalance(linked);
    final ledger = partyLedger(items: linked, payments: state.payments);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        KitCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                party.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                partyKindLabel(t, party.kind),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              _contactRow(
                theme: theme,
                label: t.money.phone,
                value: party.phone,
                actions: [
                  _ContactAction(
                    icon: Icons.call_outlined,
                    tooltip: t.money.callAction,
                    onPressed: () => _call(context, t, party.phone!),
                  ),
                  _ContactAction(
                    icon: Icons.copy_outlined,
                    tooltip: t.money.copyAction,
                    onPressed: () => _copy(context, t, party.phone!),
                  ),
                ],
              ),
              _contactRow(
                theme: theme,
                label: t.money.cardNumber,
                value: party.cardNumber,
                actions: [
                  _ContactAction(
                    icon: Icons.copy_outlined,
                    tooltip: t.money.copyAction,
                    onPressed: () => _copy(context, t, party.cardNumber!),
                  ),
                ],
              ),
              _contactRow(
                theme: theme,
                label: t.money.sheba,
                value: party.sheba,
                actions: [
                  _ContactAction(
                    icon: Icons.copy_outlined,
                    tooltip: t.money.copyAction,
                    onPressed: () => _copy(context, t, party.sheba!),
                  ),
                ],
              ),
              _contactRow(
                theme: theme,
                label: t.money.nationalCode,
                value: party.nationalCode,
                actions: [
                  _ContactAction(
                    icon: Icons.copy_outlined,
                    tooltip: t.money.copyAction,
                    onPressed: () => _copy(context, t, party.nationalCode!),
                  ),
                ],
              ),
              _contactRow(
                theme: theme,
                label: t.money.birthDate,
                value: party.birthDate,
                ltr: false,
                actions: [
                  _ContactAction(
                    icon: Icons.copy_outlined,
                    tooltip: t.money.copyAction,
                    onPressed: () => _copy(context, t, party.birthDate!),
                  ),
                ],
              ),
              _contactRow(
                theme: theme,
                label: t.money.note,
                value: party.note,
                ltr: false,
                actions: [
                  _ContactAction(
                    icon: Icons.copy_outlined,
                    tooltip: t.money.copyAction,
                    onPressed: () => _copy(context, t, party.note!),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _netBalanceCard(theme, t, net, fmtMoney),
        const SizedBox(height: AppSpacing.lg),
        Text(
          t.money.linkedAccounts,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (linked.isEmpty)
          Text(
            t.money.noLinkedAccounts,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          for (final item in linked)
            _accountRow(context, theme, t, item, fmtMoney),
        const SizedBox(height: AppSpacing.lg),
        Text(
          t.money.statement,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (ledger.isEmpty)
          Text(
            t.money.emptyLedger,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          for (final entry in ledger)
            _ledgerRow(theme, t, entry, fmtMoney, fmtDate),
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton(
          onPressed: () => _delete(context, ref, t),
          child: Text(t.money.deleteParty),
        ),
      ],
    );
  }

  Widget _netBalanceCard(
    ThemeData theme,
    Translations t,
    int net,
    String Function(int) fmtMoney,
  ) {
    final color = _balanceColor(net, theme.colorScheme);
    return KitCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.money.netBalance,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  _balanceLabel(t, net),
                  style: theme.textTheme.bodySmall?.copyWith(color: color),
                ),
              ],
            ),
          ),
          Text(
            fmtMoney(net.abs()),
            style: theme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountRow(
    BuildContext context,
    ThemeData theme,
    Translations t,
    MoneyItem item,
    String Function(int) fmtMoney,
  ) {
    final accent = moneyAccentFor(item.direction);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(item.title),
      subtitle: Text(
        item.direction == MoneyDirection.pay
            ? t.money.direction.pay
            : t.money.direction.receive,
        style: theme.textTheme.bodySmall?.copyWith(color: accent),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            fmtMoney(item.remainingAmount),
            style: theme.textTheme.titleSmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
      onTap: () => context.push(AppRoutes.moneyItemPath(item.id)),
    );
  }

  Widget _ledgerRow(
    ThemeData theme,
    Translations t,
    PartyLedgerEntry entry,
    String Function(int) fmtMoney,
    String Function(DateTime) fmtDate,
  ) {
    final accent = moneyAccentFor(entry.direction);
    final balanceColor = _balanceColor(entry.balanceAfter, theme.colorScheme);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: KitCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fmtMoney(entry.payment.amount),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    fmtDate(entry.payment.paidAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  t.money.balance,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  fmtMoney(entry.balanceAfter.abs()),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: balanceColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactRow({
    required ThemeData theme,
    required String label,
    required String? value,
    List<_ContactAction> actions = const [],
    bool ltr = true,
  }) {
    if (value == null || value.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  value,
                  textDirection: ltr ? TextDirection.ltr : null,
                  textAlign: TextAlign.start,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          for (final action in actions)
            IconButton(
              tooltip: action.tooltip,
              onPressed: action.onPressed,
              icon: Icon(action.icon),
            ),
        ],
      ),
    );
  }

  Future<void> _share(
    BuildContext context,
    Translations t,
    PartyDetailState state,
    CalendarType calendar,
    bool persian,
    AppCurrency currency,
  ) async {
    final party = state.party;
    if (party == null) return;

    String fmtMoney(int storedToman) => formatItemMoney(
          storedToman,
          t: t,
          currency: currency,
          persianDigits: persian,
        );
    String fmtDate(DateTime date) {
      final formatted = formatLongDate(date, calendar);
      return persian ? toPersianDigits(formatted) : formatted;
    }

    final items = state.items;
    final statement = buildPartyStatement(
      partyName: party.name,
      kindLabel: partyKindLabel(t, party.kind),
      items: items,
      ledger: partyLedger(items: items, payments: state.payments),
      labels: PartyStatementLabels(
        netBalance: t.money.netBalance,
        accounts: t.money.linkedAccounts,
        transactions: t.money.statement,
        balance: t.money.balance,
        noAccounts: t.money.noLinkedAccounts,
        noTransactions: t.money.emptyLedger,
        directionPay: t.money.direction.pay,
        directionReceive: t.money.direction.receive,
        owedToMe: t.money.direction.receive,
        iOwe: t.money.direction.pay,
        settled: t.money.status.settled,
      ),
      fmtMoney: fmtMoney,
      fmtDate: fmtDate,
    );

    AppHaptics.selection();
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: statement,
          subject: t.money.shareSubject(name: party.name),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.money.shareFailed)),
      );
    }
  }

  Future<void> _call(
    BuildContext context,
    Translations t,
    String phone,
  ) async {
    final uri = Uri(scheme: 'tel', path: phone.trim());
    AppHaptics.selection();
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (launched || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.money.callFailed)),
    );
  }

  Future<void> _copy(
    BuildContext context,
    Translations t,
    String value,
  ) async {
    await Clipboard.setData(ClipboardData(text: value.trim()));
    if (!context.mounted) return;
    AppHaptics.confirm();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.money.copied)),
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Translations t,
  ) async {
    final ok = await showKitConfirmDialog(
      context: context,
      title: t.money.deleteParty,
      body: t.money.deletePartyConfirm,
      confirmLabel: t.app.actions.delete,
      cancelLabel: t.app.actions.cancel,
    );
    if (!ok || !context.mounted) return;
    final errorKey = await ref
        .read(partyDetailControllerProvider(partyId).notifier)
        .deleteParty();
    if (!context.mounted) return;
    if (errorKey != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.message(errorKey, shouldTranslate: true)),
        ),
      );
      return;
    }
    AppHaptics.confirm();
    popOrGo(context, AppRoutes.parties.path);
  }
}

/// Color for a signed net balance: طلب (positive) → receive, بدهی (negative) →
/// pay, settled (zero) → muted.
Color _balanceColor(int net, ColorScheme scheme) {
  if (net > 0) return AppColors.receive;
  if (net < 0) return AppColors.pay;
  return scheme.onSurfaceVariant;
}

String _balanceLabel(Translations t, int net) {
  if (net > 0) return t.money.direction.receive;
  if (net < 0) return t.money.direction.pay;
  return t.money.status.settled;
}

class _ContactAction {
  const _ContactAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
}
