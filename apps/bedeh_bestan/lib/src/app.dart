import 'package:core/core.dart' show appSettingsProvider;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translations/translations.dart' show AppLocaleUtils, t;
import 'package:ui_kit/ui_kit.dart' show AppTheme;

import 'router/app_router.dart';

/// Root of the BedeBestan app. RTL-first Persian, brand theming, local-only.
class BedeBestanApp extends ConsumerWidget {
  const BedeBestanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final router = ref.watch(appRouterProvider);
    final languageCode = settings.locale.languageCode;

    return MaterialApp.router(
      title: t.app.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightFor(languageCode),
      darkTheme: AppTheme.darkFor(languageCode),
      themeMode: settings.themeMode,
      locale: settings.locale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      builder: (context, child) {
        return Directionality(
          textDirection: settings.direction,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
