import 'package:flutter/material.dart';

/// Enum for difficulty levels
enum QuizDifficulty { easy, medium, hard }

/// Enum for categories
enum QuizCategory {
  memory,
  numbers,
  music,
  food,
  sports,
  science,
  history,
  logic,
  math,
  general,
}

/// Main Question Model
class QuizQuestion {
  final String id; // Unique identifier
  final String category; // Category name (e.g., "Memory", "Numbers")
  final String question; // The question text
  final List<String> choices; // Answer choices
  final String correctAnswer; // Correct answer
  final QuizDifficulty difficulty; // Difficulty level
  final String explanation; // Explanation for learning
  final Color categoryColor; // Color for UI
  final String? imageUrl; // Optional image

  QuizQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.choices,
    required this.correctAnswer,
    required this.difficulty,
    required this.explanation,
    required this.categoryColor,
    this.imageUrl,
  });

  /// Convert to JSON (for storage/API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'question': question,
      'choices': choices,
      'correctAnswer': correctAnswer,
      'difficulty': difficulty.toString(),
      'explanation': explanation,
      'categoryColor': categoryColor.value,
    };
  }

  /// Create from JSON
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'],
      category: json['category'],
      question: json['question'],
      choices: List<String>.from(json['choices']),
      correctAnswer: json['correctAnswer'],
      difficulty: QuizDifficulty.values.firstWhere(
        (e) => e.toString() == json['difficulty'],
      ),
      explanation: json['explanation'],
      categoryColor: Color(json['categoryColor']),
    );
  }

  Null get options => null;
}
