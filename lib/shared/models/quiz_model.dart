import 'question_model.dart';

class QuizModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final int durationMinutes;
  final List<QuestionModel> questions;

  const QuizModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.durationMinutes,
    required this.questions,
  });

  int get totalQuestions => questions.length;
}