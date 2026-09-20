import 'package:core/core.dart'
    show isUpdateAvailable, parseStoreVersionManifest;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parseStoreVersionManifest reads version and build', () {
    final manifest = parseStoreVersionManifest('''
      {"latestVersion":"1.0.7","latestBuild":7}
    ''');
    expect(manifest?.latestVersion, '1.0.7');
    expect(manifest?.latestBuild, 7);
  });

  test('isUpdateAvailable compares build numbers', () {
    expect(
      isUpdateAvailable(installedBuild: 6, latestBuild: 7),
      isTrue,
    );
    expect(
      isUpdateAvailable(installedBuild: 6, latestBuild: 6),
      isFalse,
    );
  });
}
