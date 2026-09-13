import 'dart:io';
import 'dart:ui' as ui;

import 'package:core/core.dart'
    show
        AppSettingsKeys,
        AppStorage,
        appStorageProvider,
        initialAppSettingsProvider,
        loadAppSettings,
        sharedPreferencesProvider;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db/local_db.dart' show appDatabaseProvider, seedDemoData;
import 'package:local_db/memory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translations/translations.dart'
    show TranslationProvider, useAppDefaultLocale;

import 'package:bedeh_bestan/src/app.dart';

/// Phone viewport for store listings: 1080×2400 @ 3.0 dpr → 360×800 logical.
/// Width stays under the 720 mobile breakpoint so gutters match a phone,
/// not the tablet/web layout of 1080×1920 @ 1.0 dpr.
const _phonePhysical = Size(1080, 2400);
const _phoneDpr = 3.0;

const _shots = <_Shot>[
  _Shot(file: '01-home', waitFor: 'این ماه'),
  _Shot(
    file: '02-money',
    icon: Icons.account_balance_wallet_outlined,
    waitFor: 'قسط وام کالا',
  ),
  _Shot(
    file: '03-calendar',
    icon: Icons.calendar_month_outlined,
    waitFor: 'شهریور',
  ),
  _Shot(
    file: '04-notes',
    icon: Icons.sticky_note_2_outlined,
    waitFor: 'شبا بانک ملی',
  ),
];

class _Shot {
  const _Shot({required this.file, this.icon, required this.waitFor});

  final String file;
  final IconData? icon;
  final String waitFor;
}

void main() {
  final enabled = Platform.environment['STORE_SCREENSHOTS'] == '1';

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('write store screenshots (${mode.name})', (tester) async {
      await tester.runAsync(_loadFonts);
      tester.view.physicalSize = _phonePhysical;
      tester.view.devicePixelRatio = _phoneDpr;
      tester.platformDispatcher.platformBrightnessTestValue =
          mode == ThemeMode.dark ? Brightness.dark : Brightness.light;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      SharedPreferences.setMockInitialValues(<String, Object>{
        AppSettingsKeys.themeMode: mode.name,
      });
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

      final suffix = mode.name;
      for (final shot in _shots) {
        if (shot.icon != null) {
          await tester.tap(find.byIcon(shot.icon!));
          await _settle(tester);
        }
        await _waitForText(tester, shot.waitFor);
        await _saveShot(tester, dest, '${shot.file}-$suffix.png');
      }

      await database.close();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 50));

      expect(File('${dest.path}/01-home-$suffix.png').existsSync(), isTrue);
      expect(File('${dest.path}/04-notes-$suffix.png').existsSync(), isTrue);
    }, skip: !enabled, tags: ['store']);
  }
}

Future<void> _saveShot(
  WidgetTester tester,
  Directory dest,
  String filename,
) async {
  await tester.runAsync(() async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const Key('store-shot')),
    );
    final image = await boundary.toImage(pixelRatio: _phoneDpr);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) {
      fail('failed to encode $filename');
    }
    File('${dest.path}/$filename').writeAsBytesSync(bytes.buffer.asUint8List());
  });
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

var _fontsLoaded = false;

Future<void> _loadFonts() async {
  if (_fontsLoaded) return;

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
  _fontsLoaded = true;
}

Future<ByteData> _bytes(String path) async {
  final file = File(path);
  final bytes = await file.readAsBytes();
  return ByteData.sublistView(Uint8List.fromList(bytes));
}
