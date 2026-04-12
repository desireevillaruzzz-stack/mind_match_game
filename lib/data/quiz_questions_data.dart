import 'package:flutter/material.dart';
import '../models/quiz_question.dart';

class QuizQuestionsData {
  /// Math Category Questions
  static final List<QuizQuestion> mathQuestions = [
    QuizQuestion(
      id: 'math_001',
      category: 'Math',
      question: 'What is the square root of 144?',
      choices: ['10', '12', '14', '16'],
      correctAnswer: '12',
      difficulty: QuizDifficulty.easy,
      explanation: 'The square root of 144 is 12 because 12 × 12 = 144.',
      categoryColor: Colors.purple,
    ),
    QuizQuestion(
      id: 'math_002',
      category: 'Math',
      question: 'What is 25% of 200?',
      choices: ['25', '50', '75', '100'],
      correctAnswer: '50',
      difficulty: QuizDifficulty.easy,
      explanation: '25% of 200 = 0.25 × 200 = 50.',
      categoryColor: Colors.purple,
    ),
    QuizQuestion(
      id: 'math_003',
      category: 'Math',
      question: 'Solve: 2x + 5 = 15. What is x?',
      choices: ['5', '10', '15', '20'],
      correctAnswer: '5',
      difficulty: QuizDifficulty.medium,
      explanation: '2x + 5 = 15 → 2x = 10 → x = 5.',
      categoryColor: Colors.purple,
    ),
    QuizQuestion(
      id: 'math_004',
      category: 'Math',
      question: 'What is the area of a circle with radius 5?',
      choices: ['25π', '50π', '75π', '100π'],
      correctAnswer: '25π',
      difficulty: QuizDifficulty.medium,
      explanation: 'Area of circle = πr² = π × 5² = 25π.',
      categoryColor: Colors.purple,
    ),
    QuizQuestion(
      id: 'math_005',
      category: 'Math',
      question: 'What is the sum of angles in a triangle?',
      choices: ['90°', '180°', '270°', '360°'],
      correctAnswer: '180°',
      difficulty: QuizDifficulty.hard,
      explanation: 'The sum of all angles in any triangle is always 180°.',
      categoryColor: Colors.purple,
    ),
  ];

  /// Science Category Questions
  static final List<QuizQuestion> scienceQuestions = [
    QuizQuestion(
      id: 'sci_001',
      category: 'Science',
      question: 'What is the chemical symbol for Gold?',
      choices: ['Go', 'Au', 'Gd', 'Ag'],
      correctAnswer: 'Au',
      difficulty: QuizDifficulty.easy,
      explanation: 'The chemical symbol for Gold is Au (from Latin "aurum").',
      categoryColor: Colors.orange,
    ),
    QuizQuestion(
      id: 'sci_002',
      category: 'Science',
      question: 'How many bones are in the human body?',
      choices: ['186', '206', '226', '246'],
      correctAnswer: '206',
      difficulty: QuizDifficulty.easy,
      explanation: 'An adult human body has 206 bones.',
      categoryColor: Colors.orange,
    ),
    QuizQuestion(
      id: 'sci_003',
      category: 'Science',
      question: 'What is the speed of light in vacuum?',
      choices: ['300,000 km/s', '150,000 km/s', '450,000 km/s', '600,000 km/s'],
      correctAnswer: '300,000 km/s',
      difficulty: QuizDifficulty.medium,
      explanation:
          'The speed of light is approximately 300,000 kilometers per second.',
      categoryColor: Colors.orange,
    ),
    QuizQuestion(
      id: 'sci_004',
      category: 'Science',
      question: 'Which planet is closest to the sun?',
      choices: ['Venus', 'Mercury', 'Earth', 'Mars'],
      correctAnswer: 'Mercury',
      difficulty: QuizDifficulty.medium,
      explanation: 'Mercury is the closest planet to the sun.',
      categoryColor: Colors.orange,
    ),
    QuizQuestion(
      id: 'sci_005',
      category: 'Science',
      question: 'What is the powerhouse of the cell?',
      choices: ['Nucleus', 'Mitochondria', 'Ribosome', 'Chloroplast'],
      correctAnswer: 'Mitochondria',
      difficulty: QuizDifficulty.hard,
      explanation:
          'The mitochondria is the powerhouse of the cell, responsible for producing energy.',
      categoryColor: Colors.orange,
    ),
  ];

  /// History Category Questions
  static final List<QuizQuestion> historyQuestions = [
    QuizQuestion(
      id: 'hist_001',
      category: 'History',
      question: 'In which year did World War II end?',
      choices: ['1943', '1944', '1945', '1946'],
      correctAnswer: '1945',
      difficulty: QuizDifficulty.easy,
      explanation: 'World War II ended in 1945 with the surrender of Japan.',
      categoryColor: Colors.brown,
    ),
    QuizQuestion(
      id: 'hist_002',
      category: 'History',
      question: 'Who was the first President of the United States?',
      choices: [
        'Thomas Jefferson',
        'George Washington',
        'Benjamin Franklin',
        'John Adams',
      ],
      correctAnswer: 'George Washington',
      difficulty: QuizDifficulty.easy,
      explanation:
          'George Washington was the first President of the United States (1789-1797).',
      categoryColor: Colors.brown,
    ),
    QuizQuestion(
      id: 'hist_003',
      category: 'History',
      question: 'In which year did the Titanic sink?',
      choices: ['1910', '1912', '1914', '1916'],
      correctAnswer: '1912',
      difficulty: QuizDifficulty.medium,
      explanation: 'The RMS Titanic sank on April 15, 1912.',
      categoryColor: Colors.brown,
    ),
    QuizQuestion(
      id: 'hist_004',
      category: 'History',
      question: 'Which empire built the Great Wall of China?',
      choices: ['Han Dynasty', 'Ming Dynasty', 'Tang Dynasty', 'Song Dynasty'],
      correctAnswer: 'Ming Dynasty',
      difficulty: QuizDifficulty.medium,
      explanation:
          'Most of the Great Wall as we know it today was built during the Ming Dynasty (1368-1644).',
      categoryColor: Colors.brown,
    ),
    QuizQuestion(
      id: 'hist_005',
      category: 'History',
      question: 'Who wrote the Declaration of Independence?',
      choices: [
        'George Washington',
        'Benjamin Franklin',
        'Thomas Jefferson',
        'John Hancock',
      ],
      correctAnswer: 'Thomas Jefferson',
      difficulty: QuizDifficulty.hard,
      explanation:
          'Thomas Jefferson was the primary author of the Declaration of Independence in 1776.',
      categoryColor: Colors.brown,
    ),
  ];

  /// English Category Questions
  static final List<QuizQuestion> englishQuestions = [
    QuizQuestion(
      id: 'eng_001',
      category: 'English',
      question: 'What is the plural of "child"?',
      choices: ['childs', 'childes', 'children', 'childrens'],
      correctAnswer: 'children',
      difficulty: QuizDifficulty.easy,
      explanation: 'The plural of "child" is "children".',
      categoryColor: Colors.cyan,
    ),
    QuizQuestion(
      id: 'eng_002',
      category: 'English',
      question: 'Which word is a synonym for "happy"?',
      choices: ['sad', 'angry', 'joyful', 'tired'],
      correctAnswer: 'joyful',
      difficulty: QuizDifficulty.easy,
      explanation: 'A synonym for "happy" is "joyful".',
      categoryColor: Colors.cyan,
    ),
    QuizQuestion(
      id: 'eng_003',
      category: 'English',
      question: 'Identify the correct spelling.',
      choices: ['occured', 'occured', 'occurred', 'ocurred'],
      correctAnswer: 'occurred',
      difficulty: QuizDifficulty.medium,
      explanation: 'The correct spelling is "occurred" (past tense of occur).',
      categoryColor: Colors.cyan,
    ),
    QuizQuestion(
      id: 'eng_004',
      category: 'English',
      question: 'What is the antonym of "beautiful"?',
      choices: ['pretty', 'lovely', 'ugly', 'handsome'],
      correctAnswer: 'ugly',
      difficulty: QuizDifficulty.medium,
      explanation: 'The antonym of "beautiful" is "ugly".',
      categoryColor: Colors.cyan,
    ),
    QuizQuestion(
      id: 'eng_005',
      category: 'English',
      question: 'Who wrote "Romeo and Juliet"?',
      choices: [
        'Jane Austen',
        'William Shakespeare',
        'Charles Dickens',
        'Mark Twain',
      ],
      correctAnswer: 'William Shakespeare',
      difficulty: QuizDifficulty.hard,
      explanation: 'William Shakespeare wrote "Romeo and Juliet".',
      categoryColor: Colors.cyan,
    ),
  ];

  /// Get all questions by category
  static List<QuizQuestion> getQuestionsByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'math':
        return mathQuestions;
      case 'science':
        return scienceQuestions;
      case 'history':
        return historyQuestions;
      case 'english':
        return englishQuestions;
      default:
        return [];
    }
  }

  /// Get all questions
  static List<QuizQuestion> getAllQuestions() {
    return [
      ...mathQuestions,
      ...scienceQuestions,
      ...historyQuestions,
      ...englishQuestions,
    ];
  }

  /// Get questions by difficulty
  static List<QuizQuestion> getQuestionsByDifficulty(
    QuizDifficulty difficulty,
  ) {
    return getAllQuestions().where((q) => q.difficulty == difficulty).toList();
  }
}
