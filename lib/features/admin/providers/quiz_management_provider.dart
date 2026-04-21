import 'package:flutter/material.dart';
import '../../../shared/models/question_model.dart';
import '../../../shared/models/quiz_model.dart';

class QuizManagementProvider extends ChangeNotifier {
  final List<QuizModel> _quizzes = [
    QuizModel(
      id: 'quiz_1',
      title: 'Science Challenge',
      description: 'Physics, chemistry, and biology basics.',
      category: 'Science',
      difficulty: 'Medium',
      durationMinutes: 15,
      questions: const [
        QuestionModel(
          id: 'q1',
          questionText: 'What is the chemical symbol for Gold?',
          options: ['Ag', 'Au', 'Gd', 'Go'],
          correctAnswerIndex: 1,
        ),
        QuestionModel(
          id: 'q2',
          questionText: 'Which planet is known as the Red Planet?',
          options: ['Earth', 'Mars', 'Jupiter', 'Venus'],
          correctAnswerIndex: 1,
        ),
      ],
    ),
    QuizModel(
      id: 'quiz_2',
      title: 'Math Speed Test',
      description: 'Quick arithmetic and algebra questions.',
      category: 'Mathematics',
      difficulty: 'Easy',
      durationMinutes: 10,
      questions: const [
        QuestionModel(
          id: 'm1',
          questionText: 'What is 12 × 8?',
          options: ['96', '88', '108', '84'],
          correctAnswerIndex: 0,
        ),
      ],
    ),
  ];

  List<QuizModel> get quizzes => List.unmodifiable(_quizzes);

  QuizModel? getQuizById(String quizId) {
    try {
      return _quizzes.firstWhere((quiz) => quiz.id == quizId);
    } catch (_) {
      return null;
    }
  }

  void addQuiz({
    required String title,
    required String description,
    required String category,
    required String difficulty,
    required int durationMinutes,
  }) {
    final quiz = QuizModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      category: category,
      difficulty: difficulty,
      durationMinutes: durationMinutes,
      questions: const [],
    );

    _quizzes.insert(0, quiz);
    notifyListeners();
  }

  void deleteQuiz(String quizId) {
    _quizzes.removeWhere((quiz) => quiz.id == quizId);
    notifyListeners();
  }

  void updateQuiz({
    required String quizId,
    required String title,
    required String description,
    required String category,
    required String difficulty,
    required int durationMinutes,
  }) {
    final index = _quizzes.indexWhere((quiz) => quiz.id == quizId);
    if (index == -1) return;

    final oldQuiz = _quizzes[index];

    _quizzes[index] = QuizModel(
      id: oldQuiz.id,
      title: title,
      description: description,
      category: category,
      difficulty: difficulty,
      durationMinutes: durationMinutes,
      questions: oldQuiz.questions,
    );

    notifyListeners();
  }

  void assignQuestionsToQuiz({
    required String quizId,
    required List<QuestionModel> selectedQuestions,
  }) {
    final index = _quizzes.indexWhere((quiz) => quiz.id == quizId);
    if (index == -1) return;

    final oldQuiz = _quizzes[index];

    _quizzes[index] = QuizModel(
      id: oldQuiz.id,
      title: oldQuiz.title,
      description: oldQuiz.description,
      category: oldQuiz.category,
      difficulty: oldQuiz.difficulty,
      durationMinutes: oldQuiz.durationMinutes,
      questions: List<QuestionModel>.from(selectedQuestions),
    );

    notifyListeners();
  }
}