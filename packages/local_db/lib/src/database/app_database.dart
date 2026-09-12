import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/enums.dart';
import '../models/library_snapshot.dart';
import '../models/money_item.dart';
import '../models/money_payment.dart';
import '../models/note.dart';
import '../models/party.dart';
import '../models/reminder.dart';
import 'backup.dart';
import 'checklist.dart';
import 'ids.dart';
import 'party_exception.dart';
import 'payment_exception.dart';
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
        native: DriftNativeOptions(
          // One writer + live streams without SQLITE_BUSY / "database is locked".
          shareAcrossIsolates: true,
          setup: (db) {
            db.execute('PRAGMA busy_timeout = 8000');
            db.execute('PRAGMA journal_mode = WAL');
            db.execute('PRAGMA foreign_keys = ON');
          },
        ),
        web: DriftWebOptions(
          sqlite3Wasm: Uri.parse('sqlite3.wasm'),
          driftWorker: Uri.parse('drift_worker.js'),
        ),
      ),
    );
  }

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        // Never drop user tables. CREATE TABLE IF NOT EXISTS fills gaps from
        // earlier v1 builds that kept schemaVersion at 1 while tables were added.
        await m.createAll();
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA busy_timeout = 8000');
        await customStatement('PRAGMA journal_mode = WAL');
        await customStatement('PRAGMA foreign_keys = ON');
        await createMigrator().createAll();
        await _ensureColumns();
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

  Stream<List<Party>> watchParties() {
    return select(parties).watch().map(
      (rows) => [for (final row in rows) partyFromRow(row)],
    );
  }

  Stream<List<MoneyItem>> watchMoneyItems() {
    return select(moneyItems).watch().map(
      (rows) => [for (final row in rows) moneyFromRow(row)],
    );
  }

  Stream<List<MoneyPayment>> watchPayments() {
    final query = select(moneyPayments)
      ..orderBy([(row) => OrderingTerm.desc(row.paidAt)]);
    return query.watch().map(
      (rows) => [for (final row in rows) paymentFromRow(row)],
    );
  }

  Stream<List<MoneyPayment>> watchPaymentsFor(String moneyItemId) {
    final query = select(moneyPayments)
      ..where((row) => row.moneyItemId.equals(moneyItemId))
      ..orderBy([(row) => OrderingTerm.desc(row.paidAt)]);
    return query.watch().map(
      (rows) => [for (final row in rows) paymentFromRow(row)],
    );
  }

  Future<List<Party>> listParties() async {
    final rows = await select(parties).get();
    return [for (final row in rows) partyFromRow(row)];
  }

  Future<Party?> getParty(String id) async {
    final row = await (select(parties)..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : partyFromRow(row);
  }

  Future<List<MoneyItem>> listMoneyItems() async {
    final rows = await select(moneyItems).get();
    return [for (final row in rows) moneyFromRow(row)];
  }

  Future<MoneyItem?> getMoneyItem(String id) async {
    final row = await (select(moneyItems)..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : moneyFromRow(row);
  }

  Future<List<MoneyPayment>> listPaymentsFor(String moneyItemId) async {
    final rows = await (select(moneyPayments)
          ..where((row) => row.moneyItemId.equals(moneyItemId)))
        .get();
    return [for (final row in rows) paymentFromRow(row)];
  }

  Future<void> upsertParty(Party party) {
    return into(parties).insertOnConflictUpdate(
      PartiesCompanion(
        id: Value(party.id),
        name: Value(party.name),
        kind: Value(party.kind.name),
        note: Value(party.note),
        phone: Value(party.phone),
        nationalCode: Value(party.nationalCode),
        birthDate: Value(party.birthDate),
        cardNumber: Value(party.cardNumber),
        sheba: Value(party.sheba),
        createdAt: Value(party.createdAt),
        updatedAt: Value(party.updatedAt),
      ),
    );
  }

  Future<PartyUsage> partyUsage(String id) async {
    final moneyRows = await (select(moneyItems)
          ..where((row) => row.partyId.equals(id)))
        .get();
    final noteRows = await (select(notes)
          ..where((row) => row.partyId.equals(id)))
        .get();
    return PartyUsage(
      moneyCount: moneyRows.length,
      noteCount: noteRows.length,
    );
  }

  Future<void> deleteParty(String id) async {
    final usage = await partyUsage(id);
    if (usage.moneyCount > 0) {
      throw const PartyException(PartyFailure.inUse);
    }
    final existing = await getParty(id);
    if (existing == null) {
      throw const PartyException(PartyFailure.missing);
    }
    await transaction(() async {
      await customStatement(
        'UPDATE notes SET party_id = NULL WHERE party_id = ?',
        [id],
      );
      await (delete(parties)..where((row) => row.id.equals(id))).go();
    });
  }

  Future<void> deleteMoneyItem(String id) async {
    final existing = await getMoneyItem(id);
    if (existing == null) return;
    await transaction(() async {
      await customStatement(
        'UPDATE notes SET money_item_id = NULL WHERE money_item_id = ?',
        [id],
      );
      await (delete(moneyPayments)..where((row) => row.moneyItemId.equals(id)))
          .go();
      await (delete(moneyItems)..where((row) => row.id.equals(id))).go();
    });
  }

  Future<void> upsertMoneyItem(MoneyItem item) {
    return into(moneyItems).insertOnConflictUpdate(
      MoneyItemsCompanion(
        id: Value(item.id),
        partyId: Value(item.partyId),
        direction: Value(item.direction.name),
        title: Value(item.title),
        totalAmount: Value(item.totalAmount),
        paidAmount: Value(item.paidAmount),
        schedule: Value(item.schedule.name),
        installmentCount: Value(item.installmentCount),
        installmentAmount: Value(item.installmentAmount),
        periodsPaid: Value(item.periodsPaid),
        startDate: Value(item.startDate),
        nextDueDate: Value(item.nextDueDate),
        note: Value(item.note),
        createdAt: Value(item.createdAt),
        updatedAt: Value(item.updatedAt),
      ),
    );
  }

  /// Records a (possibly partial) payment and updates remaining / installments.
  Future<MoneyItem> recordPayment({
    required String moneyItemId,
    required int amount,
    DateTime? paidAt,
    String? note,
    DateTime? now,
  }) {
    return transaction(() async {
      final item = await getMoneyItem(moneyItemId);
      if (item == null) {
        throw const PaymentException(PaymentFailure.missingItem);
      }
      if (item.isSettled) {
        throw const PaymentException(PaymentFailure.settled);
      }
      if (amount <= 0) {
        throw const PaymentException(PaymentFailure.nonPositive);
      }
      if (amount > item.remainingAmount) {
        throw const PaymentException(PaymentFailure.exceedsRemaining);
      }

      final clock = now ?? DateTime.now();
      final at = paidAt ?? clock;
      await into(moneyPayments).insert(
        MoneyPaymentsCompanion.insert(
          id: newEntityId('pay'),
          moneyItemId: moneyItemId,
          amount: amount,
          paidAt: at,
          note: Value(note),
        ),
      );

      var periodsPaid = item.periodsPaid;
      var nextDue = item.nextDueDate;
      if (item.schedule == MoneySchedule.installment &&
          item.installmentAmount != null &&
          item.installmentAmount! > 0) {
        final extra = amount ~/ item.installmentAmount!;
        if (extra > 0) {
          final cap = item.installmentCount ?? (periodsPaid + extra);
          periodsPaid = math.min(cap, periodsPaid + extra);
          nextDue = addCalendarMonths(item.nextDueDate, extra);
        }
      }

      final updated = item.copyWith(
        paidAmount: item.paidAmount + amount,
        periodsPaid: periodsPaid,
        nextDueDate: nextDue,
        updatedAt: clock,
      );
      await upsertMoneyItem(updated);
      return updated;
    });
  }

  Stream<List<Reminder>> watchReminders() {
    final query = select(reminders)
      ..orderBy([(row) => OrderingTerm.asc(row.startAt)]);
    return query.watch().map(
      (rows) => [for (final row in rows) reminderFromRow(row)],
    );
  }

  Future<List<Reminder>> listReminders() async {
    final rows = await select(reminders).get();
    return [for (final row in rows) reminderFromRow(row)];
  }

  Future<Reminder?> getReminder(String id) async {
    final row = await (select(reminders)..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : reminderFromRow(row);
  }

  Future<void> upsertReminder(Reminder reminder) {
    return into(reminders).insertOnConflictUpdate(
      RemindersCompanion(
        id: Value(reminder.id),
        title: Value(reminder.title),
        body: Value(reminder.body),
        startAt: Value(reminder.startAt),
        endAt: Value(reminder.endAt),
        allDay: Value(reminder.allDay),
        repeatRule: Value(reminder.repeatRule.name),
        repeatEveryN: Value(reminder.repeatEveryN),
        notifyOnTime: Value(reminder.notifyOnTime),
        notifyDayBefore: Value(reminder.notifyDayBefore),
        createdAt: Value(reminder.createdAt),
        updatedAt: Value(reminder.updatedAt),
      ),
    );
  }

  Future<void> deleteReminder(String id) {
    return (delete(reminders)..where((row) => row.id.equals(id))).go();
  }

  Future<List<Note>> listNotes() async {
    final rows = await select(notes).get();
    return [for (final row in rows) noteFromRow(row)];
  }

  Stream<List<Note>> watchNotes() {
    return select(notes).watch().map(
      (rows) => [for (final row in rows) noteFromRow(row)],
    );
  }

  Future<Note?> getNote(String id) async {
    final row = await (select(notes)..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : noteFromRow(row);
  }

  Future<void> upsertNote(Note note) {
    return into(notes).insertOnConflictUpdate(
      NotesCompanion(
        id: Value(note.id),
        title: Value(note.title),
        body: Value(note.body),
        tagsJson: Value(encodeTags(note.tags)),
        checklistJson: Value(encodeChecklist(note.checklist)),
        pinned: Value(note.pinned),
        partyId: Value(_optionalFk(note.partyId)),
        moneyItemId: Value(_optionalFk(note.moneyItemId)),
        createdAt: Value(note.createdAt),
        updatedAt: Value(note.updatedAt),
      ),
    );
  }

  Future<void> deleteNote(String id) {
    return (delete(notes)..where((row) => row.id.equals(id))).go();
  }

  Future<LibraryDump> captureLibrary() async {
    final partyRows = await select(parties).get();
    final moneyRows = await select(moneyItems).get();
    final paymentRows = await select(moneyPayments).get();
    final reminderRows = await select(reminders).get();
    final noteRows = await select(notes).get();
    final metaRows = await select(metaEntries).get();
    return LibraryDump(
      schemaVersion: schemaVersion,
      parties: [for (final row in partyRows) partyFromRow(row)],
      moneyItems: [for (final row in moneyRows) moneyFromRow(row)],
      payments: [for (final row in paymentRows) paymentFromRow(row)],
      reminders: [for (final row in reminderRows) reminderFromRow(row)],
      notes: [for (final row in noteRows) noteFromRow(row)],
      meta: {for (final row in metaRows) row.key: row.value},
    );
  }

  Future<String> exportBackupJson() async {
    return encodeLibraryDump(await captureLibrary());
  }

  Future<void> importBackupJson(String raw) {
    return replaceLibrary(decodeLibraryDump(raw));
  }

  Future<void> replaceLibrary(LibraryDump dump) {
    return transaction(() async {
      await customStatement('PRAGMA foreign_keys = OFF');
      await delete(notes).go();
      await delete(moneyPayments).go();
      await delete(reminders).go();
      await delete(moneyItems).go();
      await delete(parties).go();
      await delete(metaEntries).go();
      for (final party in dump.parties) {
        await upsertParty(party);
      }
      for (final item in dump.moneyItems) {
        await upsertMoneyItem(item);
      }
      for (final payment in dump.payments) {
        await into(moneyPayments).insertOnConflictUpdate(
          MoneyPaymentsCompanion(
            id: Value(payment.id),
            moneyItemId: Value(payment.moneyItemId),
            amount: Value(payment.amount),
            paidAt: Value(payment.paidAt),
            note: Value(payment.note),
          ),
        );
      }
      for (final reminder in dump.reminders) {
        await upsertReminder(reminder);
      }
      for (final note in dump.notes) {
        await upsertNote(note);
      }
      for (final entry in dump.meta.entries) {
        await into(metaEntries).insertOnConflictUpdate(
          MetaEntriesCompanion(
            key: Value(entry.key),
            value: Value(entry.value),
          ),
        );
      }
      await customStatement('PRAGMA foreign_keys = ON');
    });
  }

  Future<void> _ensureColumns() async {
    await _ensureColumn('parties', 'note', 'TEXT NULL');
    await _ensureColumn('parties', 'phone', 'TEXT NULL');
    await _ensureColumn('parties', 'national_code', 'TEXT NULL');
    await _ensureColumn('parties', 'birth_date', 'TEXT NULL');
    await _ensureColumn('parties', 'card_number', 'TEXT NULL');
    await _ensureColumn('parties', 'sheba', 'TEXT NULL');
    await _ensureColumn('money_items', 'paid_amount', 'INTEGER NOT NULL DEFAULT 0');
    await _ensureColumn(
      'money_items',
      'installment_count',
      'INTEGER NULL',
    );
    await _ensureColumn(
      'money_items',
      'installment_amount',
      'INTEGER NULL',
    );
    await _ensureColumn(
      'money_items',
      'periods_paid',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await _ensureColumn('money_items', 'note', 'TEXT NULL');
    await _ensureColumn('reminders', 'body', 'TEXT NULL');
    await _ensureColumn('reminders', 'end_at', 'INTEGER NULL');
    await _ensureColumn(
      'reminders',
      'all_day',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await _ensureColumn('reminders', 'repeat_every_n', 'INTEGER NULL');
    await _ensureColumn(
      'reminders',
      'notify_on_time',
      'INTEGER NOT NULL DEFAULT 1',
    );
    await _ensureColumn(
      'reminders',
      'notify_day_before',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await _ensureColumn('notes', 'body', "TEXT NOT NULL DEFAULT ''");
    await _ensureColumn('notes', 'tags_json', "TEXT NOT NULL DEFAULT '[]'");
    await _ensureColumn(
      'notes',
      'checklist_json',
      "TEXT NOT NULL DEFAULT '[]'",
    );
    await _ensureColumn('notes', 'pinned', 'INTEGER NOT NULL DEFAULT 0');
    await _ensureColumn('notes', 'party_id', 'TEXT NULL');
    await _ensureColumn('notes', 'money_item_id', 'TEXT NULL');
  }

  Future<void> _ensureColumn(
    String table,
    String column,
    String spec,
  ) async {
    final rows = await customSelect('PRAGMA table_info($table)').get();
    if (rows.isEmpty) return;
    final exists = rows.any((row) => '${row.data['name']}' == column);
    if (exists) return;
    await customStatement('ALTER TABLE $table ADD COLUMN $column $spec');
  }
}

String? _optionalFk(String? id) {
  if (id == null || id.trim().isEmpty) return null;
  return id;
}

Party partyFromRow(PartyRow row) {
  return Party(
    id: row.id,
    name: row.name,
    kind: enumByName(PartyKind.values, row.kind, PartyKind.custom),
    note: row.note,
    phone: row.phone,
    nationalCode: row.nationalCode,
    birthDate: row.birthDate,
    cardNumber: row.cardNumber,
    sheba: row.sheba,
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
    checklist: decodeChecklist(row.checklistJson),
    pinned: row.pinned,
    partyId: row.partyId,
    moneyItemId: row.moneyItemId,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}

/// Gregorian month add that clamps the day (e.g. 31 Jan + 1 month → 28/29 Feb).
DateTime addCalendarMonths(DateTime date, int months) {
  final shifted = date.month - 1 + months;
  final year = date.year + (shifted / 12).floor();
  var month = (shifted % 12) + 1;
  if (month <= 0) {
    month += 12;
  }
  final lastDay = DateTime(year, month + 1, 0).day;
  final day = date.day < lastDay ? date.day : lastDay;
  return DateTime(
    year,
    month,
    day,
    date.hour,
    date.minute,
    date.second,
    date.millisecond,
    date.microsecond,
  );
}
