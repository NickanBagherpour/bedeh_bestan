import 'dart:convert';

/// Cafe Bazaar application id (Android).
const bazaarApplicationId = 'com.nickapp.bedebestan';

/// Android [MethodChannel] implemented in `MainActivity` (Bazaar update service).
const bazaarUpdateMethodChannel = 'com.nickapp.bedebestan/bazaar_update';

/// Optional override at build time:
/// `--dart-define=VERSION_MANIFEST_URL=https://…/version.json`
const versionManifestUrlOverride = String.fromEnvironment(
  'VERSION_MANIFEST_URL',
  defaultValue: '',
);

/// Public manifest — bump [store/version.json] on each store release and push
/// to the default branch (`develop`). Private repos need [versionManifestUrlOverride]
/// or rely on Bazaar update check on Android.
const versionManifestUrlDevelop =
    'https://raw.githubusercontent.com/NickanBagherpour/bedeh_bestan/develop/store/version.json';

const versionManifestUrlMaster =
    'https://raw.githubusercontent.com/NickanBagherpour/bedeh_bestan/master/store/version.json';

/// Tried in order until one returns a valid manifest.
List<String> versionManifestUrls() {
  final urls = <String>[
    if (versionManifestUrlOverride.isNotEmpty) versionManifestUrlOverride,
    versionManifestUrlDevelop,
    versionManifestUrlMaster,
  ];
  return urls;
}

final Uri bazaarWebListingUri = Uri.parse(
  'https://cafebazaar.ir/app/$bazaarApplicationId',
);

final Uri bazaarAppDetailsUri = Uri.parse(
  'bazaar://details?id=$bazaarApplicationId',
);

enum UpdateCheckOutcome { upToDate, updateAvailable, checkFailed }

final class StoreVersionManifest {
  const StoreVersionManifest({
    required this.latestVersion,
    required this.latestBuild,
  });

  final String latestVersion;
  final int latestBuild;
}

bool isUpdateAvailable({
  required int installedBuild,
  required int latestBuild,
}) {
  return latestBuild > installedBuild;
}

StoreVersionManifest? parseStoreVersionManifest(String body) {
  try {
    final decoded = jsonDecode(body);
    if (decoded is! Map) return null;
    final version = '${decoded['latestVersion'] ?? ''}'.trim();
    final buildRaw = decoded['latestBuild'];
    final build = switch (buildRaw) {
      int v => v,
      num v => v.toInt(),
      String v => int.tryParse(v),
      _ => null,
    };
    if (version.isEmpty || build == null || build < 1) return null;
    return StoreVersionManifest(latestVersion: version, latestBuild: build);
  } catch (_) {
    return null;
  }
}
