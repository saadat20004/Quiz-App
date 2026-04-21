import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/widgets/app_text_field.dart';
import '../../routes/app_routes.dart';

class UserSidebar extends StatelessWidget {
  final String selectedRoute;

  const UserSidebar({super.key, required this.selectedRoute});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          const _BrandHeader(),
          const SizedBox(height: AppSizes.xl),
          const AppTextField(hintText: 'Search', prefixIcon: Icons.search),
          const SizedBox(height: AppSizes.xl),
          _SidebarNavItem(
            icon: Icons.grid_view_rounded,
            title: 'Dashboard',
            routeName: AppRoutes.dashboard,
            selectedRoute: selectedRoute,
          ),
          _SidebarNavItem(
            icon: Icons.quiz_outlined,
            title: 'Quizzes',
            routeName: AppRoutes.quizList,
            selectedRoute: selectedRoute,
          ),
          _SidebarNavItem(
            icon: Icons.history_outlined,
            title: 'History',
            routeName: AppRoutes.history,
            selectedRoute: selectedRoute,
          ),
          _SidebarNavItem(
            icon: Icons.person_outline,
            title: 'Profile',
            routeName: AppRoutes.profile,
            selectedRoute: selectedRoute,
          ),
          const Spacer(),
          _SidebarNavItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            routeName: AppRoutes.settings,
            selectedRoute: selectedRoute,
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
          child: const Icon(Icons.quiz, color: Colors.white),
        ),
        const SizedBox(width: AppSizes.sm),
        const Text(
          'Quizzy',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String routeName;
  final String selectedRoute;
  final bool enabled;

  const _SidebarNavItem({
    required this.icon,
    required this.title,
    required this.routeName,
    required this.selectedRoute,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = selectedRoute == routeName;

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
          Text(
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
        ],
      ),
    );

    if (!enabled || routeName.isEmpty) {
      return Opacity(opacity: 0.8, child: child);
    }

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
