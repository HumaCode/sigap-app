import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

class UptimeHeatmapGrid extends StatelessWidget {
  final List<double> dailyUptime; // 30 items

  const UptimeHeatmapGrid({
    super.key,
    required this.dailyUptime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.canvasBg,
        borderRadius: AppSpacing.roundedXl,
        border: Border.all(color: AppColors.surfaceBorder),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '30-Day Reliability Heatmap',
                    style: AppTypography.titleSm.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '30 Days Ago – Today',
                style: AppTypography.codeSm.copyWith(
                  color: AppColors.textCaption,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 6 cols x 5 rows grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 30,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 1.4,
            ),
            itemBuilder: (context, index) {
              final val = index < dailyUptime.length ? dailyUptime[index] : 100.0;
              Color bg;
              String label;

              if (val == 0.0) {
                bg = AppColors.secondary;
                label = 'FAIL';
              } else if (val < 99.9) {
                bg = AppColors.statusDegraded;
                label = val.toStringAsFixed(1);
              } else {
                bg = AppColors.statusOperational;
                label = '100';
              }

              return Container(
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: AppSpacing.roundedSm,
                ),
                child: Center(
                  child: Text(
                    label,
                    style: AppTypography.codeSm.copyWith(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegendItem(AppColors.statusOperational, 'Operational (>99.9%)'),
              _buildLegendItem(AppColors.statusDegraded, 'Degraded'),
              _buildLegendItem(AppColors.secondary, 'Downtime'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppSpacing.roundedSm,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTypography.codeSm.copyWith(
            color: AppColors.textSecondary,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}
