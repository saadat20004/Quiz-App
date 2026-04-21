import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/widgets/app_text_field.dart';

class AdminTopBar extends StatelessWidget {
  final String hintText;
  final List<Widget>? actions;
  final TextEditingController? controller;
  final VoidCallback? onSearchChanged;

  const AdminTopBar({
    super.key,
    required this.hintText,
    this.actions,
    this.controller,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: (_) => onSearchChanged?.call(),
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search),
            ),
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
        if (actions != null && actions!.isNotEmpty) ...[
          const SizedBox(width: AppSizes.sm),
          ..._withSpacing(actions!),
        ],
      ],
    );
  }

  List<Widget> _withSpacing(List<Widget> widgets) {
    final List<Widget> items = [];
    for (int i = 0; i < widgets.length; i++) {
      if (i > 0) {
        items.add(const SizedBox(width: AppSizes.sm));
      }
      items.add(widgets[i]);
    }
    return items;
  }
}
