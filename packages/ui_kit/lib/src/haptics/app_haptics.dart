import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

/// Calm haptic helpers. No-ops on web (no tactile hardware).
abstract final class AppHaptics {
  static Future<void> selection() async {
    if (kIsWeb) return;
    await HapticFeedback.selectionClick();
  }

  static Future<void> light() async {
    if (kIsWeb) return;
    await HapticFeedback.lightImpact();
  }

  static Future<void> confirm() async {
    if (kIsWeb) return;
    await HapticFeedback.mediumImpact();
  }

  static Future<void> warn() async {
    if (kIsWeb) return;
    await HapticFeedback.heavyImpact();
  }
}
