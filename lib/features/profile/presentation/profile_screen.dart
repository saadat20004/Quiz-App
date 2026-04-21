import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/section_title.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/user_sidebar.dart';
import '../../../shared/widgets/user_top_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController =
      TextEditingController(text: 'Asim Hafeez');
  final TextEditingController _emailController =
      TextEditingController(text: 'asim@example.com');
  final TextEditingController _mobileController =
      TextEditingController(text: '03001234567');
  final TextEditingController _usernameController =
      TextEditingController(text: 'asimhafeez');

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _usernameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String field) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $field';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter email';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }

    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter mobile number';
    }
    if (value.trim().length < 10) {
      return 'Mobile number looks too short';
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter new password';
    }
    if (value.trim().length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm password';
    }
    if (value.trim() != _newPasswordController.text.trim()) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _saveProfile() {
    if (_profileFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );
    }
  }

  void _updatePassword() {
    if (_passwordFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully'),
        ),
      );
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                selectedRoute: AppRoutes.profile,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const UserTopBar(
                        hintText: 'Search settings or profile fields...',
                      ),
                      const SizedBox(height: AppSizes.xl),
                      const SectionTitle(
                        title: 'Profile',
                        subtitle:
                            'Manage your personal information and account settings.',
                      ),
                      const SizedBox(height: AppSizes.lg),
                      _buildProfileHeader(),
                      const SizedBox(height: AppSizes.lg),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                _buildPersonalInfoCard(),
                                const SizedBox(height: AppSizes.lg),
                                _buildPasswordCard(),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSizes.lg),
                          const Expanded(
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

  Widget _buildProfileHeader() {
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
            child: const Icon(
              Icons.person,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: AppSizes.lg),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Asim Hafeez',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
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

  Widget _buildPersonalInfoCard() {
    return AppCard(
      child: Form(
        key: _profileFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              title: 'Personal Information',
              subtitle: 'Update your basic details',
            ),
            const SizedBox(height: AppSizes.lg),
            AppTextField(
              hintText: 'Full Name',
              prefixIcon: Icons.person_outline,
              controller: _fullNameController,
              validator: (value) => _validateRequired(value, 'full name'),
            ),
            const SizedBox(height: AppSizes.md),
            AppTextField(
              hintText: 'Email Address',
              prefixIcon: Icons.email_outlined,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),
            const SizedBox(height: AppSizes.md),
            AppTextField(
              hintText: 'Mobile Number',
              prefixIcon: Icons.phone_outlined,
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              validator: _validateMobile,
            ),
            const SizedBox(height: AppSizes.md),
            AppTextField(
              hintText: 'Username',
              prefixIcon: Icons.alternate_email,
              controller: _usernameController,
              validator: (value) => _validateRequired(value, 'username'),
            ),
            const SizedBox(height: AppSizes.lg),
            AppButton(
              text: 'Save Changes',
              onPressed: _saveProfile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordCard() {
    return AppCard(
      child: Form(
        key: _passwordFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              title: 'Change Password',
              subtitle: 'Keep your account secure',
            ),
            const SizedBox(height: AppSizes.lg),
            AppTextField(
              hintText: 'Current Password',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              controller: _currentPasswordController,
              validator: (value) => _validateRequired(value, 'current password'),
            ),
            const SizedBox(height: AppSizes.md),
            AppTextField(
              hintText: 'New Password',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              controller: _newPasswordController,
              validator: _validateNewPassword,
            ),
            const SizedBox(height: AppSizes.md),
            AppTextField(
              hintText: 'Confirm New Password',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              controller: _confirmPasswordController,
              validator: _validateConfirmPassword,
            ),
            const SizedBox(height: AppSizes.lg),
            AppButton(
              text: 'Update Password',
              isOutlined: true,
              onPressed: _updatePassword,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStatsCard extends StatelessWidget {
  const _ProfileStatsCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

  const _ProfileStatRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
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
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}