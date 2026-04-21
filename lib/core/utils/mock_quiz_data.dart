import '../../shared/models/question_model.dart';
import '../../shared/models/quiz_model.dart';

class MockQuizData {
  static final List<QuizModel> quizzes = [
    QuizModel(
      id: 'quiz_1',
      title: 'Science Quiz',
      description: 'Basic science knowledge test',
      category: 'Science',
      difficulty: 'Easy',
      durationMinutes: 10,
      questions: const [
        QuestionModel(
          id: 'q1',
          questionText: 'What is the boiling point of water?',
          options: ['50°C', '100°C', '150°C', '200°C'],
          correctAnswerIndex: 1,
        ),
        QuestionModel(
          id: 'q2',
          questionText: 'Which planet is known as the Red Planet?',
          options: ['Earth', 'Mars', 'Jupiter', 'Venus'],
          correctAnswerIndex: 1,
        ),
        QuestionModel(
          id: 'q3',
          questionText: 'What gas do plants absorb?',
          options: ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Hydrogen'],
          correctAnswerIndex: 2,
        ),
      ],
    ),
  ];
}