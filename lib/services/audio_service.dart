import 'package:audioplayers/audioplayers.dart';

import 'local_storage_service.dart';

class AudioService {
  final AudioPlayer _bgPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isInitialized = false;
  bool _musicEnabled = true;
  bool _soundEnabled = true;
  bool _isBgPlaying = false;

  bool get musicEnabled => _musicEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get isBgPlaying => _isBgPlaying;

  Future<void> init(LocalStorageService storage) async {
    if (_isInitialized) return;

    final settings = storage.getAppSettings();
    _musicEnabled = settings.musicOn;
    _soundEnabled = settings.soundOn;

    try {
      await _bgPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgPlayer.setVolume(0.6);

      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      await _sfxPlayer.setVolume(1.0);

      _bgPlayer.onPlayerStateChanged.listen((state) {
        _isBgPlaying = state == PlayerState.playing;
      });

      if (_musicEnabled) {
        await ensureBackgroundMusicPlaying(forceRestart: true);
      }
    } catch (_) {}

    _isInitialized = true;
  }

  Future<void> ensureBackgroundMusicPlaying({bool forceRestart = false}) async {
    if (!_musicEnabled) return;

    try {
      if (_isBgPlaying && !forceRestart) return;

      if (forceRestart) {
        await _bgPlayer.stop();
      }

      await _bgPlayer.play(AssetSource('audio/bg_music.mp3'));
      _isBgPlaying = true;
    } catch (_) {}
  }

  Future<void> playBackgroundMusic() async {
    await ensureBackgroundMusicPlaying();
  }

  Future<void> stopBackgroundMusic() async {
    try {
      await _bgPlayer.stop();
      _isBgPlaying = false;
    } catch (_) {}
  }

  Future<void> pauseBackgroundMusic() async {
    try {
      await _bgPlayer.pause();
      _isBgPlaying = false;
    } catch (_) {}
  }

  Future<void> resumeBackgroundMusic() async {
    if (!_musicEnabled) return;

    try {
      if (!_isBgPlaying) {
        await _bgPlayer.resume();
        _isBgPlaying = true;
      }
    } catch (_) {
      await ensureBackgroundMusicPlaying(forceRestart: true);
    }
  }

  Future<void> updateMusicSetting(bool enabled) async {
    _musicEnabled = enabled;

    if (_musicEnabled) {
      await ensureBackgroundMusicPlaying(forceRestart: !_isBgPlaying);
    } else {
      await stopBackgroundMusic();
    }
  }

  Future<void> updateSoundSetting(bool enabled) async {
    _soundEnabled = enabled;

    if (_musicEnabled) {
      await ensureBackgroundMusicPlaying();
    }
  }

  Future<void> playClickSound() async {
    await _playSfx('audio/click.mp3');
  }

  Future<void> playCorrectSound() async {
    await _playSfx('audio/correct.mp3');
  }

  Future<void> playWrongSound() async {
    await _playSfx('audio/wrong.mp3');
  }

  Future<void> _playSfx(String assetPath) async {
    if (!_soundEnabled) return;

    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource(assetPath));
    } catch (_) {}
  }

  Future<void> dispose() async {
    try {
      await _bgPlayer.dispose();
      await _sfxPlayer.dispose();
    } catch (_) {}
  }
}
