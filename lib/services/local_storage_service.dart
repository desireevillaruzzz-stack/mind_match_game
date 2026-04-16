import 'package:hive/hive.dart';

import '../models/app_settings.dart';
import '../models/game_progress.dart';
import '../models/player_profile.dart';
import '../models/score_record.dart';

class LocalStorageService {
  static const String playerBoxName = 'playerBox';
  static const String settingsBoxName = 'settingsBox';
  static const String progressBoxName = 'progressBox';
  static const String scoreBoxName = 'scoreBox';

  static const String playerKey = 'playerProfile';
  static const String settingsKey = 'appSettings';
  static const String progressKey = 'gameProgress';
  static const String scoreHistoryKey = 'scoreHistory';
  static const String bestScoreKey = 'bestScore';

  static Future<void> init() async {
    await Hive.openBox(playerBoxName);
    await Hive.openBox(settingsBoxName);
    await Hive.openBox(progressBoxName);
    await Hive.openBox(scoreBoxName);
  }

  Box get _playerBox => Hive.box(playerBoxName);
  Box get _settingsBox => Hive.box(settingsBoxName);
  Box get _progressBox => Hive.box(progressBoxName);
  Box get _scoreBox => Hive.box(scoreBoxName);

  String _generatePlayerId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'player_$timestamp';
  }

  Future<PlayerProfile> ensurePlayerProfile() async {
    final data = _playerBox.get(playerKey);

    if (data != null) {
      return PlayerProfile.fromMap(Map<dynamic, dynamic>.from(data));
    }

    final newPlayer = PlayerProfile(
      playerId: _generatePlayerId(),
      username: 'Guest',
      avatar: '',
      createdAt: DateTime.now().toIso8601String(),
    );

    await savePlayerProfile(newPlayer);
    return newPlayer;
  }

  Future<void> savePlayerProfile(PlayerProfile profile) async {
    await _playerBox.put(playerKey, profile.toMap());
  }

  PlayerProfile getPlayerProfile() {
    final data = _playerBox.get(playerKey);

    if (data == null) {
      return PlayerProfile(
        playerId: '',
        username: 'Guest',
        avatar: '',
        createdAt: '',
      );
    }

    return PlayerProfile.fromMap(Map<dynamic, dynamic>.from(data));
  }

  Future<void> saveAppSettings(AppSettings settings) async {
    await _settingsBox.put(settingsKey, settings.toMap());
  }

  AppSettings getAppSettings() {
    final data = _settingsBox.get(settingsKey);

    if (data == null) {
      return const AppSettings(
        musicOn: true,
        soundOn: true,
        vibrationOn: true,
        selectedDifficulty: 'medium',
      );
    }

    return AppSettings.fromMap(Map<dynamic, dynamic>.from(data));
  }

  Future<void> saveGameProgress(GameProgress progress) async {
    await _progressBox.put(progressKey, progress.toMap());
  }

  GameProgress getGameProgress() {
    final data = _progressBox.get(progressKey);

    if (data == null) {
      return GameProgress(
        currentLevel: 1,
        unlockedLevels: const [1],
        lives: 3,
        lastPlayedCategory: '',
        lastPlayedAt: DateTime.now().toIso8601String(),
      );
    }

    return GameProgress.fromMap(Map<dynamic, dynamic>.from(data));
  }

  Future<void> addScoreRecord(ScoreRecord score) async {
    final raw = _scoreBox.get(scoreHistoryKey, defaultValue: <dynamic>[]);
    final list = List<Map<String, dynamic>>.from(
      (raw as List).map((item) => Map<String, dynamic>.from(item)),
    );

    list.add(score.toMap());
    await _scoreBox.put(scoreHistoryKey, list);

    final currentBest = getBestScore();
    if (score.score > currentBest) {
      await _scoreBox.put(bestScoreKey, score.score);
    }
  }

  List<ScoreRecord> getScoreHistory() {
    final raw = _scoreBox.get(scoreHistoryKey, defaultValue: <dynamic>[]);
    final list = List<Map<String, dynamic>>.from(
      (raw as List).map((item) => Map<String, dynamic>.from(item)),
    );

    return list
        .map((item) => ScoreRecord.fromMap(item))
        .toList()
        .reversed
        .toList();
  }

  int getBestScore() {
    return _scoreBox.get(bestScoreKey, defaultValue: 0) as int;
  }

  Future<void> clearAllData() async {
    await _playerBox.clear();
    await _settingsBox.clear();
    await _progressBox.clear();
    await _scoreBox.clear();
  }
}
