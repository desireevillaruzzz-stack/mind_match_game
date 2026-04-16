import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'state/quiz_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/difficulty_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/game_over_screen.dart';
import 'screens/score_history_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'services/local_storage_service.dart';
import 'services/leaderboard_service.dart';
import 'services/audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await LocalStorageService.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final localStorageService = LocalStorageService();
  final audioService = AudioService();
  await audioService.init(localStorageService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        Provider<LocalStorageService>.value(value: localStorageService),
        Provider<LeaderboardService>(create: (_) => LeaderboardService()),
        Provider<AudioService>.value(value: audioService),
      ],
      child: const MindMatchQuizApp(),
    ),
  );
}

class MindMatchQuizApp extends StatelessWidget {
  const MindMatchQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mind Match Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF2787C9),
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/difficulty': (context) => const DifficultyScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/gameover': (context) => const GameOverScreen(),
        '/history': (context) => const ScoreHistoryScreen(),
        '/leaderboard': (context) => const LeaderboardScreen(),
      },
    );
  }
}
