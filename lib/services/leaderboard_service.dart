import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/leaderboard_entry.dart';

class LeaderboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _leaderboardCollection =>
      _firestore.collection('leaderboard');

  Future<void> uploadBestScore({
    required String playerId,
    required String username,
    required int highScore,
    required String difficulty,
  }) async {
    final docRef = _leaderboardCollection.doc(playerId);

    final currentDoc = await docRef.get();

    if (currentDoc.exists) {
      final currentData = currentDoc.data()!;
      final currentHighScore = currentData['highScore'] ?? 0;

      if (highScore <= currentHighScore) {
        return;
      }
    }

    final entry = LeaderboardEntry(
      playerId: playerId,
      username: username,
      highScore: highScore,
      difficulty: difficulty,
      updatedAt: DateTime.now().toIso8601String(),
    );

    await docRef.set(entry.toMap());
  }

  Stream<List<LeaderboardEntry>> getTopScores() {
    return _leaderboardCollection
        .orderBy('highScore', descending: true)
        .limit(20)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => LeaderboardEntry.fromMap(doc.data()))
              .toList(),
        );
  }
}
