import 'package:audioplayers/audioplayers.dart';

import 'local_storage_service.dart';

class AudioService {
  final AudioPlayer _bgPlayer = AudioPlayer();
  bool _isInitialized = false;
  bool _musicEnabled = true;

  Future<void> init(LocalStorageService storage) async {
    if (_isInitialized) return;

    final settings = storage.getAppSettings();
    _musicEnabled = settings.musicOn;

    await _bgPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgPlayer.setVolume(0.6);

    if (_musicEnabled) {
      await playBackgroundMusic();
    }

    _isInitialized = true;
  }

  Future<void> playBackgroundMusic() async {
    if (!_musicEnabled) return;

    await _bgPlayer.stop();
    await _bgPlayer.play(AssetSource('audio/bg_music.mp3'));
  }

  Future<void> stopBackgroundMusic() async {
    await _bgPlayer.stop();
  }

  Future<void> pauseBackgroundMusic() async {
    await _bgPlayer.pause();
  }

  Future<void> resumeBackgroundMusic() async {
    if (_musicEnabled) {
      await _bgPlayer.resume();
    }
  }

  Future<void> updateMusicSetting(bool enabled) async {
    _musicEnabled = enabled;

    if (_musicEnabled) {
      await playBackgroundMusic();
    } else {
      await stopBackgroundMusic();
    }
  }

  Future<void> dispose() async {
    await _bgPlayer.dispose();
  }
}
