import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/widgets/app_text_field.dart';
import '../../routes/app_routes.dart';

class AdminSidebar extends StatelessWidget {
  final String selectedRoute;

  const AdminSidebar({
    super.key,
    required this.selectedRoute,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 250,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withOpacity(0.28)
            : Colors.white.withOpacity(0.92),
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.04),
                  blurRadius: 18,
                  offset: const Offset(6, 0),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.md),
          const _AdminBrandHeader(),
          const SizedBox(height: AppSizes.xl),
          const AppTextField(
            hintText: 'Search admin',
            prefixIcon: Icons.search,
          ),
          const SizedBox(height: AppSizes.xl),
          _AdminNavItem(
            icon: Icons.grid_view_rounded,
            title: 'Dashboard',
            routeName: AppRoutes.adminDashboard,
            selectedRoute: selectedRoute,
          ),
          _AdminNavItem(
            icon: Icons.quiz_outlined,
            title: 'Manage Quizzes',
            routeName: AppRoutes.manageQuizzes,
            selectedRoute: selectedRoute,
          ),
          _AdminNavItem(
            icon: Icons.help_outline,
            title: 'Manage Questions',
            routeName: AppRoutes.manageQuestions,
            selectedRoute: selectedRoute,
          ),
          _AdminNavItem(
            icon: Icons.people_outline,
            title: 'Manage Users',
            routeName: AppRoutes.manageUsers,
            selectedRoute: selectedRoute,
          ),
          _AdminNavItem(
            icon: Icons.bar_chart_outlined,
            title: 'Reports',
            routeName: AppRoutes.reports,
            selectedRoute: selectedRoute,
          ),
          const Spacer(),
          _AdminNavItem(
            icon: Icons.settings_outlined,
            title: 'Back to User App',
            routeName: AppRoutes.dashboard,
            selectedRoute: selectedRoute,
          ),
        ],
      ),
    );
  }
}

class _AdminBrandHeader extends StatelessWidget {
  const _AdminBrandHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: const Icon(Icons.admin_panel_settings, color: Colors.white),
        ),
        const SizedBox(width: AppSizes.sm),
        const Text(
          'Quizzy Admin',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _AdminNavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String routeName;
  final String selectedRoute;

  const _AdminNavItem({
    required this.icon,
    required this.title,
    required this.routeName,
    required this.selectedRoute,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isSelected = selectedRoute == routeName;

    final child = Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        gradient: isSelected ? AppColors.primaryGradient : null,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected
                ? Colors.white
                : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        if (ModalRoute.of(context)?.settings.name == routeName) {
          return;
        }
        Navigator.pushNamed(context, routeName);
      },
      child: child,
    );
  }
}