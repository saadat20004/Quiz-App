import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/section_title.dart';
import '../../../shared/widgets/user_sidebar.dart';
import '../../../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              const UserSidebar(selectedRoute: AppRoutes.profile),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _ProfileTopBar(),
                      const SizedBox(height: AppSizes.xl),
                      const SectionTitle(
                        title: 'Profile',
                        subtitle:
                            'Manage your personal information and account settings.',
                      ),
                      const SizedBox(height: AppSizes.lg),
                      _buildProfileHeader(context),
                      const SizedBox(height: AppSizes.lg),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                _PersonalInfoCard(),
                                SizedBox(height: AppSizes.lg),
                                _PasswordCard(),
                              ],
                            ),
                          ),
                          SizedBox(width: AppSizes.lg),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                _ProfileStatsCard(),
                                SizedBox(height: AppSizes.lg),
                                _PreferencesCard(),
                              ],
                            ),
                          ),
                        ],
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

  Widget _buildProfileHeader(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.person, size: 48, color: Colors.white),
          ),
          const SizedBox(width: AppSizes.lg),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Asim Hafeez',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: AppSizes.xs),
                Text(
                  'Participant Account',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSizes.sm),
                Text(
                  'Manage your details, preferences, and password settings here.',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.md),
          AppButton(
            text: 'Upload Photo',
            isFullWidth: false,
            isOutlined: true,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Photo upload will be connected later'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileTopBar extends StatelessWidget {
  const _ProfileTopBar();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        const Expanded(
          child: AppTextField(
            hintText: 'Search settings or profile fields...',
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

class _PersonalInfoCard extends StatelessWidget {
  const _PersonalInfoCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Personal Information',
            subtitle: 'Update your basic details',
          ),
          const SizedBox(height: AppSizes.lg),
          const AppTextField(
            hintText: 'Full Name',
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: AppSizes.md),
          const AppTextField(
            hintText: 'Email Address',
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: AppSizes.md),
          const AppTextField(
            hintText: 'Mobile Number',
            prefixIcon: Icons.phone_outlined,
          ),
          const SizedBox(height: AppSizes.md),
          const AppTextField(
            hintText: 'Username',
            prefixIcon: Icons.alternate_email,
          ),
          const SizedBox(height: AppSizes.lg),
          AppButton(
            text: 'Save Changes',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PasswordCard extends StatelessWidget {
  const _PasswordCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Change Password',
            subtitle: 'Keep your account secure',
          ),
          const SizedBox(height: AppSizes.lg),
          const AppTextField(
            hintText: 'Current Password',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
          ),
          const SizedBox(height: AppSizes.md),
          const AppTextField(
            hintText: 'New Password',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
          ),
          const SizedBox(height: AppSizes.md),
          const AppTextField(
            hintText: 'Confirm New Password',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
          ),
          const SizedBox(height: AppSizes.lg),
          AppButton(
            text: 'Update Password',
            isOutlined: true,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password updated successfully')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileStatsCard extends StatelessWidget {
  const _ProfileStatsCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle(
            title: 'Account Stats',
            subtitle: 'Your quiz activity summary',
          ),
          SizedBox(height: AppSizes.lg),
          _ProfileStatRow(label: 'Total Attempts', value: '24'),
          SizedBox(height: AppSizes.md),
          _ProfileStatRow(label: 'Average Score', value: '84%'),
          SizedBox(height: AppSizes.md),
          _ProfileStatRow(label: 'Best Score', value: '96%'),
          SizedBox(height: AppSizes.md),
          _ProfileStatRow(label: 'Completed Quizzes', value: '18'),
          SizedBox(height: AppSizes.md),
          _ProfileStatRow(label: 'Pending Quizzes', value: '6'),
        ],
      ),
    );
  }
}

class _PreferencesCard extends StatelessWidget {
  const _PreferencesCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle(
            title: 'Preferences',
            subtitle: 'Manage your interface settings',
          ),
          SizedBox(height: AppSizes.lg),
          _PreferenceRow(
            icon: Icons.dark_mode_outlined,
            title: 'Theme Mode',
            value: 'Light / Dark',
          ),
          SizedBox(height: AppSizes.md),
          _PreferenceRow(
            icon: Icons.notifications_none_outlined,
            title: 'Notifications',
            value: 'Enabled',
          ),
          SizedBox(height: AppSizes.md),
          _PreferenceRow(
            icon: Icons.language_outlined,
            title: 'Language',
            value: 'English',
          ),
        ],
      ),
    );
  }
}

class _ProfileStatRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _PreferenceRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
