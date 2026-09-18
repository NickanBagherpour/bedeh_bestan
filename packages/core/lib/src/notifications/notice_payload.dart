import 'dart:convert';

/// Encodes a tap/action payload. Calendar notices stay a plain route so older
/// scheduled ids keep working; money notices include [moneyItemId] for shade
/// actions.
String encodeNoticePayload({
  required String route,
  String? moneyItemId,
}) {
  if (moneyItemId == null || moneyItemId.isEmpty) return route;
  return jsonEncode({
    'route': route,
    'moneyItemId': moneyItemId,
  });
}

({String route, String? moneyItemId}) decodeNoticePayload(String raw) {
  final trimmed = raw.trim();
  if (trimmed.startsWith('{')) {
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map) {
        final route = '${decoded['route'] ?? ''}';
        final itemId = '${decoded['moneyItemId'] ?? ''}';
        return (
          route: route.isEmpty ? trimmed : route,
          moneyItemId: itemId.isEmpty ? null : itemId,
        );
      }
    } catch (_) {}
  }
  return (
    route: trimmed,
    moneyItemId: _moneyItemIdFromRoute(trimmed),
  );
}

String? _moneyItemIdFromRoute(String route) {
  const prefix = '/money/item/';
  if (!route.startsWith(prefix)) return null;
  final id = route.substring(prefix.length).split('/').first.trim();
  return id.isEmpty ? null : id;
}
