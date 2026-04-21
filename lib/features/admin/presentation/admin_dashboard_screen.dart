import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_title.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/admin_sidebar.dart';
import '../../../shared/widgets/admin_top_bar.dart';
import '../../../shared/widgets/stat_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

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
              const AdminSidebar(
                selectedRoute: AppRoutes.adminDashboard,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdminTopBar(
                        hintText: 'Search quizzes, users, reports...',
                        actions: [
                          AppButton(
                            text: 'New Quiz',
                            icon: Icons.add,
                            isFullWidth: false,
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.manageQuizzes,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.xl),
                      const SectionTitle(
                        title: 'Admin Dashboard',
                        subtitle:
                            'Manage quizzes, users, content, and analytics.',
                      ),
                      const SizedBox(height: AppSizes.lg),
                      const Wrap(
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
                              title: 'Questions Bank',
                              value: '320',
                              changeText: '+18 this week',
                              icon: Icons.help_outline,
                              iconColor: AppColors.info,
                              isPositive: true,
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: StatCard(
                              title: 'Registered Users',
                              value: '1,284',
                              changeText: '+22 this week',
                              icon: Icons.people_outline,
                              iconColor: AppColors.success,
                              isPositive: true,
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: StatCard(
                              title: 'Avg. Completion',
                              value: '86%',
                              changeText: '+4%',
                              icon: Icons.auto_graph_outlined,
                              iconColor: AppColors.warning,
                              isPositive: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.lg),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionTitle(
                              title: 'Admin Quick Actions',
                              subtitle:
                                  'Jump into the most common management tasks.',
                            ),
                            const SizedBox(height: AppSizes.lg),
                            Wrap(
                              spacing: AppSizes.md,
                              runSpacing: AppSizes.md,
                              children: [
                                _QuickActionCard(
                                  title: 'Manage Quizzes',
                                  icon: Icons.quiz_outlined,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.manageQuizzes,
                                    );
                                  },
                                ),
                                _QuickActionCard(
                                  title: 'Manage Questions',
                                  icon: Icons.help_outline,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.manageQuestions,
                                    );
                                  },
                                ),
                                _QuickActionCard(
                                  title: 'Manage Users',
                                  icon: Icons.people_outline,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.manageUsers,
                                    );
                                  },
                                ),
                                _QuickActionCard(
                                  title: 'View Reports',
                                  icon: Icons.bar_chart_outlined,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.reports,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: AppColors.primary),
              const SizedBox(height: AppSizes.md),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}