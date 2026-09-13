import 'package:core/core.dart' show AppRoutes, overlayAppBar;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:translations/translations.dart' show Translations;
import 'package:ui_kit/ui_kit.dart' show AppHaptics, AppSpacing;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      appBar: overlayAppBar(
        context: context,
        title: Text(t.profile.title),
        fallbackPath: AppRoutes.home.path,
        backTooltip: t.app.actions.back,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          ListTile(
            leading: const Icon(Icons.savings_outlined),
            title: Text(t.profile.assets),
            subtitle: Text(t.profile.assetsHint),
            trailing: const Icon(Icons.chevron_left_rounded),
            onTap: () {
              AppHaptics.selection();
              context.push(AppRoutes.profileAssets.path);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(t.settings.title),
            trailing: const Icon(Icons.chevron_left_rounded),
            onTap: () {
              AppHaptics.selection();
              context.push(AppRoutes.settings.path);
            },
          ),
        ],
      ),
    );
  }
}
