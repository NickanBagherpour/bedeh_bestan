import 'package:drift/drift.dart';

import '../models/enums.dart';
import 'app_database.dart';
import 'tags.dart';

const seedVersionKey = 'seed.version';
const seedVersion = '1';
const seedRetiredValue = 'retired';

/// Stable ids so notes can link to parties / money items.
abstract final class SeedIds {
  static const ali = 'party-ali';
  static const mom = 'party-mom';
  static const melli = 'party-melli';
  static const shop = 'party-shop';
  static const garage = 'party-garage';

  static const melliInstallment = 'money-melli-installment';
  static const shopOverdue = 'money-shop-overdue';
  static const aliDue = 'money-ali-due';
  static const momUpcoming = 'money-mom-upcoming';
  static const garageToday = 'money-garage-today';
  static const aliSettled = 'money-ali-settled';

  static const remMelli = 'rem-melli';
  static const remInsurance = 'rem-insurance';
  static const remAliCall = 'rem-ali-call';

  static const noteSheba = 'note-sheba';
  static const noteAli = 'note-ali';
  static const noteShop = 'note-shop';

  static const payMelli1 = 'pay-melli-1';
  static const payMelli2 = 'pay-melli-2';
  static const payMelli3 = 'pay-melli-3';
  static const payAliPartial = 'pay-ali-partial';
  static const payAliSettled = 'pay-ali-settled';

  static const parties = [ali, mom, melli, shop, garage];
  static const moneyItems = [
    melliInstallment,
    shopOverdue,
    aliDue,
    momUpcoming,
    garageToday,
    aliSettled,
  ];
  static const payments = [
    payMelli1,
    payMelli2,
    payMelli3,
    payAliPartial,
    payAliSettled,
  ];
  static const reminders = [remMelli, remInsurance, remAliCall];
  static const notes = [noteSheba, noteAli, noteShop];
}

/// Inserts Persian demo rows once. Safe to call on every launch.
Future<void> seedDemoData(AppDatabase db, {DateTime? now}) async {
  final existing = await (db.select(db.metaEntries)
        ..where((row) => row.key.equals(seedVersionKey)))
      .getSingleOrNull();
  if (existing?.value == seedVersion) return;

  final clock = now ?? DateTime.now();
  final today = DateTime(clock.year, clock.month, clock.day);
  final created = clock;

  await db.batch((batch) {
    batch.insertAll(db.parties, [
      PartiesCompanion.insert(
        id: SeedIds.ali,
        name: 'علی رضایی',
        kind: PartyKind.person.name,
        note: const Value('همکار قدیمی'),
        createdAt: created,
        updatedAt: created,
      ),
      PartiesCompanion.insert(
        id: SeedIds.mom,
        name: 'مامان',
        kind: PartyKind.person.name,
        createdAt: created,
        updatedAt: created,
      ),
      PartiesCompanion.insert(
        id: SeedIds.melli,
        name: 'بانک ملی',
        kind: PartyKind.bank.name,
        note: const Value('وام خرید کالا'),
        createdAt: created,
        updatedAt: created,
      ),
      PartiesCompanion.insert(
        id: SeedIds.shop,
        name: 'سوپر محله',
        kind: PartyKind.shop.name,
        createdAt: created,
        updatedAt: created,
      ),
      PartiesCompanion.insert(
        id: SeedIds.garage,
        name: 'تعمیرگاه بهروز',
        kind: PartyKind.custom.name,
        createdAt: created,
        updatedAt: created,
      ),
    ]);

    batch.insertAll(db.moneyItems, [
      MoneyItemsCompanion.insert(
        id: SeedIds.melliInstallment,
        partyId: SeedIds.melli,
        direction: MoneyDirection.pay.name,
        title: 'قسط وام کالا',
        totalAmount: 60000000,
        paidAmount: const Value(15000000),
        schedule: MoneySchedule.installment.name,
        installmentCount: const Value(12),
        installmentAmount: const Value(5000000),
        periodsPaid: const Value(3),
        startDate: today.subtract(const Duration(days: 90)),
        nextDueDate: today.add(const Duration(days: 2)),
        createdAt: created,
        updatedAt: created,
      ),
      MoneyItemsCompanion.insert(
        id: SeedIds.shopOverdue,
        partyId: SeedIds.shop,
        direction: MoneyDirection.pay.name,
        title: 'نسیه خرید ماه',
        totalAmount: 850000,
        paidAmount: const Value(0),
        schedule: MoneySchedule.oneTime.name,
        startDate: today.subtract(const Duration(days: 20)),
        nextDueDate: today.subtract(const Duration(days: 5)),
        createdAt: created,
        updatedAt: created,
      ),
      MoneyItemsCompanion.insert(
        id: SeedIds.aliDue,
        partyId: SeedIds.ali,
        direction: MoneyDirection.receive.name,
        title: 'قرض سفر',
        totalAmount: 2500000,
        paidAmount: const Value(500000),
        schedule: MoneySchedule.oneTime.name,
        startDate: today.subtract(const Duration(days: 14)),
        nextDueDate: today.add(const Duration(days: 3)),
        createdAt: created,
        updatedAt: created,
      ),
      MoneyItemsCompanion.insert(
        id: SeedIds.momUpcoming,
        partyId: SeedIds.mom,
        direction: MoneyDirection.receive.name,
        title: 'هزینه دارو',
        totalAmount: 1200000,
        paidAmount: const Value(0),
        schedule: MoneySchedule.oneTime.name,
        startDate: today,
        nextDueDate: today.add(const Duration(days: 10)),
        createdAt: created,
        updatedAt: created,
      ),
      MoneyItemsCompanion.insert(
        id: SeedIds.garageToday,
        partyId: SeedIds.garage,
        direction: MoneyDirection.pay.name,
        title: 'تعمیر ترمز',
        totalAmount: 3000000,
        paidAmount: const Value(0),
        schedule: MoneySchedule.oneTime.name,
        startDate: today.subtract(const Duration(days: 7)),
        nextDueDate: today,
        createdAt: created,
        updatedAt: created,
      ),
      MoneyItemsCompanion.insert(
        id: SeedIds.aliSettled,
        partyId: SeedIds.ali,
        direction: MoneyDirection.receive.name,
        title: 'بلیت کنسرت',
        totalAmount: 400000,
        paidAmount: const Value(400000),
        schedule: MoneySchedule.oneTime.name,
        startDate: today.subtract(const Duration(days: 40)),
        nextDueDate: today.subtract(const Duration(days: 30)),
        createdAt: created,
        updatedAt: created,
      ),
    ]);

    batch.insertAll(db.moneyPayments, [
      MoneyPaymentsCompanion.insert(
        id: SeedIds.payMelli1,
        moneyItemId: SeedIds.melliInstallment,
        amount: 5000000,
        paidAt: today.subtract(const Duration(days: 90)),
        note: const Value('قسط ۱'),
      ),
      MoneyPaymentsCompanion.insert(
        id: SeedIds.payMelli2,
        moneyItemId: SeedIds.melliInstallment,
        amount: 5000000,
        paidAt: today.subtract(const Duration(days: 60)),
        note: const Value('قسط ۲'),
      ),
      MoneyPaymentsCompanion.insert(
        id: SeedIds.payMelli3,
        moneyItemId: SeedIds.melliInstallment,
        amount: 5000000,
        paidAt: today.subtract(const Duration(days: 30)),
        note: const Value('قسط ۳'),
      ),
      MoneyPaymentsCompanion.insert(
        id: SeedIds.payAliPartial,
        moneyItemId: SeedIds.aliDue,
        amount: 500000,
        paidAt: today.subtract(const Duration(days: 7)),
        note: const Value('علی بخشی را داد'),
      ),
      MoneyPaymentsCompanion.insert(
        id: SeedIds.payAliSettled,
        moneyItemId: SeedIds.aliSettled,
        amount: 400000,
        paidAt: today.subtract(const Duration(days: 28)),
      ),
    ]);

    batch.insertAll(db.reminders, [
      RemindersCompanion.insert(
        id: SeedIds.remMelli,
        title: 'پرداخت قسط بانک ملی',
        body: const Value('۵ میلیون تومان — شعبه نزدیک خانه'),
        startAt: today.add(const Duration(days: 2, hours: 10)),
        allDay: const Value(false),
        repeatRule: RepeatRule.monthly.name,
        notifyOnTime: const Value(true),
        notifyDayBefore: const Value(true),
        createdAt: created,
        updatedAt: created,
      ),
      RemindersCompanion.insert(
        id: SeedIds.remInsurance,
        title: 'تمدید بیمه شخص ثالث',
        startAt: today.add(const Duration(days: 18)),
        allDay: const Value(true),
        repeatRule: RepeatRule.yearly.name,
        notifyOnTime: const Value(true),
        notifyDayBefore: const Value(true),
        createdAt: created,
        updatedAt: created,
      ),
      RemindersCompanion.insert(
        id: SeedIds.remAliCall,
        title: 'تماس با علی برای قرض',
        body: const Value('یادآوری دوستانه، نه اصرار'),
        startAt: today.add(const Duration(days: 1, hours: 19)),
        allDay: const Value(false),
        repeatRule: RepeatRule.none.name,
        notifyOnTime: const Value(true),
        createdAt: created,
        updatedAt: created,
      ),
    ]);

    batch.insertAll(db.notes, [
      NotesCompanion.insert(
        id: SeedIds.noteSheba,
        title: 'شبا بانک ملی',
        body: const Value('IR12 0170 0000 0000 0000 0000 01\nبه نام خودم'),
        tagsJson: Value(encodeTags(const ['بانک', 'شبا'])),
        pinned: const Value(true),
        partyId: const Value(SeedIds.melli),
        moneyItemId: const Value(SeedIds.melliInstallment),
        createdAt: created,
        updatedAt: created,
      ),
      NotesCompanion.insert(
        id: SeedIds.noteAli,
        title: 'قرار علی',
        body: const Value('گفت تا پنجشنبه بقیه قرض سفر را می‌دهد.'),
        tagsJson: Value(encodeTags(const ['طلب', 'علی'])),
        partyId: const Value(SeedIds.ali),
        moneyItemId: const Value(SeedIds.aliDue),
        createdAt: created,
        updatedAt: created,
      ),
      NotesCompanion.insert(
        id: SeedIds.noteShop,
        title: 'خرید خانه',
        body: const Value('روغن و برنج نسیه شد؛ رسید را روی یخچال چسباندم.'),
        tagsJson: Value(encodeTags(const ['خرید'])),
        partyId: const Value(SeedIds.shop),
        createdAt: created,
        updatedAt: created,
      ),
    ]);

    batch.insert(
      db.metaEntries,
      MetaEntriesCompanion.insert(key: seedVersionKey, value: seedVersion),
      mode: InsertMode.insertOrReplace,
    );
  });
}

/// Removes demo rows from a production install that still has seed v1.
///
/// User-created rows (new ids) are kept. Safe to call on every launch.
Future<void> retireDemoSeed(AppDatabase db) async {
  final existing = await (db.select(db.metaEntries)
        ..where((row) => row.key.equals(seedVersionKey)))
      .getSingleOrNull();
  if (existing?.value != seedVersion) return;

  await db.transaction(() async {
    await (db.delete(db.notes)..where((row) => row.id.isIn(SeedIds.notes))).go();
    await (db.delete(db.moneyPayments)
          ..where((row) => row.id.isIn(SeedIds.payments)))
        .go();
    await (db.delete(db.reminders)
          ..where((row) => row.id.isIn(SeedIds.reminders)))
        .go();
    await (db.delete(db.moneyItems)
          ..where((row) => row.id.isIn(SeedIds.moneyItems)))
        .go();
    await (db.delete(db.parties)..where((row) => row.id.isIn(SeedIds.parties)))
        .go();
    await db.into(db.metaEntries).insertOnConflictUpdate(
      MetaEntriesCompanion.insert(
        key: seedVersionKey,
        value: seedRetiredValue,
      ),
    );
  });
}
