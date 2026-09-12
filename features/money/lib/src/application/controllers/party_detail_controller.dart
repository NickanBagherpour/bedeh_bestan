import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart'
    show
        MoneyItem,
        MoneyPayment,
        Party,
        PartyException,
        PartyFailure;

import '../../data/repositories/money_repository_provider.dart';
import '../state/party_detail_state.dart';

final partyDetailControllerProvider = NotifierProvider.autoDispose
    .family<PartyDetailController, PartyDetailState, String>(
  (id) => PartyDetailController(partyId: id),
);

final class PartyDetailController extends Notifier<PartyDetailState> {
  PartyDetailController({required this.partyId});

  final String partyId;

  @override
  PartyDetailState build() {
    final repo = ref.watch(moneyRepositoryProvider);
    Party? party;
    var items = <MoneyItem>[];
    var payments = <MoneyPayment>[];
    var partyLoaded = false;
    final itemIds = <String>{};

    void emit() {
      if (!partyLoaded) return;
      state = PartyDetailState(
        status: PartyDetailStatus.loaded,
        party: party,
        items: items,
        payments: [
          for (final payment in payments)
            if (itemIds.contains(payment.moneyItemId)) payment,
        ],
      );
    }

    void fail() {
      state = const PartyDetailState(
        status: PartyDetailStatus.error,
        errorKey: 'money.loadError',
      );
    }

    final partiesSub = repo.watchParties().listen(
      (parties) {
        Party? match;
        for (final candidate in parties) {
          if (candidate.id == partyId) {
            match = candidate;
            break;
          }
        }
        party = match;
        partyLoaded = true;
        emit();
      },
      onError: (_) => fail(),
    );
    final itemsSub = repo.watchItems().listen(
      (all) {
        items = [
          for (final item in all)
            if (item.partyId == partyId) item,
        ];
        itemIds
          ..clear()
          ..addAll(items.map((item) => item.id));
        emit();
      },
      onError: (_) => fail(),
    );
    final paymentsSub = repo.watchPayments().listen(
      (all) {
        payments = all;
        emit();
      },
      onError: (_) => fail(),
    );
    ref.onDispose(() {
      partiesSub.cancel();
      itemsSub.cancel();
      paymentsSub.cancel();
    });
    return const PartyDetailState(status: PartyDetailStatus.loading);
  }

  void retry() => ref.invalidateSelf();

  Future<String?> deleteParty() async {
    try {
      await ref.read(moneyRepositoryProvider).deleteParty(partyId);
      return null;
    } on PartyException catch (error) {
      return switch (error.failure) {
        PartyFailure.inUse => 'money.partyInUse',
        PartyFailure.missing => 'money.missingPartyItem',
      };
    } catch (_) {
      return 'money.saveError';
    }
  }
}
