class ScoreRecord {
  final int score;
  final String difficulty;
  final int correctAnswers;
  final int wrongAnswers;
  final String playedAt;

  const ScoreRecord({
    required this.score,
    required this.difficulty,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.playedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'difficulty': difficulty,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'playedAt': playedAt,
    };
  }

  factory ScoreRecord.fromMap(Map<dynamic, dynamic> map) {
    return ScoreRecord(
      score: map['score'] ?? 0,
      difficulty: map['difficulty']?.toString() ?? 'medium',
      correctAnswers: map['correctAnswers'] ?? 0,
      wrongAnswers: map['wrongAnswers'] ?? 0,
      playedAt: map['playedAt']?.toString() ?? '',
    );
  }
}
