import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/quiz/providers/quiz_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/section_title.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/user_sidebar.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quizProvider = Provider.of<QuizProvider>(context);
    final history = quizProvider.history;

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
              const UserSidebar(selectedRoute: AppRoutes.history),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _HistoryTopBar(),
                      const SizedBox(height: AppSizes.xl),
                      const SectionTitle(
                        title: 'Quiz History',
                        subtitle:
                            'Review your past quiz attempts, scores, and completion status.',
                      ),
                      const SizedBox(height: AppSizes.lg),
                      _buildSummaryCards(),
                      const SizedBox(height: AppSizes.lg),
                      _buildHistoryList(context, history),
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

  Widget _buildSummaryCards() {
    return const Row(
      children: [
        Expanded(
          child: _HistoryStatCard(
            title: 'Total Attempts',
            value: '24',
            icon: Icons.history_outlined,
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: AppSizes.md),
        Expanded(
          child: _HistoryStatCard(
            title: 'Average Score',
            value: '84%',
            icon: Icons.auto_graph_outlined,
            color: AppColors.success,
          ),
        ),
        SizedBox(width: AppSizes.md),
        Expanded(
          child: _HistoryStatCard(
            title: 'Best Score',
            value: '96%',
            icon: Icons.emoji_events_outlined,
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList(BuildContext context, List history) {
    if (history.isEmpty) {
      return AppCard(
        child: Column(
          children: const [
            Icon(Icons.history, size: 60, color: Colors.grey),
            SizedBox(height: 12),
            Text('No quiz attempts yet'),
          ],
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Recent Attempts',
            subtitle: 'Your latest quiz results',
          ),
          const SizedBox(height: AppSizes.lg),

          ...List.generate(history.length, (index) {
            final item = history[index];

            return Column(
              children: [
                _HistoryRow(
                  title: item.quizTitle,
                  date: _formatDate(item.completedAt),
                  score: '${item.correctAnswers} / ${item.totalQuestions}',
                  percentage: '${item.percentage.toStringAsFixed(0)}%',
                  status: 'Completed',
                  isSuccess: item.percentage >= 50,
                  onView: () {
                    Navigator.pushNamed(context, AppRoutes.result);
                  },
                ),
                if (index != history.length - 1)
                  const SizedBox(height: AppSizes.md),
              ],
            );
          }),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildDivider(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      height: 24,
    );
  }
}

class _HistoryTopBar extends StatelessWidget {
  const _HistoryTopBar();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        const Expanded(
          child: AppTextField(
            hintText: 'Search by title or date...',
            prefixIcon: Icons.search,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkCard.withOpacity(0.7)
                : Colors.white.withOpacity(0.95),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          child: IconButton(
            onPressed: () {
              appThemeController.toggleTheme();
            },
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _HistoryStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
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

class _HistoryRow extends StatelessWidget {
  final String title;
  final String date;
  final String score;
  final String percentage;
  final String status;
  final bool isSuccess;
  final VoidCallback onView;

  const _HistoryRow({
    required this.title,
    required this.date,
    required this.score,
    required this.percentage,
    required this.status,
    required this.isSuccess,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: const Icon(Icons.quiz_outlined, color: Colors.white),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(date, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        Expanded(
          child: Text(
            score,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: Text(
            percentage,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: (isSuccess ? AppColors.success : AppColors.warning)
                  .withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSuccess ? AppColors.success : AppColors.warning,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSizes.md),
        SizedBox(
          width: 130,
          child: AppButton(
            text: 'View Result',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.result);
            },
          ),
        ),
      ],
    );
  }
}
