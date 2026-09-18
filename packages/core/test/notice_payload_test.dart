import 'package:core/core.dart'
    show decodeNoticePayload, encodeNoticePayload;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('money payload round-trips item id', () {
    final raw = encodeNoticePayload(
      route: '/money/item/abc',
      moneyItemId: 'abc',
    );
    final decoded = decodeNoticePayload(raw);
    expect(decoded.route, '/money/item/abc');
    expect(decoded.moneyItemId, 'abc');
  });

  test('plain route payload still opens the item', () {
    final decoded = decodeNoticePayload('/money/item/xyz');
    expect(decoded.route, '/money/item/xyz');
    expect(decoded.moneyItemId, 'xyz');
  });
}
