import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/leaderboard_entry.dart';

class LeaderboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _leaderboardCollection =>
      _firestore.collection('leaderboard');

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  Future<void> uploadBestScore({
    required String username,
    required int highScore,
    required String difficulty,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No logged in user. Please login first.');
    }

    final playerId = user.uid;
    final docRef = _leaderboardCollection.doc(playerId);

    final currentDoc = await docRef.get();

    if (currentDoc.exists) {
      final currentData = currentDoc.data();
      final currentHighScore = currentData?['highScore'] ?? 0;

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

    await docRef.set(entry.toMap(), SetOptions(merge: true));

    await _usersCollection.doc(playerId).set({
      'uid': playerId,
      'username': username,
      'email': user.email ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
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

  Future<String> getCurrentUsername() async {
    final user = _auth.currentUser;

    if (user == null) {
      return 'Guest';
    }

    final doc = await _usersCollection.doc(user.uid).get();

    if (doc.exists) {
      final data = doc.data();
      return data?['username']?.toString() ?? 'Player';
    }

    return user.displayName ?? 'Player';
  }
}
