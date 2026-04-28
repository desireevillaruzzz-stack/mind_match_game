import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/quiz_question.dart';
import '../services/audio_service.dart';
import '../services/local_storage_service.dart';
import '../state/quiz_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  QuizDifficulty _mapDifficulty(String value) {
    switch (value.toLowerCase()) {
      case 'easy':
        return QuizDifficulty.easy;
      case 'hard':
        return QuizDifficulty.hard;
      case 'medium':
      default:
        return QuizDifficulty.medium;
    }
  }

  int _questionCountForDifficulty(String value) {
    switch (value.toLowerCase()) {
      case 'easy':
        return 10;
      case 'medium':
        return 15;
      case 'hard':
        return 1; // survival
      default:
        return 10;
    }
  }

  bool _isSurvivalMode(String value) {
    return value.toLowerCase() == 'hard';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context
        .read<AudioService>()
        .ensureBackgroundMusicPlaying(forceRestart: true);
  }

  @override
  Widget build(BuildContext context) {
    final storage = context.read<LocalStorageService>();
    final bestScore = storage.getBestScore();
    final selectedDifficulty = storage.getAppSettings().selectedDifficulty;

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
          title: const Text(
            'Mind Match Quiz',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/LOGO.png',
                  height: 350,
                  width: 350,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                Text(
                  'Best Offline Score: $bestScore',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Selected Difficulty: ${selectedDifficulty.toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 14),
                _MenuButton(
                  text: 'START',
                  color: const Color(0xFF0D47A1),
                  onPressed: () {
                    final difficultyEnum = _mapDifficulty(selectedDifficulty);

                    context.read<QuizProvider>().startNewQuiz(
                          questionCount:
                              _questionCountForDifficulty(selectedDifficulty),
                          difficulty: difficultyEnum,
                          survivalMode: _isSurvivalMode(selectedDifficulty),
                        );

                    Navigator.pushNamed(context, '/quiz');
                  },
                ),
                const SizedBox(height: 10),
                _MenuButton(
                  text: 'DIFFICULTY',
                  color: const Color(0xFF00695C),
                  onPressed: () => Navigator.pushNamed(context, '/difficulty'),
                ),
                const SizedBox(height: 18),
                _MenuButton(
                  text: 'SCORE HISTORY',
                  color: const Color(0xFF6A1B9A),
                  onPressed: () => Navigator.pushNamed(context, '/history'),
                ),
                const SizedBox(height: 18),
                _MenuButton(
                  text: 'LEADERBOARD',
                  color: const Color(0xFF8E24AA),
                  onPressed: () => Navigator.pushNamed(context, '/leaderboard'),
                ),
                const SizedBox(height: 18),
                _MenuButton(
                  text: 'SETTINGS',
                  color: const Color(0xFF5E35B1),
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                ),
                const SizedBox(height: 18),
                _MenuButton(
                  text: 'EXIT',
                  color: const Color(0xFFC62828),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 58,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.white, width: 2),
          ),
          shadowColor: Colors.black45,
          elevation: 8,
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
