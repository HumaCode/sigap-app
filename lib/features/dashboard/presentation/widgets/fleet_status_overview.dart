import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

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
            title: 'OPERATIONAL',
            count: operationalCount,
            subtitle: 'Kondisi Normal',
            icon: Icons.check_circle_rounded,
            bgColor: const Color(0xFFF0FDF4),
            borderColor: const Color(0xFFBBF7D0),
            accentColor: AppColors.statusOperational,
            onTap: () => onFilterSelect?.call('operational'),
          ),
        ),
        const SizedBox(width: 10),

        // Outage Card
        Expanded(
          child: _buildStatusCard(
            title: 'OUTAGE',
            count: outageCount,
            subtitle: 'Insiden Kritis',
            icon: Icons.cancel_rounded,
            bgColor: const Color(0xFFFEF2F2),
            borderColor: const Color(0xFFFECACA),
            accentColor: AppColors.statusOutage,
            isAlert: outageCount > 0,
            onTap: () => onFilterSelect?.call('outage'),
          ),
        ),
        const SizedBox(width: 10),

        // Degraded Card
        Expanded(
          child: _buildStatusCard(
            title: 'DEGRADED',
            count: degradedCount,
            subtitle: 'Latensi Tinggi',
            icon: Icons.warning_rounded,
            bgColor: const Color(0xFFFFFBEB),
            borderColor: const Color(0xFFFDE68A),
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
    required IconData icon,
    required Color bgColor,
    required Color borderColor,
    required Color accentColor,
    bool isAlert = false,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isAlert ? AppColors.statusOutage : borderColor,
              width: isAlert ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isAlert
                    ? AppColors.statusOutage.withValues(alpha: 0.15)
                    : const Color(0xFF0F172A).withValues(alpha: 0.03),
                blurRadius: isAlert ? 12 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // Icon Badge in Tinted Squircle
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 8),

              // Count Number
              Text(
                '$count',
                style: AppTypography.headlineLg.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 2),

              // Status Title
              Text(
                title,
                style: AppTypography.codeSm.copyWith(
                  color: const Color(0xFF334155),
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 1),

              // Subtitle
              Text(
                subtitle,
                style: AppTypography.labelXs.copyWith(
                  color: AppColors.textCaption,
                  fontSize: 9,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
