import 'package:core/core.dart' show AppRoutes;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart' show Party;
import 'package:translations/translations.dart'
    show Translations, TranslationsLookup;
import 'package:ui_kit/ui_kit.dart'
    show AppHaptics, AppMotion, AppSpacing, KitEmpty, KitError, KitLoading;

import '../../application/controllers/money_list_controller.dart';
import '../../application/state/money_list_state.dart';
import '../money_style.dart';
import '../widgets/party_tile.dart';

class PartyListPage extends ConsumerStatefulWidget {
  const PartyListPage({super.key});

  @override
  ConsumerState<PartyListPage> createState() => _PartyListPageState();
}

class _PartyListPageState extends ConsumerState<PartyListPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final state = ref.watch(moneyListControllerProvider);
    final parties = [
      ...state.parties.values,
    ]..sort((a, b) => a.name.compareTo(b.name));
    final q = _query.trim().toLowerCase();
    final visible = [
      for (final party in parties)
        if (q.isEmpty || party.name.toLowerCase().contains(q)) party,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(t.money.parties)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          AppHaptics.light();
          context.push(AppRoutes.partyNew.path);
        },
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: Text(t.money.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: TextField(
              decoration: InputDecoration(
                labelText: t.money.searchParty,
                prefixIcon: const Icon(Icons.search_rounded),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: AppMotion.normal,
              child: _body(context, t, state, parties, visible),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(
    BuildContext context,
    Translations t,
    MoneyListState state,
    List<Party> parties,
    List<Party> visible,
  ) {
    if (state.status == MoneyListStatus.error) {
      return KitError(
        key: const ValueKey('error'),
        message: t.message(
          state.errorKey ?? 'money.loadError',
          shouldTranslate: true,
        ),
        retryLabel: t.app.actions.retry,
        onRetry: () => ref.read(moneyListControllerProvider.notifier).retry(),
      );
    }
    if (state.status == MoneyListStatus.loading) {
      return const KitLoading(key: ValueKey('loading'));
    }
    if (parties.isEmpty) {
      return KitEmpty(
        key: const ValueKey('empty'),
        icon: Icons.people_alt_outlined,
        title: t.money.emptyParties,
        body: t.money.emptyPartiesBody,
        action: FilledButton.tonal(
          onPressed: () {
            AppHaptics.light();
            context.push(AppRoutes.partyNew.path);
          },
          child: Text(t.money.add),
        ),
      );
    }
    if (visible.isEmpty) {
      return KitEmpty(
        key: const ValueKey('filter'),
        icon: Icons.search_off_rounded,
        title: t.money.emptyPartyFilter,
        body: t.money.emptyPartiesBody,
      );
    }

    return ListView.separated(
      key: const ValueKey('list'),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        88,
      ),
      itemCount: visible.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final party = visible[index];
        return PartyTile(
          name: party.name,
          kindLabel: partyKindLabel(t, party.kind),
          onTap: () => context.push(AppRoutes.partyItemPath(party.id)),
        );
      },
    );
  }
}
