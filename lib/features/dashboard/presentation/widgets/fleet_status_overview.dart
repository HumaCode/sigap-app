import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

class FleetStatusOverview extends StatelessWidget {
  final int operationalCount;
  final int outageCount;
  final int degradedCount;
  final ValueChanged<String>? onFilterSelect;

  const FleetStatusOverview({
    super.key,
    required this.operationalCount,
    required this.outageCount,
    required this.degradedCount,
    this.onFilterSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Operational Card
        Expanded(
          child: _buildStatusCard(
            title: 'ACTIVE',
            count: operationalCount,
            subtitle: 'Operational',
            bgColor: AppColors.statusOperationalBg,
            accentColor: AppColors.statusOperational,
            onTap: () => onFilterSelect?.call('operational'),
          ),
        ),
        const SizedBox(width: 8),

        // Outage Card
        Expanded(
          child: _buildStatusCard(
            title: 'DOWN',
            count: outageCount,
            subtitle: 'Outage',
            bgColor: AppColors.statusOutageBg,
            accentColor: AppColors.secondary,
            isAlert: true,
            onTap: () => onFilterSelect?.call('outage'),
          ),
        ),
        const SizedBox(width: 8),

        // Degraded Card
        Expanded(
          child: _buildStatusCard(
            title: 'WARN',
            count: degradedCount,
            subtitle: 'Degraded',
            bgColor: AppColors.statusDegradedBg,
            accentColor: AppColors.statusDegraded,
            onTap: () => onFilterSelect?.call('degraded'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard({
    required String title,
    required int count,
    required String subtitle,
    required Color bgColor,
    required Color accentColor,
    bool isAlert = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.roundedXl,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppSpacing.roundedXl,
          border: Border.all(
            color: isAlert ? AppColors.statusOutage.withValues(alpha: 0.3) : Colors.transparent,
          ),
          boxShadow: AppSpacing.cardShadow,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: AppTypography.codeSm.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '$count',
              style: AppTypography.headlineLg.copyWith(
                color: accentColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTypography.labelXs.copyWith(
                color: AppColors.textSecondary,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
