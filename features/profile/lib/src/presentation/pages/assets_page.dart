import 'package:core/core.dart'
    show
        AppCurrency,
        AppRoutes,
        appSettingsProvider,
        formatStoredMoney,
        overlayAppBar,
        parseStoredAmount,
        toPersianDigits;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart' show AssetAccountKind;
import 'package:translations/translations.dart' show Translations;
import 'package:ui_kit/ui_kit.dart'
    show AppHaptics, AppSpacing, KitCard, KitLoading;

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
        onPressed: () => _addAccount(context, ref, t, currency),
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
                        t.profile.netWorth,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        money(state.netWorth),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(t.profile.assetsTotal(amount: money(state.totalAssets))),
                      Text(t.profile.openDebts(amount: money(state.openPay))),
                      Text(
                        t.profile.openReceivables(amount: money(state.openReceive)),
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
                    ),
              ],
            ),
    );
  }

  String _kindLabel(Translations t, AssetAccountKind kind) {
    return switch (kind) {
      AssetAccountKind.cash => t.profile.kindCash,
      AssetAccountKind.bank => t.profile.kindBank,
      AssetAccountKind.other => t.profile.kindOther,
    };
  }

  Future<void> _addAccount(
    BuildContext context,
    WidgetRef ref,
    Translations t,
    AppCurrency currency,
  ) async {
    final name = TextEditingController();
    final balance = TextEditingController();
    final kind = ValueNotifier(AssetAccountKind.cash);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.profile.addAsset),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(labelText: t.profile.assetName),
            ),
            TextField(
              controller: balance,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: t.profile.assetBalance),
            ),
          ],
        ),
        actions: [
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
    );
    if (ok != true || !context.mounted) return;
    final parsed = parseStoredAmount(balance.text, currency);
    if (name.text.trim().isEmpty || parsed == null) return;
    await ref.read(assetsControllerProvider.notifier).saveAccount(
          name: name.text,
          kind: kind.value,
          balance: parsed,
        );
    AppHaptics.confirm();
  }
}
