import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_title.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/quiz_card.dart';
import '../../../shared/widgets/user_sidebar.dart';
import '../../../shared/widgets/user_top_bar.dart';
import '../../admin/providers/quiz_management_provider.dart';
import '../providers/quiz_provider.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({super.key});

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = const [
    'All',
    'Science',
    'Mathematics',
    'History',
    'Technology',
    'English',
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

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
                      _buildTopBar(),
                      const SizedBox(height: AppSizes.xl),
                      const SectionTitle(
                        title: 'Quiz Library',
                        subtitle:
                            'Browse available quizzes, filter by category, and start solving.',
                      ),
                      const SizedBox(height: AppSizes.lg),
                      _buildCategoryFilters(),
                      const SizedBox(height: AppSizes.lg),
                      _buildFeaturedBanner(context),
                      const SizedBox(height: AppSizes.xl),
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

  Widget _buildTopBar() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: UserTopBar(
            hintText: 'Search by title, category, or difficulty...',
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilters() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _categories.map((category) {
        final bool isSelected = _selectedCategory == category;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategory = category;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.lg,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.primaryGradient : null,
              color: isSelected ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkBorder
                    : AppColors.lightBorder,
              ),
            ),
            child: Text(
              category,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeaturedBanner(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          AppSizes.lg,
          AppSizes.md,
          AppSizes.lg,
          AppSizes.lg,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(isDark ? 0.18 : 0.10),
              Colors.transparent,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
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
                Icons.auto_awesome,
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Challenge yourself with our most engaging curated quiz collection.',
                  ),
                ],
              ),
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
        .where(
          (quiz) =>
              _selectedCategory == 'All' || quiz.category == _selectedCategory,
        )
        .toList();

    if (quizzes.isEmpty) {
      return AppCard(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
            child: Column(
              children: const [
                Icon(Icons.quiz_outlined, size: 56, color: AppColors.primary),
                SizedBox(height: AppSizes.md),
                Text(
                  'No playable quizzes available',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: AppSizes.sm),
                Text(
                  'Try another category or assign questions from the admin panel.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: AppSizes.md,
      runSpacing: AppSizes.md,
      children: quizzes.map((quiz) {
        return SizedBox(
          width: 320,
          child: QuizCard(
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
          ),
        );
      }).toList(),
    );
  }
}
