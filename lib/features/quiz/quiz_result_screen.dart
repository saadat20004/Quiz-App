import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../routes/app_routes.dart';
import '../quiz/providers/quiz_provider.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final quiz = provider.selectedQuiz;

    if (quiz == null) {
      return const Scaffold(
        body: Center(
          child: Text('No quiz data found'),
        ),
      );
    }

    int score = 0;

    for (int i = 0; i < quiz.questions.length; i++) {
      final selected = provider.selectedAnswers[i];
      final correct = quiz.questions[i].correctAnswerIndex;

      if (selected == correct) {
        score++;
      }
    }

    final total = quiz.questions.length;
    final percent = total == 0 ? 0 : ((score / total) * 100).round();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.2),
              Colors.white,
              AppColors.secondary.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.emoji_events,
                  size: 80,
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppSizes.lg),
                Text(
                  'Quiz Completed!',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSizes.lg),
                Text(
                  quiz.title,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: AppSizes.xl),
                Text(
                  '$score / $total',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Score: $percent%',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: AppSizes.xl),
                LinearProgressIndicator(
                  value: total == 0 ? 0 : score / total,
                  minHeight: 10,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation(
                    AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSizes.xl),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Retry',
                        isOutlined: true,
                        onPressed: () {
                          provider.loadQuizById(quiz.id, [quiz]);
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.quizAttempt,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: AppButton(
                        text: 'Home',
                        onPressed: () {
                          provider.resetQuiz();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.quizList,
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}