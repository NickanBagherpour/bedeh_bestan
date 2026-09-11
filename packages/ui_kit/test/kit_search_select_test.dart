import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart' show KitSearchSelect;

void main() {
  testWidgets('KitSearchSelect filters and picks', (tester) async {
    String? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return KitSearchSelect<String>(
                key: const Key('party-select'),
                label: 'Party',
                searchHint: 'Search',
                emptyLabel: 'None match',
                items: const ['Ali', 'Bank Melli', 'Shop'],
                value: selected,
                labelOf: (item) => item,
                onSelected: (value) => setState(() => selected = value),
              );
            },
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('party-select')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Ali'), findsOneWidget);
    expect(find.text('Bank Melli'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'mel');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Ali'), findsNothing);
    expect(find.text('Bank Melli'), findsOneWidget);

    await tester.tap(find.text('Bank Melli'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(selected, 'Bank Melli');
    expect(find.text('Bank Melli'), findsOneWidget);
  });
}
