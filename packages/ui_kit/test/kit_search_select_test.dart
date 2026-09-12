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

  testWidgets('empty state shows label + placeholder without overlap', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: KitSearchSelect<String>(
            label: 'Party',
            searchHint: 'Search',
            noneLabel: 'Choose a party',
            items: ['Ali', 'Bank Melli'],
            value: null,
            labelOf: _identity,
            onSelected: _noop,
          ),
        ),
      ),
    );
    await tester.pump();

    // Label floats and the placeholder is a distinct hint: both render, and
    // their rects must not overlap.
    final labelRect = tester.getRect(find.text('Party'));
    final hintRect = tester.getRect(find.text('Choose a party'));
    expect(labelRect.overlaps(hintRect), isFalse);
  });

  testWidgets('empty state has no overlap in RTL', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: KitSearchSelect<String>(
              label: 'طرف',
              searchHint: 'جستجو',
              noneLabel: 'یک طرف انتخاب کنید',
              items: ['علی', 'بانک ملی'],
              value: null,
              labelOf: _identity,
              onSelected: _noop,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final labelRect = tester.getRect(find.text('طرف'));
    final hintRect = tester.getRect(find.text('یک طرف انتخاب کنید'));
    expect(labelRect.overlaps(hintRect), isFalse);
  });

  testWidgets('selected state shows label and value', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: KitSearchSelect<String>(
            label: 'Party',
            searchHint: 'Search',
            noneLabel: 'Choose a party',
            items: ['Ali', 'Bank Melli'],
            value: 'Bank Melli',
            labelOf: _identity,
            onSelected: _noop,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Party'), findsOneWidget);
    expect(find.text('Bank Melli'), findsOneWidget);
    // Label floats above the value; the two must not collide.
    final labelRect = tester.getRect(find.text('Party'));
    final valueRect = tester.getRect(find.text('Bank Melli'));
    expect(labelRect.overlaps(valueRect), isFalse);
  });
}

String _identity(String value) => value;

void _noop(String? value) {}
