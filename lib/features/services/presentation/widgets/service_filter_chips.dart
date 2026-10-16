import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

class ServiceFilterChips extends StatelessWidget {
  final String activeFilter;
  final ValueChanged<String> onFilterChanged;
  final int allCount;
  final int operationalCount;
  final int outageCount;
  final int sslCount;

  const ServiceFilterChips({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
    this.allCount = 27,
    this.operationalCount = 24,
    this.outageCount = 1,
    this.sslCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(
            label: 'All',
            filterKey: 'all',
            count: allCount,
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: 'Operational',
            filterKey: 'operational',
            count: operationalCount,
            dotColor: AppColors.statusOperational,
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: 'Outage',
            filterKey: 'outage',
            count: outageCount,
            dotColor: AppColors.secondary,
            isAlert: true,
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: 'SSL Expiring',
            filterKey: 'ssl',
            count: sslCount,
            icon: Icons.lock_clock_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required String filterKey,
    required int count,
    Color? dotColor,
    IconData? icon,
    bool isAlert = false,
  }) {
    final isSelected = activeFilter == filterKey;

    Color bg;
    Color textColor;
    if (isSelected) {
      bg = AppColors.primary;
      textColor = AppColors.onPrimary;
    } else if (isAlert && outageCount > 0) {
      bg = AppColors.statusOutageBg;
      textColor = AppColors.secondary;
    } else {
      bg = AppColors.surfaceSubtle;
      textColor = AppColors.textSecondary;
    }

    return InkWell(
      onTap: () => onFilterChanged(filterKey),
      borderRadius: AppSpacing.roundedFull,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppSpacing.roundedFull,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceBorder,
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dotColor != null) ...[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
            ],
            if (icon != null) ...[
              Icon(icon, size: 13, color: isSelected ? AppColors.onPrimary : AppColors.statusDegraded),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: AppTypography.codeSm.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.25)
                    : AppColors.canvasBg,
                borderRadius: AppSpacing.roundedFull,
              ),
              child: Text(
                '$count',
                style: AppTypography.labelXs.copyWith(
                  color: isSelected ? Colors.white : textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
