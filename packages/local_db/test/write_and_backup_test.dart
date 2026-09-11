import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart';
import 'package:local_db/memory.dart';

void main() {
  late AppDatabase db;
  final now = DateTime(2026, 9, 11, 12);

  setUp(() async {
    db = openMemoryDatabase();
    await seedDemoData(db, now: now);
  });

  tearDown(() async {
    await db.close();
  });

  test('inserts a party, money item, payment, note, and reminder', () async {
    final party = Party(
      id: 'party-new',
      name: 'نگار',
      kind: PartyKind.person,
      createdAt: now,
      updatedAt: now,
    );
    await db.upsertParty(party);

    final item = MoneyItem(
      id: 'money-new',
      partyId: party.id,
      direction: MoneyDirection.pay,
      title: 'قرض جدید',
      totalAmount: 1000000,
      paidAmount: 0,
      schedule: MoneySchedule.oneTime,
      startDate: now,
      nextDueDate: now,
      createdAt: now,
      updatedAt: now,
    );
    await db.upsertMoneyItem(item);

    final paid = await db.recordPayment(
      moneyItemId: item.id,
      amount: 250000,
      now: now,
    );
    expect(paid.remainingAmount, 750000);

    await db.upsertNote(
      Note(
        id: 'note-new',
        title: 'یادداشت تازه',
        body: 'متن',
        tags: const ['کار'],
        pinned: false,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await db.upsertReminder(
      Reminder(
        id: 'rem-new',
        title: 'تماس',
        startAt: now,
        allDay: true,
        repeatRule: RepeatRule.none,
        notifyOnTime: true,
        notifyDayBefore: false,
        createdAt: now,
        updatedAt: now,
      ),
    );

    expect(await db.getParty(party.id), isNotNull);
    expect(await db.getMoneyItem(item.id), isNotNull);
    expect(await db.getNote('note-new'), isNotNull);
    expect(await db.getReminder('rem-new'), isNotNull);
  });

  test('backup round-trips user rows', () async {
    await db.upsertNote(
      Note(
        id: 'note-backup',
        title: 'پشتیبان',
        body: '',
        tags: const [],
        pinned: true,
        createdAt: now,
        updatedAt: now,
      ),
    );
    final json = await db.exportBackupJson();
    final clone = openMemoryDatabase();
    addTearDown(clone.close);
    await clone.importBackupJson(json);
    final note = await clone.getNote('note-backup');
    expect(note?.title, 'پشتیبان');
    expect(note?.pinned, isTrue);
    expect(await clone.getMoneyItem(SeedIds.shopOverdue), isNotNull);
  });

  test('createAll restores a dropped payments table so inserts work', () async {
    await db.customStatement('DROP TABLE IF EXISTS money_payments');
    await db.createMigrator().createAll();
    final updated = await db.recordPayment(
      moneyItemId: SeedIds.shopOverdue,
      amount: 100000,
      now: now,
    );
    expect(updated.paidAmount, 100000);
  });

  test('rejects a non-backup file', () {
    expect(
      () => db.importBackupJson('{"hello":true}'),
      throwsA(isA<BackupException>()),
    );
  });
}
