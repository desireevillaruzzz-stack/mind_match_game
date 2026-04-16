import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_settings.dart';
import '../models/quiz_question.dart';
import '../services/local_storage_service.dart';
import '../state/quiz_provider.dart';

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

  Future<void> _startQuiz({
    required BuildContext context,
    required String difficultyName,
    required QuizDifficulty difficultyEnum,
  }) async {
    final storage = context.read<LocalStorageService>();
    final currentSettings = storage.getAppSettings();

    await storage.saveAppSettings(
      AppSettings(
        musicOn: currentSettings.musicOn,
        soundOn: currentSettings.soundOn,
        vibrationOn: currentSettings.vibrationOn,
        selectedDifficulty: difficultyName,
      ),
    );

    if (!context.mounted) return;

    context.read<QuizProvider>().startNewQuiz(
      questionCount: 5,
      difficulty: difficultyEnum,
    );

    Navigator.pushNamed(context, '/quiz');
  }

  @override
  Widget build(BuildContext context) {
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
            'SELECT DIFFICULTY',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
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
                  height: 250,
                  width: 250,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                _DifficultyButton(
                  text: 'EASY',
                  color: const Color(0xFF2E7D32),
                  onPressed: () => _startQuiz(
                    context: context,
                    difficultyName: 'easy',
                    difficultyEnum: QuizDifficulty.easy,
                  ),
                ),
                const SizedBox(height: 18),
                _DifficultyButton(
                  text: 'MEDIUM',
                  color: const Color(0xFFEF6C00),
                  onPressed: () => _startQuiz(
                    context: context,
                    difficultyName: 'medium',
                    difficultyEnum: QuizDifficulty.medium,
                  ),
                ),
                const SizedBox(height: 18),
                _DifficultyButton(
                  text: 'HARD',
                  color: const Color(0xFFC62828),
                  onPressed: () => _startQuiz(
                    context: context,
                    difficultyName: 'hard',
                    difficultyEnum: QuizDifficulty.hard,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _DifficultyButton({
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
