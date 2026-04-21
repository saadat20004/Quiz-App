import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../admin/providers/quiz_management_provider.dart';
import '../providers/quiz_provider.dart';
import '../../../core/utils/mock_quiz_data.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/section_title.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/quiz_card.dart';
import '../../../shared/widgets/user_sidebar.dart';
import '../../../shared/widgets/user_top_bar.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserTopBar(
                        hintText: 'Search by title, category, or difficulty...',
                        actions: [
                          AppButton(
                            text: 'Create Quiz',
                            icon: Icons.add,
                            isFullWidth: false,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Create Quiz page will be added in admin flow',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.xl),
                      const SectionTitle(
                        title: 'Quiz Library',
                        subtitle:
                            'Browse available quizzes, filter by category, and start solving.',
                      ),
                      const SizedBox(height: AppSizes.lg),
                      _buildFilterRow(),
                      const SizedBox(height: AppSizes.lg),
                      _buildFeaturedBanner(context),
                      const SizedBox(height: AppSizes.lg),
                      _buildQuizGrid(context),
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

  Widget _buildFilterRow() {
    return const Wrap(
      spacing: AppSizes.md,
      runSpacing: AppSizes.md,
      children: [
        _FilterChip(label: 'All', selected: true),
        _FilterChip(label: 'Science'),
        _FilterChip(label: 'Mathematics'),
        _FilterChip(label: 'History'),
        _FilterChip(label: 'Technology'),
        _FilterChip(label: 'English'),
      ],
    );
  }

  Widget _buildFeaturedBanner(BuildContext context) {
    return AppCard(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.20),
              AppColors.secondary.withOpacity(0.10),
              Colors.transparent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: Row(
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
              ),
              child: const Icon(
                Icons.auto_awesome_outlined,
                color: Colors.white,
                size: 34,
              ),
            ),
            const SizedBox(width: AppSizes.lg),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Quiz of the Week',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: AppSizes.xs),
                  Text(
                    'Challenge yourself with our top-rated Science & Technology mixed quiz.',
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.md),
            AppButton(
              text: 'Start Now',
              isFullWidth: false,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.quizDetail);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizGrid(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final quizManagementProvider = Provider.of<QuizManagementProvider>(context);

    final quizzes = quizManagementProvider.quizzes
        .where((quiz) => quiz.questions.isNotEmpty)
        .toList();

    if (quizzes.isEmpty) {
      return AppCard(
        child: Column(
          children: const [
            Icon(Icons.quiz_outlined, size: 56, color: AppColors.primary),
            SizedBox(height: AppSizes.md),
            Text(
              'No playable quizzes available yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: AppSizes.sm),
            Text(
              'Admin needs to assign questions before quizzes appear here.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: AppSizes.md,
      runSpacing: AppSizes.md,
      children: quizzes.map((quiz) {
        return QuizCard(
          title: quiz.title,
          subtitle: quiz.description,
          progress: 0.0,
          questions: quiz.totalQuestions,
          attempts: 0,
          difficulty: quiz.difficulty,
          duration: '${quiz.durationMinutes} min',
          onTap: () {
            quizProvider.loadQuizById(quiz.id, quizzes);
            Navigator.pushNamed(context, AppRoutes.quizDetail);
          },
          onStart: () {
            quizProvider.loadQuizById(quiz.id, quizzes);
            Navigator.pushNamed(context, AppRoutes.quizDetail);
          },
        );
      }).toList(),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: selected ? AppColors.primaryGradient : null,
        color: selected
            ? null
            : (isDark
                  ? AppColors.darkCard.withOpacity(0.75)
                  : Colors.white.withOpacity(0.90)),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: selected
              ? Colors.transparent
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected
              ? Colors.white
              : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
