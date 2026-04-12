// main.dart cosist of the main entry point of the application and sets up the routes for navigation between different screens. It also initializes the QuizProvider using the Provider package to manage the state of the quiz score throughout the app.
// The MaterialApp widget is configured with a custom theme and defines the initial route and available routes for the application.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/quiz_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_menu_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/difficulty_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/game_over_screen.dart';
// Entry point of the application

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => QuizProvider(),
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF2787C9),
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/menu': (context) => const AuthMenuScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/difficulty': (context) => const DifficultyScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/gameover': (context) => const GameOverScreen(),
      },
    );
  }
}
