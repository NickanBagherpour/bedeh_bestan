import 'package:core/core.dart' show AppRoutes, overlayAppBar;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:translations/translations.dart' show Translations;
import 'package:ui_kit/ui_kit.dart' show AppHaptics, AppSpacing;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
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
          ListTile(
            leading: const Icon(Icons.person_outline_rounded),
            title: Text(t.profile.accountSoon),
            subtitle: Text(t.profile.accountSoonHint),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline_rounded),
            title: Text(t.profile.privacyLock),
            subtitle: Text(t.profile.privacyLockHint),
          ),
          const SizedBox(height: AppSpacing.lg),
          FutureBuilder<PackageInfo?>(
            future: _packageInfo(),
            builder: (context, snapshot) {
              final version = snapshot.data?.version;
              if (version == null || version.isEmpty) {
                return const SizedBox.shrink();
              }
              return Text(
                t.profile.version(version: version),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Future<PackageInfo?> _packageInfo() async {
  try {
    return await PackageInfo.fromPlatform();
  } catch (_) {
    return null;
  }
}
