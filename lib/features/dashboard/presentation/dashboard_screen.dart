import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
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
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserTopBar(
                        hintText: 'Search quizzes, users, reports...',
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

  Widget _buildStatsGrid() {
    return const Wrap(
      spacing: AppSizes.md,
      runSpacing: AppSizes.md,
      children: [
        SizedBox(
          width: 250,
          child: StatCard(
            title: 'Total Quizzes',
            value: '48',
            changeText: '+12% this month',
            icon: Icons.quiz_outlined,
            iconColor: AppColors.primary,
            isPositive: true,
          ),
        ),
        SizedBox(
          width: 250,
          child: StatCard(
            title: 'Completed',
            value: '24',
            changeText: '+5 this week',
            icon: Icons.check_circle_outline,
            iconColor: AppColors.success,
            isPositive: true,
          ),
        ),
        SizedBox(
          width: 250,
          child: StatCard(
            title: 'Pending',
            value: '6',
            changeText: '-2 this week',
            icon: Icons.pending_actions_outlined,
            iconColor: AppColors.warning,
            isPositive: false,
          ),
        ),
        SizedBox(
          width: 250,
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          QuizCard(
                            title: 'Science Challenge',
                            subtitle: 'Physics, chemistry, and biology basics',
                            progress: 0.82,
                            questions: 20,
                            attempts: 164,
                            difficulty: 'Medium',
                            duration: '15 min',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.quizDetail,
                              );
                            },
                            onStart: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.quizDetail,
                              );
                            },
                          ),
                          const SizedBox(width: AppSizes.md),
                          QuizCard(
                            title: 'Math Speed Test',
                            subtitle: 'Quick arithmetic and algebra questions',
                            progress: 0.56,
                            questions: 15,
                            attempts: 98,
                            difficulty: 'Easy',
                            duration: '10 min',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.quizDetail,
                              );
                            },
                            onStart: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.quizDetail,
                              );
                            },
                          ),
                          const SizedBox(width: AppSizes.md),
                          QuizCard(
                            title: 'History Basics',
                            subtitle: 'World history and important events',
                            progress: 0.91,
                            questions: 25,
                            attempts: 205,
                            difficulty: 'Hard',
                            duration: '20 min',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.quizDetail,
                              );
                            },
                            onStart: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.quizDetail,
                              );
                            },
                          ),
                        ],
                      ),
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
                      title: 'Performance Overview',
                      subtitle: 'Visual area reserved for charts and reports',
                    ),
                    const SizedBox(height: AppSizes.lg),
                    Container(
                      height: 260,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(isDark ? 0.10 : 0.08),
                            Colors.transparent,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusXl,
                                ),
                              ),
                              child: const Icon(
                                Icons.insights_outlined,
                                color: Colors.white,
                                size: 34,
                              ),
                            ),
                            const SizedBox(height: AppSizes.md),
                            const Text(
                              'Chart area',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'We will add charts later',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
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
                  name: 'Ava Johnson',
                  category: 'Science',
                  score: 980,
                ),
                _leaderboardDivider(context),
                const LeaderboardTile(
                  rank: 2,
                  name: 'Michael Lee',
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
                  name: 'Daniel Noor',
                  category: 'Technology',
                  score: 902,
                ),
                _leaderboardDivider(context),
                const LeaderboardTile(
                  rank: 5,
                  name: 'Emma Yusuf',
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

  Widget _leaderboardDivider(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Divider(
      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      height: 20,
    );
  }
}
