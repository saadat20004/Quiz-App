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

class QuizDetailScreen extends StatelessWidget {
  const QuizDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final quizProvider = Provider.of<QuizProvider>(context);
    final quiz = quizProvider.selectedQuiz;

    if (quiz == null) {
      return const Scaffold(
        body: Center(
          child: Text('No quiz selected'),
        ),
      );
    }

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
              const UserSidebar(
                selectedRoute: AppRoutes.quizList,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const UserTopBar(
                        hintText:
                            'Search by title, category, or difficulty...',
                      ),
                      const SizedBox(height: AppSizes.xl),

                      /// Header + Back
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios_new),
                          ),
                          const SizedBox(width: AppSizes.sm),
                          const Expanded(
                            child: SectionTitle(
                              title: 'Quiz Details',
                              subtitle:
                                  'Review the quiz information before starting.',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSizes.lg),

                      _buildHeroCard(context, quiz),

                      const SizedBox(height: AppSizes.lg),

                      _buildContentSection(context, quiz),
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

  /// ================= HERO CARD =================
  Widget _buildHeroCard(BuildContext context, dynamic quiz) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppSizes.radiusXl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.20),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.quiz_outlined,
                color: Colors.white,
                size: 64,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.lg),

          /// Dynamic content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.title,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  quiz.description,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: AppSizes.lg),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _MetaChip(
                      icon: Icons.category_outlined,
                      label: quiz.category,
                    ),
                    _MetaChip(
                      icon: Icons.help_outline,
                      label: '${quiz.totalQuestions} Questions',
                    ),
                    _MetaChip(
                      icon: Icons.timer_outlined,
                      label: '${quiz.durationMinutes} Minutes',
                    ),
                    _MetaChip(
                      icon: Icons.signal_cellular_alt_outlined,
                      label: quiz.difficulty,
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

  /// ================= CONTENT =================
  Widget _buildContentSection(BuildContext context, dynamic quiz) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LEFT
        Expanded(
          flex: 3,
          child: Column(
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(
                      title: 'About this Quiz',
                      subtitle: 'What this quiz is about',
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      quiz.description,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              const AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(
                      title: 'Instructions',
                      subtitle: 'Please read before starting',
                    ),
                    SizedBox(height: AppSizes.md),
                    _InstructionItem(
                        text: 'Each question has only one correct answer.'),
                    _InstructionItem(
                        text: 'You can move to next or previous question.'),
                    _InstructionItem(
                        text: 'Quiz auto-submits when time ends.'),
                    _InstructionItem(
                        text: 'Score shown immediately after submission.'),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: AppSizes.lg),

        /// RIGHT
        Expanded(
          flex: 2,
          child: Column(
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(
                      title: 'Quick Stats',
                      subtitle: 'Overview of this quiz',
                    ),
                    const SizedBox(height: AppSizes.lg),

                    _StatRow(label: 'Category', value: quiz.category),
                    const SizedBox(height: AppSizes.md),
                    _StatRow(label: 'Difficulty', value: quiz.difficulty),
                    const SizedBox(height: AppSizes.md),
                    _StatRow(
                        label: 'Questions',
                        value: quiz.totalQuestions.toString()),
                    const SizedBox(height: AppSizes.md),
                    _StatRow(
                        label: 'Time Limit',
                        value: '${quiz.durationMinutes} min'),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(
                      title: 'Ready to Begin?',
                      subtitle: 'Start now and test your knowledge',
                    ),
                    const SizedBox(height: AppSizes.lg),

                    AppButton(
                      text: 'Start Quiz Now',
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.quizAttempt,
                        );
                      },
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

/// ================= SMALL WIDGETS =================

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _InstructionItem extends StatelessWidget {
  final String text;

  const _InstructionItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.primary),
          const SizedBox(width: AppSizes.sm),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}