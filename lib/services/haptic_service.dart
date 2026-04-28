import 'package:vibration/vibration.dart';

import 'local_storage_service.dart';

class HapticService {
  bool _vibrationEnabled = true;

  bool get vibrationEnabled => _vibrationEnabled;

  Future<void> init(LocalStorageService storage) async {
    final settings = storage.getAppSettings();
    _vibrationEnabled = settings.vibrationOn;
  }

  Future<void> updateVibrationSetting(bool enabled) async {
    _vibrationEnabled = enabled;
  }

  Future<void> _vibrate(int duration) async {
    if (!_vibrationEnabled) return;

    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator ?? false) {
        await Vibration.vibrate(
          duration: duration,
          amplitude: 255, // 🔥 force max strength
        );
      }
    } catch (e) {
      // ignore errors
    }
  }

  Future<void> lightTap() async {
    await _vibrate(40);
  }

  Future<void> correct() async {
    // double pulse
    await Vibration.vibrate(pattern: [0, 60, 40, 80]);
  }

  Future<void> wrong() async {
    // strong long vibration
    await _vibrate(200);
  }
}
