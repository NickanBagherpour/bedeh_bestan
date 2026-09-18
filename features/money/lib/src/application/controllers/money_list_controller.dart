import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_db/local_db.dart'
    show
        MoneyInstallment,
        MoneyItem,
        MoneySchedule,
        Party,
        PartyException,
        PartyFailure,
        PartyKind,
        PaymentException,
        PaymentFailure;

import '../../data/repositories/money_repository_provider.dart';
import '../money_query.dart';
import '../state/money_list_state.dart';

final moneyListControllerProvider =
    NotifierProvider<MoneyListController, MoneyListState>(
  MoneyListController.new,
);

final class MoneyListController extends Notifier<MoneyListState> {
  @override
  MoneyListState build() {
    final repo = ref.watch(moneyRepositoryProvider);
    var items = <MoneyItem>[];
    var parties = <String, Party>{};

    void emit() {
      state = state.copyWith(
        status: MoneyListStatus.loaded,
        items: items,
        parties: parties,
        clearError: true,
      );
    }

    final itemsSub = repo.watchItems().listen(
      (value) {
        items = value;
        emit();
      },
      onError: (_) {
        state = state.copyWith(
          status: MoneyListStatus.error,
          errorKey: 'money.loadError',
        );
      },
    );
    final partiesSub = repo.watchParties().listen(
      (value) {
        parties = {for (final party in value) party.id: party};
        emit();
      },
      onError: (_) {
        state = state.copyWith(
          status: MoneyListStatus.error,
          errorKey: 'money.loadError',
        );
      },
    );
    ref.onDispose(() {
      itemsSub.cancel();
      partiesSub.cancel();
    });
    return const MoneyListState(status: MoneyListStatus.loading);
  }

  void retry() => ref.invalidateSelf();

  void setFilter(MoneyListFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void setHideSettled({required bool hide}) {
    state = state.copyWith(hideSettled: hide);
  }

  Future<Party> saveParty({
    required String name,
    required PartyKind kind,
    String? id,
    String? note,
    String? phone,
    String? nationalCode,
    String? birthDate,
    String? cardNumber,
    String? sheba,
  }) async {
    final repo = ref.read(moneyRepositoryProvider);
    final now = DateTime.now();
    final existing = id == null ? null : await repo.getParty(id);
    final party = Party(
      id: id ?? repo.nextId('party'),
      name: name.trim(),
      kind: kind,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
      note: _resolveField(note, existing?.note),
      phone: _resolveField(phone, existing?.phone),
      nationalCode: _resolveField(nationalCode, existing?.nationalCode),
      birthDate: _resolveField(birthDate, existing?.birthDate),
      cardNumber: _resolveField(cardNumber, existing?.cardNumber),
      sheba: _resolveField(sheba, existing?.sheba),
    );
    await repo.upsertParty(party);
    return party;
  }

  /// `null` keeps the previous value; anything else is trimmed to null-if-blank.
  String? _resolveField(String? next, String? previous) {
    if (next == null) return previous;
    final trimmed = next.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  Future<String?> deleteParty(String id) async {
    try {
      await ref.read(moneyRepositoryProvider).deleteParty(id);
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

  Future<String> saveDraft(MoneyDraft draft) async {
    final repo = ref.read(moneyRepositoryProvider);
    final now = DateTime.now();
    final existing =
        draft.id == null ? null : await repo.getItem(draft.id!);
    final itemId = draft.id ?? repo.nextId('money');
    final storedInstallments = [
      for (final row in draft.installments)
        MoneyInstallment(
          id: row.id ?? repo.nextId('inst'),
          moneyItemId: itemId,
          index: row.index,
          dueDate: row.dueDate,
          amount: row.amount,
        ),
    ];
    final item = MoneyItem(
      id: itemId,
      partyId: draft.partyId,
      direction: draft.direction,
      title: draft.title.trim(),
      totalAmount: draft.totalAmount,
      paidAmount: existing?.paidAmount ?? 0,
      schedule: draft.schedule,
      installmentCount: draft.installmentCount,
      installmentAmount: draft.installmentAmount,
      periodsPaid: existing?.periodsPaid ?? 0,
      startDate: draft.startDate,
      nextDueDate: draft.nextDueDate,
      note: draft.note,
      reminderPolicy: draft.reminderPolicy,
      reminderDaysBeforeJson: draft.reminderDaysBeforeJson,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
      installments: storedInstallments,
    );
    await repo.upsertItem(item);
    if (draft.schedule == MoneySchedule.installment) {
      await repo.replaceInstallments(itemId, storedInstallments);
    } else {
      await repo.replaceInstallments(itemId, const []);
    }
    return item.id;
  }

  Future<String?> deleteItem(String id) async {
    try {
      await ref.read(moneyRepositoryProvider).deleteItem(id);
      return null;
    } catch (_) {
      return 'money.saveError';
    }
  }
}

String paymentErrorKey(Object error) {
  if (error is PaymentException) {
    return switch (error.failure) {
      PaymentFailure.missingItem => 'money.missingItem',
      PaymentFailure.settled => 'money.alreadySettled',
      PaymentFailure.nonPositive => 'money.invalidAmount',
      PaymentFailure.exceedsRemaining => 'money.payTooLarge',
    };
  }
  return 'money.saveError';
}
