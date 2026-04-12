import 'dart:math';
import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../data/quiz_questions_data.dart';

class QuestionGenerator {
  static final Random _random = Random();

  /// Generate a math question dynamically
  static QuizQuestion generateMathQuestion({
    required QuizDifficulty difficulty,
  }) {
    late int num1, num2, correctAnswer;
    late String operation;
    late List<String> choices;

    if (difficulty == QuizDifficulty.easy) {
      num1 = _random.nextInt(10) + 1; // 1-10
      num2 = _random.nextInt(10) + 1;
      operation = '+';
      correctAnswer = num1 + num2;
    } else if (difficulty == QuizDifficulty.medium) {
      num1 = _random.nextInt(20) + 1;
      num2 = _random.nextInt(20) + 1;
      operation = _random.nextBool() ? '+' : '-';
      correctAnswer = operation == '+'
          ? num1 + num2
          : (num1 > num2 ? num1 - num2 : num2 - num1);
    } else {
      num1 = _random.nextInt(15) + 1;
      num2 = _random.nextInt(15) + 1;
      operation = '*';
      correctAnswer = num1 * num2;
    }

    choices = _generateWrongAnswers(correctAnswer, count: 3);
    choices.add(correctAnswer.toString());
    choices.shuffle(_random);

    return QuizQuestion(
      id: 'math_gen_${DateTime.now().millisecondsSinceEpoch}',
      category: 'Math',
      question: 'What is $num1 $operation $num2?',
      choices: choices,
      correctAnswer: correctAnswer.toString(),
      difficulty: difficulty,
      explanation: 'The answer is $num1 $operation $num2 = $correctAnswer',
      categoryColor: Colors.purple,
    );
  }

  /// Generate a logic/sequence question
  static QuizQuestion generateSequenceQuestion({
    required QuizDifficulty difficulty,
  }) {
    late List<int> sequence;
    late int nextNumber;

    if (difficulty == QuizDifficulty.easy) {
      // Simple arithmetic sequence
      int start = _random.nextInt(5) + 1;
      int step = _random.nextInt(3) + 1;
      sequence = [start, start + step, start + step * 2];
      nextNumber = start + step * 3;
    } else if (difficulty == QuizDifficulty.medium) {
      // Fibonacci-like
      int a = _random.nextInt(5) + 1;
      int b = _random.nextInt(5) + 1;
      sequence = [a, b, a + b, a + 2 * b];
      nextNumber = a + 3 * b;
    } else {
      // Complex pattern
      int base = _random.nextInt(3) + 2;
      sequence = [
        base,
        base * base,
        base * base * base,
        base * base * base * base,
      ];
      nextNumber = base * base * base * base * base;
    }

    String sequenceStr = sequence.join(', ');
    var choices = _generateWrongAnswers(nextNumber, count: 3);
    choices.add(nextNumber.toString());
    choices.shuffle(_random);

    return QuizQuestion(
      id: 'seq_gen_${DateTime.now().millisecondsSinceEpoch}',
      category: 'Logic',
      question: 'What comes next in this sequence? $sequenceStr, ___',
      choices: choices,
      correctAnswer: nextNumber.toString(),
      difficulty: difficulty,
      explanation: 'Following the pattern, the next number is $nextNumber',
      categoryColor: Colors.indigo,
    );
  }

  /// Generate a trivia question (random from predefined)
  static QuizQuestion generateTriviaQuestion({
    String? category,
    required QuizDifficulty difficulty,
  }) {
    List<QuizQuestion> filtered;

    if (category != null) {
      filtered = QuizQuestionsData.getQuestionsByCategory(
        category,
      ).where((q) => q.difficulty == difficulty).toList();
    } else {
      filtered = QuizQuestionsData.getQuestionsByDifficulty(difficulty);
    }

    if (filtered.isEmpty) {
      return generateMathQuestion(difficulty: difficulty);
    }

    return filtered[_random.nextInt(filtered.length)];
  }

  /// Get a random quiz with mixed question types
  static List<QuizQuestion> generateRandomQuiz({
    int questionCount = 5,
    QuizDifficulty difficulty = QuizDifficulty.medium,
  }) {
    List<QuizQuestion> quiz = [];
    List<String> categories = ['Math', 'Science', 'History', 'English'];

    for (int i = 0; i < questionCount; i++) {
      final type = _random.nextInt(3); // 0: generated, 1: logic, 2: trivia

      QuizQuestion question;
      if (type == 0) {
        question = generateMathQuestion(difficulty: difficulty);
      } else if (type == 1) {
        question = generateSequenceQuestion(difficulty: difficulty);
      } else {
        final randomCategory = categories[_random.nextInt(categories.length)];
        question = generateTriviaQuestion(
          category: randomCategory,
          difficulty: difficulty,
        );
      }

      quiz.add(question);
    }

    return quiz;
  }

  /// Shuffle answer choices
  static List<String> shuffleChoices(List<String> choices) {
    choices.shuffle(_random);
    return choices;
  }

  /// Helper: Generate wrong answers
  static List<String> _generateWrongAnswers(
    int correctAnswer, {
    required int count,
  }) {
    Set<String> wrongAnswers = {};
    int offset = 1;

    while (wrongAnswers.length < count) {
      int wrong = correctAnswer + (offset * (_random.nextBool() ? 1 : -1));
      if (wrong != correctAnswer && wrong > 0) {
        wrongAnswers.add(wrong.toString());
      }
      offset++;
    }

    return wrongAnswers.toList();
  }
}
