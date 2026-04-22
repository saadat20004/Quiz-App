import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_title.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/user_sidebar.dart';
import '../../../shared/widgets/user_top_bar.dart';
import '../providers/quiz_provider.dart';

class QuizAttemptScreen extends StatelessWidget {
  const QuizAttemptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quizProvider = Provider.of<QuizProvider>(context);
    final quiz = quizProvider.selectedQuiz;

    if (quizProvider.isTimeUp && quizProvider.hasQuiz) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.result,
          (route) => false,
        );
      });
    }

    if (quiz == null) {
      return const Scaffold(body: Center(child: Text('No quiz selected')));
    }

    final question = quiz.questions[quizProvider.currentQuestionIndex];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          gradient: isDark
              ? AppColors.darkBackgroundGlow
              : LinearGradient(
                  colors: [
                    Colors.white,
                    AppColors.primary.withOpacity(0.04),
                    AppColors.lightBackground,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              const UserSidebar(selectedRoute: AppRoutes.quizList),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.lg,
                    AppSizes.md,
                    AppSizes.lg,
                    AppSizes.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: UserTopBar(hintText: 'Quiz in progress...'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.xl),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusLg,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back_ios_new),
                            ),
                          ),
                          const SizedBox(width: AppSizes.md),
                          Expanded(
                            child: SectionTitle(
                              title: quiz.title,
                              subtitle:
                                  'Answer carefully and complete all questions',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.lg),
                      _buildHeaderStats(quizProvider),
                      const SizedBox(height: AppSizes.lg),
                      _buildMainArea(context, quizProvider, question),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderStats(QuizProvider quizProvider) {
    final quiz = quizProvider.selectedQuiz!;

    return Row(
      children: [
        Expanded(
          child: _AttemptStatCard(
            title: 'Question',
            value:
                '${quizProvider.currentQuestionIndex + 1} / ${quiz.totalQuestions}',
            icon: Icons.help_outline,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: _AttemptStatCard(
            title: 'Progress',
            value: '${(quizProvider.progress * 100).toInt()}%',
            icon: Icons.auto_graph_outlined,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: _AttemptStatCard(
            title: 'Time Left',
            value: _formatTime(quizProvider.remainingSeconds),
            icon: Icons.timer_outlined,
            isWarning: quizProvider.remainingSeconds <= 60,
          ),
        ),
      ],
    );
  }

  Widget _buildMainArea(
    BuildContext context,
    QuizProvider quizProvider,
    dynamic question,
  ) {
    final quiz = quizProvider.selectedQuiz!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${quizProvider.currentQuestionIndex + 1}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      question.questionText,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xl),
                    ...List.generate(question.options.length, (index) {
                      final labels = ['A', 'B', 'C', 'D'];
                      final isSelected =
                          quizProvider.selectedAnswerForCurrentQuestion ==
                          index;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.md),
                        child: _OptionTile(
                          label: labels[index],
                          text: question.options[index],
                          selected: isSelected,
                          onTap: () {
                            quizProvider.selectAnswer(index);
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              AppCard(
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Previous',
                        isOutlined: true,
                        onPressed: quizProvider.isFirstQuestion
                            ? null
                            : () {
                                quizProvider.previousQuestion();
                              },
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: AppButton(
                        text: quizProvider.isLastQuestion
                            ? 'Finish Quiz'
                            : 'Next Question',
                        onPressed: () {
                          if (quizProvider.isLastQuestion) {
                            Navigator.pushNamed(context, AppRoutes.result);
                          } else {
                            quizProvider.nextQuestion();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.lg),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(
                      title: 'Progress',
                      subtitle: 'Track your answers',
                    ),
                    const SizedBox(height: AppSizes.lg),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: quizProvider.progress,
                        minHeight: 10,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text('${(quizProvider.progress * 100).toInt()}% completed'),
                    const SizedBox(height: AppSizes.lg),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(quiz.totalQuestions, (index) {
                        final isCurrent =
                            index == quizProvider.currentQuestionIndex;
                        final isAnswered = quizProvider.selectedAnswers
                            .containsKey(index);

                        Color color;
                        if (isCurrent) {
                          color = AppColors.warning;
                        } else if (isAnswered) {
                          color = AppColors.primary;
                        } else {
                          color = Colors.grey;
                        }

                        return Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(
                      title: 'Quiz Info',
                      subtitle: 'Quick reference',
                    ),
                    const SizedBox(height: AppSizes.lg),
                    _QuickInfoRow(label: 'Category', value: quiz.category),
                    const SizedBox(height: AppSizes.md),
                    _QuickInfoRow(label: 'Difficulty', value: quiz.difficulty),
                    const SizedBox(height: AppSizes.md),
                    _QuickInfoRow(
                      label: 'Questions',
                      value: '${quiz.totalQuestions}',
                    ),
                    const SizedBox(height: AppSizes.md),
                    _QuickInfoRow(
                      label: 'Duration',
                      value: '${quiz.durationMinutes} min',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;

    final m = minutes.toString().padLeft(2, '0');
    final s = secs.toString().padLeft(2, '0');

    return '$m:$s';
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.primaryGradient : null,
          color: selected ? null : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withOpacity(0.18)
                    : AppColors.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: selected ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? Colors.white
                        : (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary),
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttemptStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool isWarning;

  const _AttemptStatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isWarning ? AppColors.warning : AppColors.primary;

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.14),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _QuickInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
