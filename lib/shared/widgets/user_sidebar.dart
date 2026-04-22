import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../routes/app_routes.dart';

class UserSidebar extends StatelessWidget {
  final String selectedRoute;

  const UserSidebar({
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.md),
          const _BrandHeader(),
          const SizedBox(height: AppSizes.xl),
          _UserNavItem(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            routeName: AppRoutes.dashboard,
            selectedRoute: selectedRoute,
          ),
          _UserNavItem(
            icon: Icons.quiz_outlined,
            title: 'Quiz List',
            routeName: AppRoutes.quizList,
            selectedRoute: selectedRoute,
          ),
          _UserNavItem(
            icon: Icons.history,
            title: 'History',
            routeName: AppRoutes.history,
            selectedRoute: selectedRoute,
          ),
          _UserNavItem(
            icon: Icons.person_outline,
            title: 'Profile',
            routeName: AppRoutes.profile,
            selectedRoute: selectedRoute,
          ),
          _UserNavItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            routeName: AppRoutes.settings,
            selectedRoute: selectedRoute,
          ),
          const Spacer(),
          _UserNavItem(
            icon: Icons.logout,
            title: 'Logout',
            routeName: AppRoutes.login,
            selectedRoute: selectedRoute,
            isLogout: true,
          ),
        ],
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

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
          child: const Icon(Icons.quiz_outlined, color: Colors.white),
        ),
        const SizedBox(width: AppSizes.sm),
        const Text(
          'Quizzy',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _UserNavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String routeName;
  final String selectedRoute;
  final bool isLogout;

  const _UserNavItem({
    required this.icon,
    required this.title,
    required this.routeName,
    required this.selectedRoute,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isSelected = selectedRoute == routeName && !isLogout;

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
        if (isLogout) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
          return;
        }

        if (ModalRoute.of(context)?.settings.name == routeName) {
          return;
        }

        Navigator.pushNamed(context, routeName);
      },
      child: child,
    );
  }
}