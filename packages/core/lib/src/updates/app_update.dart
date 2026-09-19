import 'dart:convert';

/// Cafe Bazaar application id (Android).
const bazaarApplicationId = 'com.nickapp.bedebestan';

/// Public manifest — bump [store/version.json] on each store release.
const versionManifestUrl =
    'https://raw.githubusercontent.com/NickanBagherpour/bedeh_bestan/main/store/version.json';

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
