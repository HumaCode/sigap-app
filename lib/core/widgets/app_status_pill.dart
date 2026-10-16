import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';

enum StatusType { operational, outage, degraded, info }

/// Reusable status indicator pill with dot beacon
class AppStatusPill extends StatelessWidget {
  final String label;
  final StatusType type;
  final bool isAnimated;

  const AppStatusPill({
    super.key,
    required this.label,
    this.type = StatusType.operational,
    this.isAnimated = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    Color dotColor;

    switch (type) {
      case StatusType.operational:
        bgColor = AppColors.statusOperationalBg;
        textColor = AppColors.statusOperational;
        dotColor = AppColors.statusOperational;
        break;
      case StatusType.outage:
        bgColor = AppColors.statusOutageBg;
        textColor = AppColors.statusOutage;
        dotColor = AppColors.statusOutage;
        break;
      case StatusType.degraded:
        bgColor = AppColors.statusDegradedBg;
        textColor = AppColors.statusDegraded;
        dotColor = AppColors.statusDegraded;
        break;
      case StatusType.info:
        bgColor = AppColors.surfaceContainer;
        textColor = AppColors.primary;
        dotColor = AppColors.primary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppSpacing.roundedFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTypography.codeSm.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
