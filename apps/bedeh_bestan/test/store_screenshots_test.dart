import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart'
    show
        AppStorage,
        appStorageProvider,
        initialAppSettingsProvider,
        loadAppSettings,
        sharedPreferencesProvider;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart' show appDatabaseProvider, seedDemoData;
import 'package:local_db/memory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translations/translations.dart'
    show TranslationProvider, useAppDefaultLocale;

import 'package:bedeh_bestan/src/app.dart';

void main() {
  testWidgets('write store screenshots', (tester) async {
    await tester.runAsync(_loadFonts);
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

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
        child: TranslationProvider(
          child: const RepaintBoundary(
            key: Key('store-shot'),
            child: BedeBestanApp(),
          ),
        ),
      ),
    );
    await _settle(tester);

    final dest = Directory(
      '${Directory.current.path}/../../store/screenshots',
    );
    dest.createSync(recursive: true);

    await _waitForText(tester, 'این ماه');
    await expectLater(
      find.byKey(const Key('store-shot')),
      matchesGoldenFile('../../../store/screenshots/01-home.png'),
    );

    await tester.tap(find.byIcon(Icons.account_balance_wallet_outlined));
    await _settle(tester);
    await _waitForText(tester, 'قسط وام کالا');
    await expectLater(
      find.byKey(const Key('store-shot')),
      matchesGoldenFile('../../../store/screenshots/02-money.png'),
    );

    await tester.tap(find.byIcon(Icons.calendar_month_outlined));
    await _settle(tester);
    await _waitForText(tester, 'شهریور');
    await expectLater(
      find.byKey(const Key('store-shot')),
      matchesGoldenFile('../../../store/screenshots/03-calendar.png'),
    );

    await tester.tap(find.byIcon(Icons.sticky_note_2_outlined));
    await _settle(tester);
    await _waitForText(tester, 'شبا بانک ملی');
    await expectLater(
      find.byKey(const Key('store-shot')),
      matchesGoldenFile('../../../store/screenshots/04-notes.png'),
    );

    await database.close();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));

    expect(File('${dest.path}/01-home.png').existsSync(), isTrue);
    expect(File('${dest.path}/04-notes.png').existsSync(), isTrue);
  }, tags: ['store']);
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
  await tester.pump(const Duration(milliseconds: 500));
}

Future<void> _waitForText(WidgetTester tester, String text) async {
  for (var i = 0; i < 25; i++) {
    if (find.textContaining(text).evaluate().isNotEmpty) {
      await tester.pump(const Duration(milliseconds: 200));
      return;
    }
    await tester.pump(const Duration(milliseconds: 200));
  }
  fail('never found "$text"');
}

Future<void> _loadFonts() async {
  Future<void> family(String name, List<String> assets) async {
    final loader = FontLoader(name);
    for (final asset in assets) {
      loader.addFont(rootBundle.load(asset));
    }
    await loader.load();
  }

  const vazir = [
    'assets/fonts/Vazirmatn-Light.ttf',
    'assets/fonts/Vazirmatn-Regular.ttf',
    'assets/fonts/Vazirmatn-Medium.ttf',
    'assets/fonts/Vazirmatn-SemiBold.ttf',
    'assets/fonts/Vazirmatn-Bold.ttf',
    'assets/fonts/Vazirmatn-ExtraBold.ttf',
  ];
  await family('Vazirmatn', vazir);
  await family('Roboto', vazir);

  final flutterRoot = Platform.environment['FLUTTER_ROOT'] ??
      '/media/nickan/workspace/sdk/flutter';
  final icons = FontLoader('MaterialIcons')
    ..addFont(
      _bytes(
        '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
      ),
    );
  await icons.load();
}

Future<ByteData> _bytes(String path) async {
  final file = File(path);
  final bytes = await file.readAsBytes();
  return ByteData.sublistView(Uint8List.fromList(bytes));
}
