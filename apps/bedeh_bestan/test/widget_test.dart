import 'package:core/core.dart'
    show
        AppStorage,
        appStorageProvider,
        initialAppSettingsProvider,
        loadAppSettings,
        sharedPreferencesProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart'
    show appDatabaseProvider, seedDemoData;
import 'package:local_db/memory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translations/translations.dart'
    show TranslationProvider, useAppDefaultLocale;

import 'package:bedeh_bestan/src/app.dart';

void main() {
  testWidgets('shell shows the four primary destinations', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = await SharedPreferences.getInstance();
    final storage = AppStorage(preferences: preferences);
    final database = openMemoryDatabase();
    await seedDemoData(database);
    await useAppDefaultLocale();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(preferences),
          appStorageProvider.overrideWithValue(storage),
          initialAppSettingsProvider
              .overrideWithValue(loadAppSettings(storage: storage)),
          appDatabaseProvider.overrideWithValue(database),
        ],
        child: TranslationProvider(child: const BedeBestanApp()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('خانه'), findsWidgets);
    expect(find.text('حساب'), findsOneWidget);
    expect(find.text('تقویم'), findsOneWidget);
    expect(find.text('یادداشت'), findsOneWidget);
    expect(find.textContaining('این ماه'), findsWidgets);
    expect(find.byTooltip('تنظیمات'), findsOneWidget);
    expect(find.byTooltip('پروفایل'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.calendar_month_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('شهریور'), findsWidgets);
    expect(find.text('یادآوری'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.sticky_note_2_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('شبا بانک ملی'), findsOneWidget);

    await tester.tap(find.text('خانه'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.byTooltip('تنظیمات'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.drag(
      find.byType(Scrollable).first,
      const Offset(0, -300),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('گاه‌شماری'), findsWidgets);

    await database.close();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));
  });
}
