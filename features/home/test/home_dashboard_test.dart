import 'package:feature_home/src/application/home_dashboard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart';

void main() {
  final now = DateTime(2026, 9, 11);

  test('splits overdue, this week, and party balances', () {
    final ali = Party(
      id: 'ali',
      name: 'علی',
      kind: PartyKind.person,
      createdAt: now,
      updatedAt: now,
    );
    final shop = Party(
      id: 'shop',
      name: 'فروشگاه',
      kind: PartyKind.shop,
      createdAt: now,
      updatedAt: now,
    );

    MoneyItem money({
      required String id,
      required String partyId,
      required MoneyDirection direction,
      required DateTime due,
      int total = 1000,
      int paid = 0,
    }) {
      return MoneyItem(
        id: id,
        partyId: partyId,
        direction: direction,
        title: id,
        totalAmount: total,
        paidAmount: paid,
        schedule: MoneySchedule.oneTime,
        startDate: due,
        nextDueDate: due,
        createdAt: now,
        updatedAt: now,
      );
    }

    final dashboard = buildHomeDashboard(
      items: [
        money(
          id: 'overdue',
          partyId: shop.id,
          direction: MoneyDirection.pay,
          due: now.subtract(const Duration(days: 3)),
          total: 800,
        ),
        money(
          id: 'week',
          partyId: ali.id,
          direction: MoneyDirection.receive,
          due: now.add(const Duration(days: 2)),
          total: 2500,
        ),
        money(
          id: 'later',
          partyId: ali.id,
          direction: MoneyDirection.receive,
          due: now.add(const Duration(days: 20)),
          total: 400,
        ),
        money(
          id: 'done',
          partyId: shop.id,
          direction: MoneyDirection.pay,
          due: now,
          total: 100,
          paid: 100,
        ),
      ],
      parties: [ali, shop],
      now: now,
    );

    expect(dashboard.overdue.map((row) => row.id), ['overdue']);
    expect(dashboard.dueThisWeek.map((row) => row.id), ['week']);
    expect(dashboard.balances, hasLength(2));
    final aliBalance = dashboard.balances.firstWhere((row) => row.partyId == ali.id);
    expect(aliBalance.receiveRemaining, 2900);
    expect(aliBalance.payRemaining, 0);
    final shopBalance =
        dashboard.balances.firstWhere((row) => row.partyId == shop.id);
    expect(shopBalance.payRemaining, 800);
  });
}
