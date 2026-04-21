import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/section_title.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/user_sidebar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
              const UserSidebar(
                selectedRoute: AppRoutes.settings,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SettingsTopBar(),
                      const SizedBox(height: AppSizes.xl),
                      const SectionTitle(
                        title: 'Settings',
                        subtitle:
                            'Manage your preferences, notifications, theme, and account actions.',
                      ),
                      const SizedBox(height: AppSizes.lg),
                      _buildSettingsContent(context),
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

  Widget _buildSettingsContent(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _AppearanceCard(),
              SizedBox(height: AppSizes.lg),
              _NotificationsCard(),
              SizedBox(height: AppSizes.lg),
              _LanguageCard(),
            ],
          ),
        ),
        SizedBox(width: AppSizes.lg),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _AccountActionsCard(),
              SizedBox(height: AppSizes.lg),
              _AppInfoCard(),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTopBar extends StatelessWidget {
  const _SettingsTopBar();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        const Expanded(
          child: AppTextField(
            hintText: 'Search settings...',
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
            tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
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

class _AppearanceCard extends StatelessWidget {
  const _AppearanceCard();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Appearance',
            subtitle: 'Customize how the app looks',
          ),
          const SizedBox(height: AppSizes.lg),
          _SettingRow(
            icon: Icons.palette_outlined,
            title: 'Theme Mode',
            subtitle: isDark ? 'Dark mode is active' : 'Light mode is active',
            trailing: Switch(
              value: isDark,
              onChanged: (_) {
                appThemeController.toggleTheme();
              },
              activeColor: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          const _SettingRow(
            icon: Icons.blur_on_outlined,
            title: 'Modern Effects',
            subtitle: 'Glass and gradient UI styling enabled',
            trailing: Icon(
              Icons.check_circle,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsCard extends StatelessWidget {
  const _NotificationsCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle(
            title: 'Notifications',
            subtitle: 'Choose what you want to receive',
          ),
          SizedBox(height: AppSizes.lg),
          _SettingRow(
            icon: Icons.notifications_none_outlined,
            title: 'Quiz Reminders',
            subtitle: 'Get notified before your scheduled quiz',
            trailing: Icon(
              Icons.toggle_on,
              color: AppColors.primary,
              size: 34,
            ),
          ),
          SizedBox(height: AppSizes.md),
          _SettingRow(
            icon: Icons.emoji_events_outlined,
            title: 'Result Alerts',
            subtitle: 'Receive alerts when results are ready',
            trailing: Icon(
              Icons.toggle_on,
              color: AppColors.primary,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle(
            title: 'Language',
            subtitle: 'App language preferences',
          ),
          SizedBox(height: AppSizes.lg),
          _SettingRow(
            icon: Icons.language_outlined,
            title: 'Current Language',
            subtitle: 'English',
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountActionsCard extends StatelessWidget {
  const _AccountActionsCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Account Actions',
            subtitle: 'Manage your session and account',
          ),
          const SizedBox(height: AppSizes.lg),
          AppButton(
            text: 'Logout',
            icon: Icons.logout,
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
          ),
          const SizedBox(height: AppSizes.md),
          AppButton(
            text: 'Delete Account',
            icon: Icons.delete_outline,
            isOutlined: true,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Delete account will be connected later'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AppInfoCard extends StatelessWidget {
  const _AppInfoCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle(
            title: 'App Info',
            subtitle: 'Current application details',
          ),
          SizedBox(height: AppSizes.lg),
          _InfoRow(label: 'App Name', value: 'Quizzy'),
          SizedBox(height: AppSizes.md),
          _InfoRow(label: 'Version', value: '1.0.0'),
          SizedBox(height: AppSizes.md),
          _InfoRow(label: 'Build', value: 'Frontend Demo'),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.md),
        trailing,
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}