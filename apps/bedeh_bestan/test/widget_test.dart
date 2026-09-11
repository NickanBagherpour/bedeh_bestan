import 'package:core/core.dart'
    show
        AppStorage,
        appStorageProvider,
        initialAppSettingsProvider,
        loadAppSettings,
        sharedPreferencesProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translations/translations.dart'
    show TranslationProvider, useAppDefaultLocale;

import 'package:bedeh_bestan/src/app.dart';

void main() {
  testWidgets('shell shows the four primary destinations', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = await SharedPreferences.getInstance();
    final storage = AppStorage(preferences: preferences);
    await useAppDefaultLocale();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(preferences),
          appStorageProvider.overrideWithValue(storage),
          initialAppSettingsProvider
              .overrideWithValue(loadAppSettings(storage: storage)),
        ],
        child: TranslationProvider(child: const BedeBestanApp()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('خانه'), findsWidgets);
    expect(find.text('حساب'), findsOneWidget);
    expect(find.text('تقویم'), findsOneWidget);
    expect(find.text('یادداشت'), findsOneWidget);
  });
}
