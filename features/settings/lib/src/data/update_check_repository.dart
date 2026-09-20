import 'package:core/core.dart'
    show
        StoreVersionManifest,
        parseStoreVersionManifest,
        versionManifestUrls;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final updateCheckRepositoryProvider = Provider<UpdateCheckRepository>(
  (ref) => UpdateCheckRepository(client: http.Client()),
);

final class UpdateCheckRepository {
  UpdateCheckRepository({required http.Client client}) : _client = client;

  final http.Client _client;

  static const _headers = {
    'User-Agent': 'BedeBestan-UpdateCheck',
    'Accept': 'application/json',
  };

  Future<StoreVersionManifest?> fetchLatestManifest({
    Duration timeout = const Duration(seconds: 12),
  }) async {
    for (final url in versionManifestUrls()) {
      final manifest = await _fetchOne(url, timeout: timeout);
      if (manifest != null) return manifest;
    }
    return null;
  }

  Future<StoreVersionManifest?> _fetchOne(
    String url, {
    required Duration timeout,
  }) async {
    try {
      final response = await _client
          .get(Uri.parse(url), headers: _headers)
          .timeout(timeout);
      if (response.statusCode != 200) return null;
      return parseStoreVersionManifest(response.body);
    } catch (_) {
      return null;
    }
  }
}
