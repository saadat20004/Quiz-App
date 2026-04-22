import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../admin/providers/quiz_management_provider.dart';
import '../../quiz/providers/quiz_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_title.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/leaderboard_tile.dart';
import '../../../shared/widgets/quiz_card.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../../shared/widgets/user_sidebar.dart';
import '../../../shared/widgets/user_top_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
              const UserSidebar(selectedRoute: AppRoutes.dashboard),
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
                      _buildTopBar(context),
                      const SizedBox(height: AppSizes.xl),
                      const SectionTitle(
                        title: 'Dashboard',
                        subtitle:
                            'Track quiz activity, leaderboard, and recent content.',
                      ),
                      const SizedBox(height: AppSizes.lg),
                      _buildStatsGrid(),
                      const SizedBox(height: AppSizes.lg),
                      _buildMainContent(context),
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

  Widget _buildTopBar(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: const UserTopBar(
            hintText: 'Search quizzes, users, reports...',
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return const Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Total Quizzes',
            value: '48',
            changeText: '+12% this month',
            icon: Icons.quiz_outlined,
            iconColor: AppColors.primary,
            isPositive: true,
          ),
        ),
        SizedBox(width: AppSizes.md),
        Expanded(
          child: StatCard(
            title: 'Completed',
            value: '24',
            changeText: '+5 this week',
            icon: Icons.check_circle_outline,
            iconColor: AppColors.success,
            isPositive: true,
          ),
        ),
        SizedBox(width: AppSizes.md),
        Expanded(
          child: StatCard(
            title: 'Pending',
            value: '6',
            changeText: '-2 this week',
            icon: Icons.pending_actions_outlined,
            iconColor: AppColors.warning,
            isPositive: false,
          ),
        ),
        SizedBox(width: AppSizes.md),
        Expanded(
          child: StatCard(
            title: 'Average Score',
            value: '86%',
            changeText: '+4% this month',
            icon: Icons.auto_graph_outlined,
            iconColor: AppColors.info,
            isPositive: true,
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                    const SectionTitle(
                      title: 'Recent Quizzes',
                      subtitle: 'Your latest quiz content and progress',
                    ),
                    const SizedBox(height: AppSizes.lg),
                    _buildQuizSection(context),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(
                      title: 'Performance Overview',
                      subtitle: 'Visual area reserved for charts and reports',
                    ),
                    const SizedBox(height: AppSizes.lg),
                    const _DashboardPerformanceChart(),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.lg),
        Expanded(
          flex: 2,
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(
                  title: 'Leaderboard',
                  subtitle: 'Top performing participants',
                ),
                const SizedBox(height: AppSizes.lg),
                _leaderboardDivider(context),
                const LeaderboardTile(
                  rank: 1,
                  name: 'Ayesha Noor',
                  category: 'Science',
                  score: 980,
                ),
                _leaderboardDivider(context),
                const LeaderboardTile(
                  rank: 2,
                  name: 'Muhammad Bilal',
                  category: 'Mathematics',
                  score: 945,
                ),
                _leaderboardDivider(context),
                const LeaderboardTile(
                  rank: 3,
                  name: 'Sophia Ahmed',
                  category: 'History',
                  score: 920,
                ),
                _leaderboardDivider(context),
                const LeaderboardTile(
                  rank: 4,
                  name: 'Ali Hassan',
                  category: 'Technology',
                  score: 902,
                ),
                _leaderboardDivider(context),
                const LeaderboardTile(
                  rank: 5,
                  name: 'Hafsa Ahmed',
                  category: 'English',
                  score: 890,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizSection(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final quizManagementProvider = Provider.of<QuizManagementProvider>(context);

    final playableQuizzes = quizManagementProvider.quizzes
        .where((quiz) => quiz.questions.isNotEmpty)
        .toList();

    if (playableQuizzes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSizes.xl),
          child: Text('No playable quizzes available yet'),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: playableQuizzes.map((quiz) {
          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.md),
            child: SizedBox(
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
                  quizProvider.loadQuizById(quiz.id, playableQuizzes);
                  Navigator.pushNamed(context, AppRoutes.quizDetail);
                },
                onStart: () {
                  quizProvider.loadQuizById(quiz.id, playableQuizzes);
                  Navigator.pushNamed(context, AppRoutes.quizDetail);
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _leaderboardDivider(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Divider(
      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      height: 20,
    );
  }
}

class _DashboardPerformanceChart extends StatelessWidget {
  const _DashboardPerformanceChart();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 100,
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 30),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

                  final index = value.toInt();
                  if (index < 0 || index >= labels.length) {
                    return const SizedBox.shrink();
                  }

                  return Text(labels[index]);
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: true),
              spots: const [
                FlSpot(0, 62),
                FlSpot(1, 74),
                FlSpot(2, 68),
                FlSpot(3, 82),
                FlSpot(4, 78),
                FlSpot(5, 90),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
