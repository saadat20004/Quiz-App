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
import '../../quiz/providers/quiz_provider.dart';
import '../../../shared/models/result_model.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final quizProvider = Provider.of<QuizProvider>(context);
    final quiz = quizProvider.selectedQuiz;
    final ResultModel result = quizProvider.calculateResult();

    if (quiz == null) {
      return const Scaffold(body: Center(child: Text('No result available')));
    }

    final int percentage = result.percentage.toInt();

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
                            child: UserTopBar(hintText: 'Search results...'),
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
                          const Expanded(
                            child: SectionTitle(
                              title: 'Quiz Result',
                              subtitle:
                                  'Review your performance and score summary.',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.lg),
                      _buildScoreOverview(result, percentage),
                      const SizedBox(height: AppSizes.lg),
                      _buildResultContent(context, quiz, result, percentage),
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

  Widget _buildScoreOverview(ResultModel result, int percentage) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ScoreRing(percentage: percentage),
          const SizedBox(width: AppSizes.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Performance',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  'You answered ${result.correctAnswers} out of ${result.totalQuestions} questions correctly.',
                  style: const TextStyle(fontSize: 15, height: 1.6),
                ),
                const SizedBox(height: AppSizes.lg),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _SummaryChip(
                      label: '${result.correctAnswers} Correct',
                      color: AppColors.success,
                      icon: Icons.check_circle,
                    ),
                    _SummaryChip(
                      label: '${result.wrongAnswers} Wrong',
                      color: AppColors.danger,
                      icon: Icons.cancel,
                    ),
                    _SummaryChip(
                      label: '$percentage%',
                      color: AppColors.primary,
                      icon: Icons.auto_graph,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultContent(
    BuildContext context,
    dynamic quiz,
    ResultModel result,
    int percentage,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(
                  title: 'Detailed Stats',
                  subtitle: 'Breakdown of your result',
                ),
                const SizedBox(height: AppSizes.lg),
                _StatRow(label: 'Quiz', value: quiz.title),
                const SizedBox(height: AppSizes.md),
                _StatRow(label: 'Category', value: quiz.category),
                const SizedBox(height: AppSizes.md),
                _StatRow(
                  label: 'Total Questions',
                  value: result.totalQuestions.toString(),
                ),
                const SizedBox(height: AppSizes.md),
                _StatRow(
                  label: 'Correct Answers',
                  value: result.correctAnswers.toString(),
                ),
                const SizedBox(height: AppSizes.md),
                _StatRow(
                  label: 'Wrong Answers',
                  value: result.wrongAnswers.toString(),
                ),
                const SizedBox(height: AppSizes.md),
                _StatRow(
                  label: 'Score',
                  value: '${result.correctAnswers} / ${result.totalQuestions}',
                ),
                const SizedBox(height: AppSizes.md),
                _StatRow(label: 'Percentage', value: '$percentage%'),
              ],
            ),
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
                      title: 'Result Status',
                      subtitle: 'Quick visual summary',
                    ),
                    const SizedBox(height: AppSizes.lg),
                    _StatusRow(
                      label: 'Performance',
                      value: percentage >= 70
                          ? 'Excellent'
                          : percentage >= 50
                          ? 'Good'
                          : 'Needs Improvement',
                      color: percentage >= 70
                          ? AppColors.success
                          : percentage >= 50
                          ? AppColors.warning
                          : AppColors.danger,
                    ),
                    const SizedBox(height: AppSizes.md),
                    _StatusRow(
                      label: 'Completion',
                      value: 'Submitted',
                      color: AppColors.primary,
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
                      title: 'Actions',
                      subtitle: 'Choose your next step',
                    ),
                    const SizedBox(height: AppSizes.lg),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: 'Back to Dashboard',
                        icon: Icons.dashboard,
                        onPressed: () {
                          Provider.of<QuizProvider>(
                            context,
                            listen: false,
                          ).resetQuiz();

                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.dashboard,
                            (route) => false,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: 'Try Another Quiz',
                        isOutlined: true,
                        onPressed: () {
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScoreRing extends StatelessWidget {
  final int percentage;

  const _ScoreRing({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: CircularProgressIndicator(
              value: percentage / 100,
              strokeWidth: 12,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          Text(
            '$percentage%',
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _SummaryChip({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatusRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.14),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
