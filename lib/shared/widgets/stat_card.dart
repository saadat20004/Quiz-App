import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/widgets/app_card.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String changeText;
  final IconData icon;
  final Color iconColor;
  final bool isPositive;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.changeText,
    required this.icon,
    required this.iconColor,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: AppSizes.iconLg,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: (isPositive ? AppColors.success : AppColors.danger)
                  .withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? AppColors.success : AppColors.danger,
                  size: AppSizes.iconSm,
                ),
                const SizedBox(width: AppSizes.xs),
                Text(
                  changeText,
                  style: TextStyle(
                    color: isPositive ? AppColors.success : AppColors.danger,
                    fontWeight: FontWeight.w600,
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