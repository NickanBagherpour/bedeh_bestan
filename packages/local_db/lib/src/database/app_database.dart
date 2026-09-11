import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/enums.dart';
import '../models/library_snapshot.dart';
import '../models/money_item.dart';
import '../models/money_payment.dart';
import '../models/note.dart';
import '../models/party.dart';
import '../models/reminder.dart';
import 'tables.dart';
import 'tags.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Parties,
    MoneyItems,
    MoneyPayments,
    Reminders,
    Notes,
    MetaEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// On-device file (Android / iOS / Linux / web via drift_flutter).
  ///
  /// Web needs [DriftWebOptions] plus `sqlite3.wasm` and `drift_worker.js`
  /// in `apps/bedeh_bestan/web/` (same Drift release as `pubspec.lock`).
  factory AppDatabase.open() {
    return AppDatabase(
      driftDatabase(
        name: 'bedeh_bestan',
        web: DriftWebOptions(
          sqlite3Wasm: Uri.parse('sqlite3.wasm'),
          driftWorker: Uri.parse('drift_worker.js'),
        ),
      ),
    );
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<LibrarySnapshot> snapshot() async {
    final partyRows = await select(parties).get();
    final moneyRows = await select(moneyItems).get();
    final reminderRows = await select(reminders).get();
    final noteRows = await select(notes).get();
    return LibrarySnapshot(
      partyCount: partyRows.length,
      moneyCount: moneyRows.length,
      openMoneyCount:
          moneyRows.where((row) => row.paidAmount < row.totalAmount).length,
      reminderCount: reminderRows.length,
      noteCount: noteRows.length,
    );
  }

  Future<List<Party>> listParties() async {
    final rows = await select(parties).get();
    return [for (final row in rows) partyFromRow(row)];
  }

  Future<List<MoneyItem>> listMoneyItems() async {
    final rows = await select(moneyItems).get();
    return [for (final row in rows) moneyFromRow(row)];
  }

  Future<List<MoneyPayment>> listPaymentsFor(String moneyItemId) async {
    final rows = await (select(moneyPayments)
          ..where((row) => row.moneyItemId.equals(moneyItemId)))
        .get();
    return [for (final row in rows) paymentFromRow(row)];
  }

  Future<List<Reminder>> listReminders() async {
    final rows = await select(reminders).get();
    return [for (final row in rows) reminderFromRow(row)];
  }

  Future<List<Note>> listNotes() async {
    final rows = await select(notes).get();
    return [for (final row in rows) noteFromRow(row)];
  }
}

Party partyFromRow(PartyRow row) {
  return Party(
    id: row.id,
    name: row.name,
    kind: enumByName(PartyKind.values, row.kind, PartyKind.custom),
    note: row.note,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}

MoneyItem moneyFromRow(MoneyItemRow row) {
  return MoneyItem(
    id: row.id,
    partyId: row.partyId,
    direction: enumByName(
      MoneyDirection.values,
      row.direction,
      MoneyDirection.pay,
    ),
    title: row.title,
    totalAmount: row.totalAmount,
    paidAmount: row.paidAmount,
    schedule: enumByName(
      MoneySchedule.values,
      row.schedule,
      MoneySchedule.oneTime,
    ),
    installmentCount: row.installmentCount,
    installmentAmount: row.installmentAmount,
    periodsPaid: row.periodsPaid,
    startDate: row.startDate,
    nextDueDate: row.nextDueDate,
    note: row.note,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}

MoneyPayment paymentFromRow(MoneyPaymentRow row) {
  return MoneyPayment(
    id: row.id,
    moneyItemId: row.moneyItemId,
    amount: row.amount,
    paidAt: row.paidAt,
    note: row.note,
  );
}

Reminder reminderFromRow(ReminderRow row) {
  return Reminder(
    id: row.id,
    title: row.title,
    body: row.body,
    startAt: row.startAt,
    endAt: row.endAt,
    allDay: row.allDay,
    repeatRule: enumByName(RepeatRule.values, row.repeatRule, RepeatRule.none),
    repeatEveryN: row.repeatEveryN,
    notifyOnTime: row.notifyOnTime,
    notifyDayBefore: row.notifyDayBefore,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}

Note noteFromRow(NoteRow row) {
  return Note(
    id: row.id,
    title: row.title,
    body: row.body,
    tags: decodeTags(row.tagsJson),
    pinned: row.pinned,
    partyId: row.partyId,
    moneyItemId: row.moneyItemId,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
