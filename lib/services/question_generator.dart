import 'dart:math';

import 'package:flutter/material.dart';

import '../data/quiz_questions_data.dart';
import '../models/quiz_question.dart';

class QuestionGenerator {
  static final Random _random = Random();

  static QuizQuestion generateMathQuestion({
    required QuizDifficulty difficulty,
  }) {
    late int num1;
    late int num2;
    late int correctAnswer;
    late String operation;
    late List<String> choices;

    if (difficulty == QuizDifficulty.easy) {
      num1 = _random.nextInt(10) + 1;
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
      final operations = ['*', '+', '-'];
      operation = operations[_random.nextInt(operations.length)];

      num1 = _random.nextInt(30) + 5;
      num2 = _random.nextInt(15) + 2;

      if (operation == '*') {
        correctAnswer = num1 * num2;
      } else if (operation == '+') {
        correctAnswer = num1 + num2;
      } else {
        correctAnswer = num1 > num2 ? num1 - num2 : num2 - num1;
      }
    }

    choices = _generateWrongAnswers(correctAnswer, count: 3);
    choices.add(correctAnswer.toString());
    choices.shuffle(_random);

    return QuizQuestion(
      id: 'math_gen_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(9999)}',
      category: 'Math',
      question: 'What is $num1 $operation $num2?',
      choices: choices,
      correctAnswer: correctAnswer.toString(),
      difficulty: difficulty,
      explanation: 'The answer is $num1 $operation $num2 = $correctAnswer',
      categoryColor: Colors.purple,
    );
  }

  static QuizQuestion generateSequenceQuestion({
    required QuizDifficulty difficulty,
  }) {
    late List<int> sequence;
    late int nextNumber;

    if (difficulty == QuizDifficulty.easy) {
      final start = _random.nextInt(5) + 1;
      final step = _random.nextInt(3) + 1;
      sequence = <int>[start, start + step, start + step * 2];
      nextNumber = start + step * 3;
    } else if (difficulty == QuizDifficulty.medium) {
      final a = _random.nextInt(5) + 1;
      final b = _random.nextInt(5) + 1;
      sequence = <int>[a, b, a + b, a + 2 * b];
      nextNumber = a + 3 * b;
    } else {
      final base = _random.nextInt(4) + 2;
      sequence = <int>[
        base,
        base * base,
        base * base * base,
        base * base * base * base,
      ];
      nextNumber = base * base * base * base * base;
    }

    final sequenceStr = sequence.join(', ');
    final choices = _generateWrongAnswers(nextNumber, count: 3)
      ..add(nextNumber.toString())
      ..shuffle(_random);

    return QuizQuestion(
      id: 'seq_gen_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(9999)}',
      category: 'Logic',
      question: 'What comes next in this sequence? $sequenceStr, ___',
      choices: choices,
      correctAnswer: nextNumber.toString(),
      difficulty: difficulty,
      explanation: 'Following the pattern, the next number is $nextNumber',
      categoryColor: Colors.indigo,
    );
  }

  static QuizQuestion generateTriviaQuestion({
    String? category,
    required QuizDifficulty difficulty,
    Set<String>? excludeIds,
  }) {
    List<QuizQuestion> filtered;

    if (category != null && category.trim().isNotEmpty) {
      filtered = QuizQuestionsData.getQuestionsByCategory(category)
          .where((q) => q.difficulty == difficulty)
          .toList();
    } else {
      filtered = QuizQuestionsData.getQuestionsByDifficulty(difficulty);
    }

    if (excludeIds != null && excludeIds.isNotEmpty) {
      filtered = filtered.where((q) => !excludeIds.contains(q.id)).toList();
    }

    if (filtered.isEmpty) {
      return generateMathQuestion(difficulty: difficulty);
    }

    return filtered[_random.nextInt(filtered.length)];
  }

  static QuizQuestion generateSingleQuestion({
    required QuizDifficulty difficulty,
    String? category,
    Set<String>? excludeIds,
  }) {
    const categories = <String>[
      'Math',
      'Science',
      'History',
      'English Grammar',
      'Computer',
    ];

    final type = _random.nextInt(4);

    if (type == 0) {
      return generateMathQuestion(difficulty: difficulty);
    } else if (type == 1) {
      return generateSequenceQuestion(difficulty: difficulty);
    } else {
      final pickedCategory = (category != null && category.trim().isNotEmpty)
          ? category
          : categories[_random.nextInt(categories.length)];

      return generateTriviaQuestion(
        category: pickedCategory,
        difficulty: difficulty,
        excludeIds: excludeIds,
      );
    }
  }

  static List<QuizQuestion> generateRandomQuiz({
    int questionCount = 10,
    QuizDifficulty difficulty = QuizDifficulty.medium,
    String? category,
  }) {
    final quiz = <QuizQuestion>[];
    final usedIds = <String>{};

    int attempts = 0;
    while (quiz.length < questionCount && attempts < questionCount * 10) {
      attempts++;

      final question = generateSingleQuestion(
        difficulty: difficulty,
        category: category,
        excludeIds: usedIds,
      );

      if (!usedIds.contains(question.id)) {
        quiz.add(question);
        usedIds.add(question.id);
      }
    }

    while (quiz.length < questionCount) {
      quiz.add(generateMathQuestion(difficulty: difficulty));
    }

    return quiz;
  }

  static List<String> shuffleChoices(List<String> choices) {
    final copy = List<String>.from(choices);
    copy.shuffle(_random);
    return copy;
  }

  static List<String> _generateWrongAnswers(
    int correctAnswer, {
    required int count,
  }) {
    final wrongAnswers = <String>{};
    int offset = 1;

    while (wrongAnswers.length < count) {
      final wrong = correctAnswer + (offset * (_random.nextBool() ? 1 : -1));
      if (wrong != correctAnswer && wrong > 0) {
        wrongAnswers.add(wrong.toString());
      }
      offset++;
    }

    return wrongAnswers.toList();
  }
}
