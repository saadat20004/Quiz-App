import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_title.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/admin_sidebar.dart';
import '../../../shared/widgets/admin_top_bar.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final List<_AdminUserItem> _users = [
    const _AdminUserItem(
      fullName: 'Saadat Sohail',
      email: 'saadat@example.com',
      mobile: '03001234567',
      role: 'Participant',
      isActive: true,
    ),
    const _AdminUserItem(
      fullName: 'Ayesha Noor',
      email: 'ayesha@example.com',
      mobile: '03004561234',
      role: 'Participant',
      isActive: true,
    ),
    const _AdminUserItem(
      fullName: 'Muhammad Bilal',
      email: 'bilal@example.com',
      mobile: '03111234567',
      role: 'Participant',
      isActive: false,
    ),
    const _AdminUserItem(
      fullName: 'Admin User',
      email: 'admin@example.com',
      mobile: '03219876543',
      role: 'Admin',
      isActive: true,
    ),
  ];

  void _toggleUserStatus(int index) {
    setState(() {
      _users[index] = _users[index].copyWith(isActive: !_users[index].isActive);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _users[index].isActive
              ? 'User activated successfully'
              : 'User deactivated successfully',
        ),
      ),
    );
  }

  void _showEditUserDialog(BuildContext context, int index) {
    final user = _users[index];

    final nameController = TextEditingController(text: user.fullName);
    final emailController = TextEditingController(text: user.email);
    final mobileController = TextEditingController(text: user.mobile);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: mobileController,
                decoration: const InputDecoration(labelText: 'Mobile'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _users[index] = _users[index].copyWith(
                    fullName: nameController.text.trim(),
                    email: emailController.text.trim(),
                    mobile: mobileController.text.trim(),
                  );
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User updated successfully')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showUserPerformance(BuildContext context, _AdminUserItem user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${user.fullName} Performance'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _PerfRow(label: 'Total Attempts', value: '24'),
              _PerfRow(label: 'Average Score', value: '84%'),
              _PerfRow(label: 'Best Score', value: '96%'),
              _PerfRow(label: 'Completed Quizzes', value: '18'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final totalUsers = _users.length;
    final activeUsers = _users.where((u) => u.isActive).length;
    final inactiveUsers = totalUsers - activeUsers;
    final adminUsers = _users.where((u) => u.role == 'Admin').length;

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
              const AdminSidebar(selectedRoute: AppRoutes.manageUsers),
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
                      const AdminTopBar(hintText: 'Search users...'),
                      const SizedBox(height: AppSizes.xl),
                      const SectionTitle(
                        title: 'Manage Users',
                        subtitle:
                            'Review participant accounts, roles, and account status.',
                      ),
                      const SizedBox(height: AppSizes.lg),
                      Row(
                        children: [
                          Expanded(
                            child: _AdminSummaryCard(
                              title: 'Total Users',
                              value: '$totalUsers',
                              icon: Icons.people_outline,
                              iconColor: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: AppSizes.md),
                          Expanded(
                            child: _AdminSummaryCard(
                              title: 'Active Users',
                              value: '$activeUsers',
                              icon: Icons.check_circle_outline,
                              iconColor: AppColors.success,
                            ),
                          ),
                          const SizedBox(width: AppSizes.md),
                          Expanded(
                            child: _AdminSummaryCard(
                              title: 'Inactive Users',
                              value: '$inactiveUsers',
                              icon: Icons.pause_circle_outline,
                              iconColor: AppColors.warning,
                            ),
                          ),
                          const SizedBox(width: AppSizes.md),
                          Expanded(
                            child: _AdminSummaryCard(
                              title: 'Admin Accounts',
                              value: '$adminUsers',
                              icon: Icons.admin_panel_settings_outlined,
                              iconColor: AppColors.info,
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
                              title: 'Users Directory',
                              subtitle:
                                  'All registered users available in the system.',
                            ),
                            const SizedBox(height: AppSizes.lg),
                            _buildHeaderRow(context),
                            const SizedBox(height: AppSizes.md),
                            ...List.generate(_users.length, (index) {
                              final user = _users[index];
                              return Column(
                                children: [
                                  _AdminUserRow(
                                    user: user,
                                    onEdit: () =>
                                        _showEditUserDialog(context, index),
                                    onToggleStatus: () =>
                                        _toggleUserStatus(index),
                                    onViewPerformance: () =>
                                        _showUserPerformance(context, user),
                                  ),
                                  if (index != _users.length - 1)
                                    Divider(
                                      color: isDark
                                          ? AppColors.darkBorder
                                          : AppColors.lightBorder,
                                      height: 24,
                                    ),
                                ],
                              );
                            }),
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

  Widget _buildHeaderRow(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700);

    return Row(
      children: [
        Expanded(flex: 3, child: Text('User', style: style)),
        Expanded(flex: 2, child: Text('Contact', style: style)),
        Expanded(child: Text('Role', style: style)),
        Expanded(child: Text('Status', style: style)),
        Expanded(flex: 2, child: Text('Actions', style: style)),
      ],
    );
  }
}

class _PerfRow extends StatelessWidget {
  final String label;
  final String value;

  const _PerfRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _AdminSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _AdminSummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.14),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminUserRow extends StatelessWidget {
  final _AdminUserItem user;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;
  final VoidCallback onViewPerformance;

  const _AdminUserRow({
    required this.user,
    required this.onEdit,
    required this.onToggleStatus,
    required this.onViewPerformance,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: const Icon(Icons.person_outline, color: Colors.white),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            user.mobile,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: (user.role == 'Admin' ? AppColors.info : AppColors.primary)
                  .withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              user.role,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: user.role == 'Admin'
                    ? AppColors.info
                    : AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: (user.isActive ? AppColors.success : AppColors.warning)
                  .withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              user.isActive ? 'Active' : 'Inactive',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: user.isActive ? AppColors.success : AppColors.warning,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ActionIconButton(
                icon: Icons.edit_outlined,
                tooltip: 'Edit user',
                onTap: onEdit,
              ),
              _ActionIconButton(
                icon: user.isActive
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
                tooltip: user.isActive ? 'Deactivate user' : 'Activate user',
                onTap: onToggleStatus,
              ),
              _ActionIconButton(
                icon: Icons.bar_chart_outlined,
                tooltip: 'View performance',
                onTap: onViewPerformance,
                color: AppColors.info,
                borderColor: isDark
                    ? AppColors.darkBorder
                    : AppColors.lightBorder,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color? color;
  final Color? borderColor;

  const _ActionIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  borderColor ??
                  (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          ),
          child: Icon(icon, color: color ?? AppColors.primary, size: 20),
        ),
      ),
    );
  }
}

class _AdminUserItem {
  final String fullName;
  final String email;
  final String mobile;
  final String role;
  final bool isActive;

  const _AdminUserItem({
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.role,
    required this.isActive,
  });

  _AdminUserItem copyWith({
    String? fullName,
    String? email,
    String? mobile,
    String? role,
    bool? isActive,
  }) {
    return _AdminUserItem(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }
}
