import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_title.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/user_sidebar.dart';
import '../../../shared/widgets/user_top_bar.dart';
import '../../quiz/providers/quiz_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
                            child: UserTopBar(hintText: 'Search history...'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.xl),
                      const SectionTitle(
                        title: 'Quiz History',
                        subtitle:
                            'Review your previous quiz attempts and performance.',
                      ),
                      const SizedBox(height: AppSizes.lg),
                      _buildStatsRow(history),
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

  Widget _buildStatsRow(List history) {
    final totalAttempts = history.length;
    final completed = history.length;
    final averageScore = history.isEmpty
        ? 0
        : (history
                      .map((item) => item.percentage as double)
                      .reduce((a, b) => a + b) /
                  history.length)
              .round();

    return Row(
      children: [
        Expanded(
          child: _HistoryStatCard(
            title: 'Total Attempts',
            value: '$totalAttempts',
            icon: Icons.history,
            iconColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: _HistoryStatCard(
            title: 'Completed',
            value: '$completed',
            icon: Icons.check_circle_outline,
            iconColor: AppColors.success,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: _HistoryStatCard(
            title: 'Average Score',
            value: '$averageScore%',
            icon: Icons.auto_graph_outlined,
            iconColor: AppColors.info,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList(BuildContext context, List history) {
    if (history.isEmpty) {
      return AppCard(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
            child: Column(
              children: const [
                Icon(Icons.history, size: 60, color: AppColors.primary),
                SizedBox(height: 12),
                Text(
                  'No quiz attempts yet',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Text(
                  'Complete a quiz and your history will appear here.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
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
          _buildHeaderRow(context),
          const SizedBox(height: AppSizes.md),
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
                ),
                if (index != history.length - 1)
                  Divider(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                    height: 24,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700);

    return Row(
      children: [
        Expanded(flex: 3, child: Text('Quiz', style: style)),
        Expanded(child: Text('Date', style: style)),
        Expanded(child: Text('Score', style: style)),
        Expanded(child: Text('Percentage', style: style)),
        Expanded(child: Text('Status', style: style)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _HistoryStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _HistoryStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(width: AppSizes.md),
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
                    fontSize: 18,
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

  const _HistoryRow({
    required this.title,
    required this.date,
    required this.score,
    required this.percentage,
    required this.status,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isSuccess ? AppColors.success : AppColors.warning;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(child: Text(date)),
        Expanded(child: Text(score)),
        Expanded(
          child: Text(
            percentage,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
