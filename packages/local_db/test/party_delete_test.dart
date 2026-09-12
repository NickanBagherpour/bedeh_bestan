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

  test('deleteParty removes an unused party', () async {
    const id = 'party-unused';
    await db.upsertParty(
      Party(
        id: id,
        name: 'نگار',
        kind: PartyKind.person,
        createdAt: now,
        updatedAt: now,
      ),
    );
    expect((await db.partyUsage(id)).isEmpty, isTrue);
    await db.deleteParty(id);
    expect(await db.getParty(id), isNull);
  });

  test('deleteParty rejects a seed party that still has money', () async {
    expect(
      () => db.deleteParty(SeedIds.melli),
      throwsA(
        isA<PartyException>().having(
          (error) => error.failure,
          'failure',
          PartyFailure.inUse,
        ),
      ),
    );
    expect(await db.getParty(SeedIds.melli), isNotNull);
  });

  test('deleteMoneyItem drops payments and unlinks notes', () async {
    final sheba = await db.getNote(SeedIds.noteSheba);
    expect(sheba?.moneyItemId, SeedIds.melliInstallment);
    await db.deleteMoneyItem(SeedIds.melliInstallment);
    expect(await db.getMoneyItem(SeedIds.melliInstallment), isNull);
    expect(await db.listPaymentsFor(SeedIds.melliInstallment), isEmpty);
    expect((await db.getNote(SeedIds.noteSheba))?.moneyItemId, isNull);
  });

  test('deleteParty unlinks notes after money is gone', () async {
    for (final id in SeedIds.moneyItems) {
      await db.deleteMoneyItem(id);
    }
    await db.deleteParty(SeedIds.melli);
    expect(await db.getParty(SeedIds.melli), isNull);
    expect((await db.getNote(SeedIds.noteSheba))?.partyId, isNull);
  });
}
