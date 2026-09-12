import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart' show KitError;

void main() {
  testWidgets('KitError retry fires', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: KitError(
            message: 'failed',
            retryLabel: 'Retry',
            onRetry: () => taps++,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('failed'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pump();
    expect(taps, 1);
  });
}
