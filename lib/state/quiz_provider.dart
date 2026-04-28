import 'package:flutter/foundation.dart';

import '../models/quiz_question.dart';
import '../services/question_generator.dart';

class QuizProvider extends ChangeNotifier {
  List<QuizQuestion> _currentQuiz = <QuizQuestion>[];
  int _currentQuestionIndex = 0;
  int _score = 0;
  QuizDifficulty _selectedDifficulty = QuizDifficulty.medium;
  String? _selectedCategory;
  final List<bool> _answers = <bool>[];
  bool _survivalMode = false;

  List<QuizQuestion> get currentQuiz => List.unmodifiable(_currentQuiz);
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  QuizDifficulty get selectedDifficulty => _selectedDifficulty;
  String? get selectedCategory => _selectedCategory;
  List<bool> get answers => List.unmodifiable(_answers);
  bool get survivalMode => _survivalMode;

  List<QuizQuestion> get questions => List.unmodifiable(_currentQuiz);

  int get totalQuestions => _currentQuiz.length;

  bool get hasQuestions => _currentQuiz.isNotEmpty;

  bool get isQuizFinished =>
      _currentQuiz.isNotEmpty && _currentQuestionIndex >= _currentQuiz.length;

  QuizQuestion? get currentQuestion {
    if (_currentQuiz.isEmpty) return null;
    if (_currentQuestionIndex < 0 ||
        _currentQuestionIndex >= _currentQuiz.length) {
      return null;
    }
    return _currentQuiz[_currentQuestionIndex];
  }

  void startNewQuiz({
    int questionCount = 10,
    String? category,
    QuizDifficulty? difficulty,
    bool survivalMode = false,
  }) {
    _selectedDifficulty = difficulty ?? QuizDifficulty.medium;
    _selectedCategory = category;
    _currentQuestionIndex = 0;
    _score = 0;
    _answers.clear();
    _survivalMode = survivalMode;

    if (_survivalMode) {
      _currentQuiz = [
        QuestionGenerator.generateSingleQuestion(
          difficulty: _selectedDifficulty,
          category: _selectedCategory,
        ),
      ];
    } else {
      _currentQuiz = QuestionGenerator.generateRandomQuiz(
        questionCount: questionCount,
        difficulty: _selectedDifficulty,
        category: _selectedCategory,
      );
    }

    notifyListeners();
  }

  bool answerQuestion(String selectedAnswer) {
    final question = currentQuestion;
    if (question == null) return false;

    final isCorrect = selectedAnswer == question.correctAnswer;
    _answers.add(isCorrect);

    if (_survivalMode) {
      if (isCorrect) {
        _score++;
        _currentQuestionIndex++;

        _currentQuiz.add(
          QuestionGenerator.generateSingleQuestion(
            difficulty: _selectedDifficulty,
            category: _selectedCategory,
            excludeIds: _currentQuiz.map((q) => q.id).toSet(),
          ),
        );
      } else {
        _currentQuestionIndex = _currentQuiz.length;
      }

      notifyListeners();
      return isCorrect;
    }

    if (isCorrect) {
      _score++;
    }

    _currentQuestionIndex++;
    notifyListeners();
    return isCorrect;
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _currentQuiz.length) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _currentQuiz = <QuizQuestion>[];
    _answers.clear();
    _selectedCategory = null;
    _selectedDifficulty = QuizDifficulty.medium;
    _survivalMode = false;
    notifyListeners();
  }

  double getScorePercentage() {
    if (_currentQuiz.isEmpty) return 0;
    return (_score / _currentQuiz.length) * 100;
  }

  String getPerformanceFeedback() {
    if (_survivalMode) {
      if (_score >= 30) {
        return '🔥 Legendary run!';
      } else if (_score >= 20) {
        return '🌟 Amazing survival!';
      } else if (_score >= 10) {
        return '👏 Great run!';
      } else {
        return '💪 Keep practicing!';
      }
    }

    final percentage = getScorePercentage();

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
