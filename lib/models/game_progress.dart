class GameProgress {
  final int currentLevel;
  final List<int> unlockedLevels;
  final int lives;
  final String lastPlayedCategory;
  final String lastPlayedAt;

  const GameProgress({
    required this.currentLevel,
    required this.unlockedLevels,
    required this.lives,
    required this.lastPlayedCategory,
    required this.lastPlayedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'currentLevel': currentLevel,
      'unlockedLevels': unlockedLevels,
      'lives': lives,
      'lastPlayedCategory': lastPlayedCategory,
      'lastPlayedAt': lastPlayedAt,
    };
  }

  factory GameProgress.fromMap(Map<dynamic, dynamic> map) {
    return GameProgress(
      currentLevel: map['currentLevel'] ?? 1,
      unlockedLevels: List<int>.from(map['unlockedLevels'] ?? [1]),
      lives: map['lives'] ?? 3,
      lastPlayedCategory: map['lastPlayedCategory']?.toString() ?? '',
      lastPlayedAt: map['lastPlayedAt']?.toString() ?? '',
    );
  }
}
