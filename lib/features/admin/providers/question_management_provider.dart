import 'package:flutter/material.dart';
import '../../../shared/models/question_model.dart';

class QuestionManagementProvider extends ChangeNotifier {
  final List<QuestionModel> _questions = [
    const QuestionModel(
      id: 'q1',
      questionText: 'What is the chemical symbol for Gold?',
      options: ['Ag', 'Au', 'Gd', 'Go'],
      correctAnswerIndex: 1,
    ),
    const QuestionModel(
      id: 'q2',
      questionText: 'Which planet is known as the Red Planet?',
      options: ['Earth', 'Mars', 'Jupiter', 'Venus'],
      correctAnswerIndex: 1,
    ),
    const QuestionModel(
      id: 'q3',
      questionText: 'What is 12 × 8?',
      options: ['96', '88', '108', '84'],
      correctAnswerIndex: 0,
    ),
  ];

  List<QuestionModel> get questions => List.unmodifiable(_questions);

  void addQuestion({
    required String questionText,
    required List<String> options,
    required int correctAnswerIndex,
  }) {
    final question = QuestionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      questionText: questionText,
      options: options,
      correctAnswerIndex: correctAnswerIndex,
    );

    _questions.insert(0, question);
    notifyListeners();
  }

  void updateQuestion({
    required String questionId,
    required String questionText,
    required List<String> options,
    required int correctAnswerIndex,
  }) {
    final index = _questions.indexWhere((q) => q.id == questionId);
    if (index == -1) return;

    _questions[index] = QuestionModel(
      id: _questions[index].id,
      questionText: questionText,
      options: options,
      correctAnswerIndex: correctAnswerIndex,
    );

    notifyListeners();
  }

  void deleteQuestion(String questionId) {
    _questions.removeWhere((q) => q.id == questionId);
    notifyListeners();
  }
}