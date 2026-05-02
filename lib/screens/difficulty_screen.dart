import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_settings.dart';
import '../models/quiz_question.dart';
import '../services/audio_service.dart';
import '../services/local_storage_service.dart';
import '../state/quiz_provider.dart';

class DifficultyScreen extends StatefulWidget {
  const DifficultyScreen({super.key});

  @override
  State<DifficultyScreen> createState() => _DifficultyScreenState();
}

class _DifficultyScreenState extends State<DifficultyScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context
        .read<AudioService>()
        .ensureBackgroundMusicPlaying(forceRestart: true);
  }

  Future<void> _startQuiz({
    required BuildContext context,
    required String difficultyName,
    required QuizDifficulty difficultyEnum,
    required int questionCount,
    bool survivalMode = false,
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
          questionCount: questionCount,
          difficulty: difficultyEnum,
          survivalMode: survivalMode,
        );

    Navigator.pushNamed(context, '/quiz');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/difficulty.bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E88E5).withOpacity(0.75),
              Color(0xFF42A5F5).withOpacity(0.6),
              Color(0xFF90CAF9).withOpacity(0.45),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('SELECT DIFFICULTY'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/LOGO.png',
                  height: 300,
                  width: 300,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                _btn(context, "EASY (10)", Colors.green, () {
                  _startQuiz(
                    context: context,
                    difficultyName: 'easy',
                    difficultyEnum: QuizDifficulty.easy,
                    questionCount: 10,
                  );
                }),
                _btn(context, "MEDIUM (15)", Colors.orange, () {
                  _startQuiz(
                    context: context,
                    difficultyName: 'medium',
                    difficultyEnum: QuizDifficulty.medium,
                    questionCount: 15,
                  );
                }),
                _btn(context, "HARD (SURVIVAL)", Colors.red, () {
                  _startQuiz(
                    context: context,
                    difficultyName: 'hard',
                    difficultyEnum: QuizDifficulty.hard,
                    questionCount: 1,
                    survivalMode: true,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _btn(
      BuildContext context, String text, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: 260,
        height: 55,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.18),
            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor: Colors.black45,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
              side: BorderSide(
                color: Colors.white.withOpacity(0.6),
                width: 1.5,
              ),
            ),
          ),
          child: Text(text),
        ),
      ),
    );
  }
}
