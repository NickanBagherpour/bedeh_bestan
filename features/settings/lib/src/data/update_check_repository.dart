import 'package:core/core.dart'
    show StoreVersionManifest, parseStoreVersionManifest, versionManifestUrl;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final updateCheckRepositoryProvider = Provider<UpdateCheckRepository>(
  (ref) => UpdateCheckRepository(client: http.Client()),
);

final class UpdateCheckRepository {
  UpdateCheckRepository({required http.Client client}) : _client = client;

  final http.Client _client;

  Future<StoreVersionManifest?> fetchLatestManifest({
    Duration timeout = const Duration(seconds: 12),
  }) async {
    try {
      final response = await _client
          .get(Uri.parse(versionManifestUrl))
          .timeout(timeout);
      if (response.statusCode != 200) return null;
      return parseStoreVersionManifest(response.body);
    } catch (_) {
      return null;
    }
  }
}
