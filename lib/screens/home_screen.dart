import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/quiz_question.dart';
import '../services/audio_service.dart';
import '../services/auth_service.dart';
import '../services/local_storage_service.dart';
import '../state/quiz_provider.dart';
import '../screens/settings_screen.dart';

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
        return 1;
      default:
        return 10;
    }
  }

  bool _isSurvivalMode(String value) {
    return value.toLowerCase() == 'hard';
  }

  void _openSettings() {
    Navigator.pushNamed(context, '/settings');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context
        .read<AudioService>()
        .ensureBackgroundMusicPlaying(forceRestart: true);
  }

  Future<void> _logout() async {
    await context.read<AuthService>().logout();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  Future<void> _openProfile() async {
    await Navigator.pushNamed(context, '/profile');
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final storage = context.read<LocalStorageService>();
    final bestScore = storage.getBestScore();
    final selectedDifficulty = storage.getAppSettings().selectedDifficulty;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/skysakura.bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1E88E5).withOpacity(0.75),
              const Color(0xFF42A5F5).withOpacity(0.6),
              const Color(0xFF90CAF9).withOpacity(0.45),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text(
              'Mind Match Quiz',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// 👤 PROFILE HEADER
                  FutureBuilder<Map<String, dynamic>?>(
                    future: context.read<AuthService>().getCurrentUserProfile(),
                    builder: (context, snapshot) {
                      final data = snapshot.data;
                      final username = data?['username'] ?? 'Player';
                      final avatar = data?['avatar'] ?? '';

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: InkWell(
                          onTap: _openProfile,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: Colors.white,
                                backgroundImage: avatar.isNotEmpty
                                    ? NetworkImage(avatar)
                                    : null,
                                child: avatar.isEmpty
                                    ? const Icon(Icons.person,
                                        size: 35, color: Color(0xFF1E88E5))
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  username,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Icon(Icons.edit, color: Colors.white70),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  ///  LOGO
                  Image.asset(
                    'assets/images/LOGO.png',
                    height: 260,
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
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _MenuButton(
                    text: 'START',
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
                    onPressed: () =>
                        Navigator.pushNamed(context, '/difficulty'),
                  ),

                  const SizedBox(height: 10),

                  _MenuButton(
                    text: 'SCORE HISTORY',
                    onPressed: () => Navigator.pushNamed(context, '/history'),
                  ),

                  const SizedBox(height: 10),

                  _MenuButton(
                    text: 'LEADERBOARD',
                    onPressed: () =>
                        Navigator.pushNamed(context, '/leaderboard'),
                  ),

                  const SizedBox(height: 10),

                  _MenuButton(
                    text: 'SETTINGS',
                    onPressed: _openSettings,
                  ),
                  const SizedBox(height: 10),

                  _MenuButton(
                    text: 'LOG OUT',
                    onPressed: _logout,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 🔘 GLASS BUTTON
class _MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
