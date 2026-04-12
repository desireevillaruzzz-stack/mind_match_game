import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz_question.dart';
import '../state/quiz_provider.dart';

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

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
            'Select Difficulty',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Logo
                Image.asset(
                  'assets/images/LOGO.png',
                  height: 350,
                  width: 350,
                  fit: BoxFit.contain,
                ),
                // Buttons Column
                Column(
                  children: [
                    _DiffButton(
                      text: 'EASY',
                      color: Colors.green,
                      fontSize: 26,
                      onPressed: () {
                        Provider.of<QuizProvider>(
                          context,
                          listen: false,
                        ).startNewQuiz(
                          questionCount: 5,
                          difficulty: QuizDifficulty.easy,
                        );
                        Navigator.pushNamed(context, '/quiz');
                      },
                    ),
                    const SizedBox(height: 16),
                    _DiffButton(
                      text: 'MEDIUM',
                      color: Colors.orange,
                      fontSize: 26,
                      onPressed: () {
                        Provider.of<QuizProvider>(
                          context,
                          listen: false,
                        ).startNewQuiz(
                          questionCount: 5,
                          difficulty: QuizDifficulty.medium,
                        );
                        Navigator.pushNamed(context, '/quiz');
                      },
                    ),
                    const SizedBox(height: 16),
                    _DiffButton(
                      text: 'HARD',
                      color: Colors.red,
                      fontSize: 26,
                      onPressed: () {
                        Provider.of<QuizProvider>(
                          context,
                          listen: false,
                        ).startNewQuiz(
                          questionCount: 5,
                          difficulty: QuizDifficulty.hard,
                        );
                        Navigator.pushNamed(context, '/quiz');
                      },
                    ),
                  ],
                ),
                // Empty space filler
                const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DiffButton extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final VoidCallback onPressed;

  const _DiffButton({
    required this.text,
    required this.color,
    required this.fontSize,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.white, width: 3),
          ),
          shadowColor: Colors.black45,
          elevation: 10,
          textStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
