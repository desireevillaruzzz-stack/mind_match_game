import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../services/question_generator.dart';

class QuizProvider extends ChangeNotifier {
  List<QuizQuestion> _currentQuiz = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  QuizDifficulty _selectedDifficulty = QuizDifficulty.medium;
  String? _selectedCategory;
  List<bool> _answers = []; // Track correct/incorrect answers

  // Getters
  List<QuizQuestion> get currentQuiz => _currentQuiz;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  QuizDifficulty get selectedDifficulty => _selectedDifficulty;
  String? get selectedCategory => _selectedCategory;
  List<bool> get answers => _answers;

  QuizQuestion? get currentQuestion =>
      _currentQuestionIndex < _currentQuiz.length
      ? _currentQuiz[_currentQuestionIndex]
      : null;

  bool get isQuizFinished => _currentQuestionIndex >= _currentQuiz.length;

  int get totalQuestions => _currentQuiz.length;

  /// Initialize a new quiz
  void startNewQuiz({
    int questionCount = 5,
    String? category,
    QuizDifficulty? difficulty,
  }) {
    _selectedDifficulty = difficulty ?? QuizDifficulty.medium;
    _selectedCategory = category;
    _currentQuestionIndex = 0;
    _score = 0;
    _answers = [];

    _currentQuiz = QuestionGenerator.generateRandomQuiz(
      questionCount: questionCount,
      difficulty: _selectedDifficulty,
    );

    notifyListeners();
  }

  /// Answer current question
  void answerQuestion(String selectedAnswer) {
    if (currentQuestion == null) return;

    bool isCorrect = selectedAnswer == currentQuestion!.correctAnswer;
    _answers.add(isCorrect);

    if (isCorrect) {
      _score++;
    }

    _currentQuestionIndex++;
    notifyListeners();
  }

  /// Next question (without answering - for UI purposes)
  void nextQuestion() {
    if (_currentQuestionIndex < _currentQuiz.length) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  /// Reset quiz
  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _currentQuiz = [];
    _answers = [];
    notifyListeners();
  }

  /// Get score percentage
  double getScorePercentage() {
    if (_currentQuiz.isEmpty) return 0;
    return (_score / _currentQuiz.length) * 100;
  }

  /// Get performance feedback
  String getPerformanceFeedback() {
    double percentage = getScorePercentage();
    if (percentage == 100) {
      return '🎉 Perfect! Outstanding performance!';
    } else if (percentage >= 80) {
      return '🌟 Excellent! Great job!';
    } else if (percentage >= 60) {
      return '👍 Good! Keep it up!';
    } else if (percentage >= 40) {
      return '📚 Fair! Practice more!';
    } else {
      return '💪 Keep learning! You\'ll improve!';
    }
  }
}
