import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_title.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/user_sidebar.dart';
import '../../../shared/widgets/user_top_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _quizReminders = true;
  bool _resultAlerts = true;
  bool _marketingEmails = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          gradient: isDark ? AppColors.darkBackgroundGlow : null,
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
                      const UserTopBar(
                        hintText: 'Search settings...',
                      ),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _AppearanceCard(
                onToggleTheme: () {
                  setState(() {
                    appThemeController.toggleTheme();
                  });
                },
              ),
              const SizedBox(height: AppSizes.lg),
              _NotificationsCard(
                quizReminders: _quizReminders,
                resultAlerts: _resultAlerts,
                marketingEmails: _marketingEmails,
                onQuizRemindersChanged: (value) {
                  setState(() {
                    _quizReminders = value;
                  });
                },
                onResultAlertsChanged: (value) {
                  setState(() {
                    _resultAlerts = value;
                  });
                },
                onMarketingEmailsChanged: (value) {
                  setState(() {
                    _marketingEmails = value;
                  });
                },
              ),
              const SizedBox(height: AppSizes.lg),
              const _LanguageCard(),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.lg),
        const Expanded(
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

class _AppearanceCard extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const _AppearanceCard({
    required this.onToggleTheme,
  });

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
          _SettingSwitchRow(
            icon: Icons.palette_outlined,
            title: 'Theme Mode',
            subtitle: isDark ? 'Dark mode is active' : 'Light mode is active',
            value: isDark,
            onChanged: (_) => onToggleTheme(),
          ),
          const SizedBox(height: AppSizes.md),
          const _StaticSettingRow(
            icon: Icons.blur_on_outlined,
            title: 'Modern Effects',
            subtitle: 'Glass and gradient UI styling enabled',
            trailingIcon: Icons.check_circle,
            trailingColor: AppColors.success,
          ),
        ],
      ),
    );
  }
}

class _NotificationsCard extends StatelessWidget {
  final bool quizReminders;
  final bool resultAlerts;
  final bool marketingEmails;
  final ValueChanged<bool> onQuizRemindersChanged;
  final ValueChanged<bool> onResultAlertsChanged;
  final ValueChanged<bool> onMarketingEmailsChanged;

  const _NotificationsCard({
    required this.quizReminders,
    required this.resultAlerts,
    required this.marketingEmails,
    required this.onQuizRemindersChanged,
    required this.onResultAlertsChanged,
    required this.onMarketingEmailsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Notifications',
            subtitle: 'Choose what you want to receive',
          ),
          const SizedBox(height: AppSizes.lg),
          _SettingSwitchRow(
            icon: Icons.notifications_none_outlined,
            title: 'Quiz Reminders',
            subtitle: 'Get notified before your scheduled quiz',
            value: quizReminders,
            onChanged: onQuizRemindersChanged,
          ),
          const SizedBox(height: AppSizes.md),
          _SettingSwitchRow(
            icon: Icons.emoji_events_outlined,
            title: 'Result Alerts',
            subtitle: 'Receive alerts when results are ready',
            value: resultAlerts,
            onChanged: onResultAlertsChanged,
          ),
          const SizedBox(height: AppSizes.md),
          _SettingSwitchRow(
            icon: Icons.mail_outline,
            title: 'Marketing Emails',
            subtitle: 'Receive updates and promotional emails',
            value: marketingEmails,
            onChanged: onMarketingEmailsChanged,
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'Language',
            subtitle: 'App language preferences',
          ),
          SizedBox(height: AppSizes.lg),
          _StaticSettingRow(
            icon: Icons.language_outlined,
            title: 'Current Language',
            subtitle: 'English',
            trailingIcon: Icons.arrow_forward_ios,
            trailingColor: AppColors.primary,
            trailingSize: 16,
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

class _SettingSwitchRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingSwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
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
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}

class _StaticSettingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final IconData trailingIcon;
  final Color trailingColor;
  final double trailingSize;

  const _StaticSettingRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailingIcon,
    required this.trailingColor,
    this.trailingSize = 22,
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
        Icon(
          trailingIcon,
          color: trailingColor,
          size: trailingSize,
        ),
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