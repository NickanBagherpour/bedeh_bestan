import 'package:core/core.dart' show AppRoutes;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart' show MoneyItem, Party;
import 'package:translations/translations.dart'
    show Translations, TranslationsLookup;
import 'package:ui_kit/ui_kit.dart'
    show AppHaptics, AppSpacing, KitCard, KitError, KitLoading;

import '../../application/controllers/money_list_controller.dart';
import '../../application/state/money_list_state.dart';
import '../money_style.dart';

class PartyDetailPage extends ConsumerWidget {
  const PartyDetailPage({super.key, required this.partyId});

  final String partyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final list = ref.watch(moneyListControllerProvider);
    final party = list.partyFor(partyId);
    final linked = [
      for (final item in list.items)
        if (item.partyId == partyId) item,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(party?.name ?? t.money.parties),
        actions: [
          if (party != null)
            IconButton(
              tooltip: t.money.edit,
              onPressed: () => context.push(AppRoutes.partyEditPath(partyId)),
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
      ),
      body: _body(context, ref, t, theme, list, party, linked),
    );
  }

  Widget _body(
    BuildContext context,
    WidgetRef ref,
    Translations t,
    ThemeData theme,
    MoneyListState list,
    Party? party,
    List<MoneyItem> linked,
  ) {
    if (list.status == MoneyListStatus.error && party == null) {
      return KitError(
        message: t.message(
          list.errorKey ?? 'money.loadError',
          shouldTranslate: true,
        ),
        retryLabel: t.app.actions.retry,
        onRetry: () => ref.read(moneyListControllerProvider.notifier).retry(),
      );
    }
    if (party == null) {
      if (list.status == MoneyListStatus.loaded) {
        return KitError(message: t.money.missingPartyItem);
      }
      return const KitLoading();
    }

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
              if (party.note != null && party.note!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Text(party.note!),
              ],
            ],
          ),
        ),
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
          for (final item in linked) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(item.title),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(AppRoutes.moneyItemPath(item.id)),
            ),
          ],
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton(
          onPressed: () => _delete(context, ref, t),
          child: Text(t.money.deleteParty),
        ),
      ],
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Translations t,
  ) async {
    AppHaptics.warn();
    final errorKey =
        await ref.read(moneyListControllerProvider.notifier).deleteParty(partyId);
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
    context.go(AppRoutes.parties.path);
  }
}
