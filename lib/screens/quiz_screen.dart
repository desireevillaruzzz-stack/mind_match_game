import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/audio_service.dart';
import '../services/haptic_service.dart';
import '../state/quiz_provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _answerLocked = false;

  Future<void> _handleAnswer(String choice) async {
    if (_answerLocked) return;

    setState(() {
      _answerLocked = true;
    });

    final quizProvider = context.read<QuizProvider>();
    final audioService = context.read<AudioService>();
    final hapticService = context.read<HapticService>();

    final question = quizProvider.currentQuestion;
    if (question == null) {
      if (mounted) {
        setState(() {
          _answerLocked = false;
        });
      }
      return;
    }

    final isCorrect = choice == question.correctAnswer;

    await hapticService.lightTap();
    await audioService.playClickSound();

    if (isCorrect) {
      await hapticService.correct();
      await audioService.playCorrectSound();
    } else {
      await hapticService.wrong();
      await audioService.playWrongSound();
    }

    quizProvider.answerQuestion(choice);

    if (mounted) {
      setState(() {
        _answerLocked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();

    if (!quizProvider.hasQuestions) {
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              child: const Text('Back to Home'),
            ),
          ),
        ),
      );
    }

    if (quizProvider.isQuizFinished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/gameover');
      });
      return const SizedBox.shrink();
    }

    final currentQuestion = quizProvider.currentQuestion;
    if (currentQuestion == null) {
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
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    final difficultyName = quizProvider.selectedDifficulty
        .toString()
        .split('.')
        .last
        .toUpperCase();

    final difficultyColor = switch (quizProvider.selectedDifficulty) {
      var d when d.toString().contains('easy') => Colors.greenAccent,
      var d when d.toString().contains('medium') => Colors.orangeAccent,
      _ => Colors.redAccent,
    };

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
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Difficulty: $difficultyName',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: difficultyColor,
              letterSpacing: 0.8,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        quizProvider.survivalMode
                            ? 'SCORE ${quizProvider.score.toString().padLeft(2, '0')}'
                            : 'Q${(quizProvider.currentQuestionIndex + 1).toString().padLeft(2, '0')}/${quizProvider.totalQuestions.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        'Category: ${currentQuestion.category}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.help_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 28,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: currentQuestion.categoryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white30,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      currentQuestion.question,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: currentQuestion.choices.length,
                  itemBuilder: (context, index) {
                    final choice = currentQuestion.choices[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00BCD4),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            shadowColor: Colors.black45,
                            elevation: 8,
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          onPressed: _answerLocked
                              ? null
                              : () => _handleAnswer(choice),
                          child: Text(choice),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
