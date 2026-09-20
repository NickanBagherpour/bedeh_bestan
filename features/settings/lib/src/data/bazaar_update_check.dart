import 'dart:io' show Platform;

import 'package:core/core.dart' show bazaarUpdateMethodChannel;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

/// Cafe Bazaar update service (Android + Bazaar app installed).
/// `true` / `false` = result; `null` = unavailable, try HTTP manifest.
Future<bool?> checkBazaarUpdateAvailable() async {
  if (kIsWeb || !Platform.isAndroid) return null;
  const channel = MethodChannel(bazaarUpdateMethodChannel);
  try {
    final result = await channel.invokeMethod<bool>('isUpdateAvailable');
    return result;
  } catch (_) {
    return null;
  }
}

Future<bool> openBazaarAppPageNative() async {
  if (kIsWeb || !Platform.isAndroid) return false;
  const channel = MethodChannel(bazaarUpdateMethodChannel);
  try {
    final ok = await channel.invokeMethod<bool>('openAppPage');
    return ok ?? false;
  } catch (_) {
    return false;
  }
}
