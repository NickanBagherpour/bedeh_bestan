import 'package:core/core.dart' show AppRoutes;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('nested money paths stay on the accounts tab', () {
    expect(AppRoutes.fromPath('/money/item/abc'), AppRoutes.money);
    expect(AppRoutes.fromPath('/money/new'), AppRoutes.money);
    expect(AppRoutes.fromPath('/money/parties'), AppRoutes.money);
    expect(AppRoutes.fromPath('/money/parties/abc/edit'), AppRoutes.money);
    expect(AppRoutes.indexOfPath('/money/item/abc/edit'), 1);
    expect(AppRoutes.moneyItemPath('x'), '/money/item/x');
    expect(AppRoutes.partyItemPath('x'), '/money/parties/x');
    expect(AppRoutes.partyEditPath('x'), '/money/parties/x/edit');
    expect(AppRoutes.moneyNewPath(direction: 'pay'), '/money/new?direction=pay');
    expect(AppRoutes.fromPath('/calendar/item/abc'), AppRoutes.calendar);
    expect(AppRoutes.indexOfPath('/calendar/new'), 2);
    expect(AppRoutes.reminderNewPath(day: DateTime(2026, 9, 11)),
        '/calendar/new?day=2026-09-11');
    expect(AppRoutes.fromPath('/notes/item/abc'), AppRoutes.notes);
    expect(AppRoutes.indexOfPath('/notes/item/x'), 3);
    expect(AppRoutes.notePath('x'), '/notes/item/x');
    expect(AppRoutes.noteEditPath('x'), '/notes/item/x/edit');
  });

  test('settings is an overlay path, not a tab', () {
    expect(AppRoutes.settings.path, '/settings');
    expect(AppRoutes.primary.contains(AppRoutes.settings), isFalse);
  });

  test('profile is a primary tab; its nested screens stay on it', () {
    expect(AppRoutes.profile.path, '/profile');
    expect(AppRoutes.profileAssets.path, '/profile/assets');
    expect(AppRoutes.primary.contains(AppRoutes.profile), isTrue);
    expect(AppRoutes.fromPath('/profile'), AppRoutes.profile);
    expect(AppRoutes.fromPath('/profile/assets'), AppRoutes.profile);
    expect(AppRoutes.indexOfPath('/profile'), 4);
  });
}
