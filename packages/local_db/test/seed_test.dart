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

  test('seed is idempotent and fills all tables', () async {
    await seedDemoData(db, now: now);
    final snap = await db.snapshot();
    expect(snap.partyCount, 5);
    expect(snap.moneyCount, 6);
    expect(snap.openMoneyCount, 5);
    expect(snap.reminderCount, 3);
    expect(snap.noteCount, 3);
  });

  test('installment remaining and statuses match seed dates', () async {
    final items = await db.listMoneyItems();
    final byId = {for (final item in items) item.id: item};

    final installment = byId[SeedIds.melliInstallment]!;
    expect(installment.schedule, MoneySchedule.installment);
    expect(installment.remainingAmount, 45000000);
    expect(installment.remainingPeriods, 9);
    expect(installment.statusOn(now), MoneyStatus.upcoming);

    expect(byId[SeedIds.shopOverdue]!.statusOn(now), MoneyStatus.overdue);
    expect(byId[SeedIds.garageToday]!.statusOn(now), MoneyStatus.dueToday);
    expect(byId[SeedIds.aliSettled]!.statusOn(now), MoneyStatus.settled);
    expect(byId[SeedIds.aliDue]!.remainingAmount, 2000000);
    expect(byId[SeedIds.aliDue]!.direction, MoneyDirection.receive);
  });

  test('notes can link to party and money', () async {
    final notes = await db.listNotes();
    final sheba = notes.firstWhere((note) => note.id == SeedIds.noteSheba);
    expect(sheba.pinned, isTrue);
    expect(sheba.partyId, SeedIds.melli);
    expect(sheba.moneyItemId, SeedIds.melliInstallment);
    expect(sheba.tags, contains('شبا'));
  });

  test('partial payments are stored on the installment', () async {
    final payments = await db.listPaymentsFor(SeedIds.melliInstallment);
    expect(payments, hasLength(3));
    expect(
      payments.fold<int>(0, (sum, payment) => sum + payment.amount),
      15000000,
    );
  });

  test('retireDemoSeed drops demo rows and keeps user rows', () async {
    await db.upsertParty(
      Party(
        id: 'party-user',
        name: 'نگار',
        kind: PartyKind.person,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await retireDemoSeed(db);
    final snap = await db.snapshot();
    expect(snap.partyCount, 1);
    expect(snap.moneyCount, 0);
    expect(snap.reminderCount, 0);
    expect(snap.noteCount, 0);
    expect(await db.getParty('party-user'), isNotNull);
    expect(await db.getParty(SeedIds.ali), isNull);
    await retireDemoSeed(db);
    expect((await db.snapshot()).partyCount, 1);
  });
}
