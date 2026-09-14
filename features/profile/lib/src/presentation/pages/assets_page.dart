import 'package:core/core.dart'
    show
        AppCurrency,
        AppRoutes,
        appSettingsProvider,
        formatStoredMoney,
        overlayAppBar,
        parseStoredAmount;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart' show AssetAccount, AssetAccountKind;
import 'package:translations/translations.dart' show Translations;
import 'package:ui_kit/ui_kit.dart'
    show AppHaptics, AppSpacing, KitCard, KitLoading, showKitConfirmDialog;

import '../../application/assets_controller.dart';

class AssetsPage extends ConsumerWidget {
  const AssetsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final state = ref.watch(assetsControllerProvider);
    final currency = ref.watch(appSettingsProvider).currency;
    final persian = Localizations.localeOf(context).languageCode == 'fa';
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

    return Scaffold(
      appBar: overlayAppBar(
        context: context,
        title: Text(t.profile.assets),
        fallbackPath: AppRoutes.profile.path,
        backTooltip: t.app.actions.back,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editAccount(context, ref, t, currency),
        child: const Icon(Icons.add_rounded),
      ),
      body: state.loading
          ? const Center(child: KitLoading())
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                KitCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.profile.totalBalance,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        money(state.total),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (state.accounts.isEmpty)
                  Text(t.profile.emptyAssets)
                else
                  for (final account in state.accounts)
                    ListTile(
                      title: Text(account.name),
                      subtitle: Text(_kindLabel(t, account.kind)),
                      trailing: Text(money(account.balance)),
                      onTap: () => _editAccount(
                        context,
                        ref,
                        t,
                        currency,
                        account: account,
                      ),
                    ),
              ],
            ),
    );
  }

  String _kindLabel(Translations t, AssetAccountKind kind) {
    return switch (kind) {
      AssetAccountKind.cash => t.profile.kindCash,
      AssetAccountKind.bank => t.profile.kindBank,
      AssetAccountKind.gold => t.profile.kindGold,
      AssetAccountKind.other => t.profile.kindOther,
    };
  }

  Future<void> _editAccount(
    BuildContext context,
    WidgetRef ref,
    Translations t,
    AppCurrency currency, {
    AssetAccount? account,
  }) async {
    final name = TextEditingController(text: account?.name ?? '');
    final balance = TextEditingController(
      text: account == null ? '' : '${account.balance}',
    );
    var kind = account?.kind ?? AssetAccountKind.cash;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(account == null ? t.profile.addAsset : t.profile.editAsset),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  decoration: InputDecoration(labelText: t.profile.assetName),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: balance,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: t.profile.assetBalance),
                ),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(t.profile.assetKind),
                ),
                Wrap(
                  spacing: AppSpacing.xs,
                  children: [
                    for (final value in AssetAccountKind.values)
                      ChoiceChip(
                        label: Text(_kindLabel(t, value)),
                        selected: kind == value,
                        onSelected: (_) => setLocal(() => kind = value),
                      ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            if (account != null)
              TextButton(
                onPressed: () async {
                  final confirm = await showKitConfirmDialog(
                    context: ctx,
                    title: t.profile.deleteAsset,
                    body: t.profile.deleteAssetConfirm,
                    confirmLabel: t.app.actions.confirm,
                    cancelLabel: t.app.actions.cancel,
                  );
                  if (!confirm || !ctx.mounted) return;
                  await ref
                      .read(assetsControllerProvider.notifier)
                      .deleteAccount(account.id);
                  if (ctx.mounted) Navigator.pop(ctx, false);
                },
                child: Text(t.profile.deleteAsset),
              ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(t.app.actions.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(t.app.actions.confirm),
            ),
          ],
        ),
      ),
    );
    if (ok != true || !context.mounted) return;
    final parsed = parseStoredAmount(balance.text, currency);
    if (name.text.trim().isEmpty || parsed == null) return;
    await ref.read(assetsControllerProvider.notifier).saveAccount(
          id: account?.id,
          name: name.text,
          kind: kind,
          balance: parsed,
        );
    AppHaptics.confirm();
  }
}
