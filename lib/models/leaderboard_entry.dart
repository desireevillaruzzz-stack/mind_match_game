class LeaderboardEntry {
  final String playerId;
  final String username;
  final int highScore;
  final String difficulty;
  final String updatedAt;

  const LeaderboardEntry({
    required this.playerId,
    required this.username,
    required this.highScore,
    required this.difficulty,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'playerId': playerId,
      'username': username,
      'highScore': highScore,
      'difficulty': difficulty,
      'updatedAt': updatedAt,
    };
  }

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      playerId: map['playerId']?.toString() ?? '',
      username: map['username']?.toString() ?? 'Guest',
      highScore: map['highScore'] ?? 0,
      difficulty: map['difficulty']?.toString() ?? 'medium',
      updatedAt: map['updatedAt']?.toString() ?? '',
    );
  }
}
