import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/score_record.dart';
import '../services/audio_service.dart';
import '../services/leaderboard_service.dart';
import '../services/local_storage_service.dart';
import '../state/quiz_provider.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  bool _saved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_saved) {
      _saved = true;
      _saveResult();
    }

    context.read<AudioService>().ensureBackgroundMusicPlaying(
          forceRestart: true,
        );
  }

  Future<void> _saveResult() async {
    final quizProvider = context.read<QuizProvider>();
    final storage = context.read<LocalStorageService>();
    final leaderboardService = context.read<LeaderboardService>();

    final settings = storage.getAppSettings();
    await storage.ensurePlayerProfile();

    final totalQuestions = quizProvider.totalQuestions;
    final score = quizProvider.score;
    final wrongAnswers = (totalQuestions - score).clamp(0, totalQuestions);

    await storage.addScoreRecord(
      ScoreRecord(
        score: score,
        difficulty: settings.selectedDifficulty,
        correctAnswers: score,
        wrongAnswers: wrongAnswers,
        playedAt: DateTime.now().toIso8601String(),
      ),
    );

    final profile = storage.getPlayerProfile();

    try {
      await leaderboardService.uploadBestScore(
        username: profile.username,
        highScore: score,
        difficulty: settings.selectedDifficulty,
      );
    } catch (e) {
      debugPrint('Leaderboard upload failed: $e');
    }
  }

  String _getPerformanceMessage(int score, int totalQuestions) {
    if (score >= 30) return '🔥 Legendary run!';
    if (score >= 20) return '🌟 Amazing!';
    if (score >= 10) return '👏 Great job!';
    if (score == totalQuestions && totalQuestions > 0) {
      return 'Perfect Score!';
    }
    return 'Keep Practicing!';
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final storage = context.read<LocalStorageService>();

    final score = quizProvider.score;
    final totalQuestions = quizProvider.totalQuestions;
    final bestScore = storage.getBestScore();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1E88E5),
            Color(0xFF42A5F5),
            Color(0xFF64B5F6),
            Color(0xFF90CAF9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'GAME OVER',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 90,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _getPerformanceMessage(score, totalQuestions),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Your Score',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$score',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Best Offline Score: $bestScore',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 220,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        elevation: 8,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      onPressed: () async {
                        await context
                            .read<AudioService>()
                            .ensureBackgroundMusicPlaying(forceRestart: true);

                        quizProvider.resetQuiz();

                        if (!context.mounted) return;

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      },
                      child: const Text('BACK TO HOME'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
