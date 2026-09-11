import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart' show MoneyItem, MoneyPayment, Party;

import '../../data/repositories/money_repository_provider.dart';
import 'money_list_controller.dart';
import '../state/money_detail_state.dart';

final moneyDetailControllerProvider = NotifierProvider.autoDispose
    .family<MoneyDetailController, MoneyDetailState, String>(
  (id) => MoneyDetailController(itemId: id),
);

final class MoneyDetailController extends Notifier<MoneyDetailState> {
  MoneyDetailController({required this.itemId});

  final String itemId;

  @override
  MoneyDetailState build() {
    final repo = ref.watch(moneyRepositoryProvider);
    MoneyItem? item;
    Party? party;
    var payments = <MoneyPayment>[];

    void emit() {
      if (item == null) {
        state = const MoneyDetailState(
          status: MoneyDetailStatus.error,
          errorKey: 'money.missingItem',
        );
        return;
      }
      state = MoneyDetailState(
        status: MoneyDetailStatus.loaded,
        item: item,
        party: party,
        payments: payments,
      );
    }

    final itemsSub = repo.watchItems().listen(
      (items) async {
        MoneyItem? next;
        for (final candidate in items) {
          if (candidate.id == itemId) {
            next = candidate;
            break;
          }
        }
        item = next;
        if (next != null) {
          party = await repo.getParty(next.partyId);
        }
        emit();
      },
      onError: (_) {
        state = const MoneyDetailState(
          status: MoneyDetailStatus.error,
          errorKey: 'money.loadError',
        );
      },
    );
    final paySub = repo.watchPaymentsFor(itemId).listen(
      (value) {
        payments = value;
        if (item != null) emit();
      },
      onError: (_) {
        state = const MoneyDetailState(
          status: MoneyDetailStatus.error,
          errorKey: 'money.loadError',
        );
      },
    );
    ref.onDispose(() {
      itemsSub.cancel();
      paySub.cancel();
    });
    return const MoneyDetailState(status: MoneyDetailStatus.loading);
  }

  void retry() => ref.invalidateSelf();

  Future<String?> recordPayment(int amount) async {
    state = state.copyWith(busy: true, clearError: true);
    try {
      await ref.read(moneyRepositoryProvider).recordPayment(
            moneyItemId: itemId,
            amount: amount,
          );
      state = state.copyWith(busy: false);
      return null;
    } catch (error) {
      final key = paymentErrorKey(error);
      state = state.copyWith(busy: false, errorKey: key);
      return key;
    }
  }

  Future<String?> deleteItem() async {
    try {
      await ref.read(moneyRepositoryProvider).deleteItem(itemId);
      return null;
    } catch (_) {
      return 'money.saveError';
    }
  }
}
