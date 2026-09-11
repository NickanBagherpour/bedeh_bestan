import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

/// Calm haptic helpers. No-ops on web (no tactile hardware).
abstract final class AppHaptics {
  static Future<void> selection() => _run(HapticFeedback.selectionClick);

  static Future<void> light() => _run(HapticFeedback.lightImpact);

  static Future<void> confirm() => _run(HapticFeedback.mediumImpact);

  static Future<void> warn() => _run(HapticFeedback.heavyImpact);

  static Future<void> _run(Future<void> Function() action) async {
    if (kIsWeb) return;
    try {
      await action();
    } catch (_) {}
  }
}
