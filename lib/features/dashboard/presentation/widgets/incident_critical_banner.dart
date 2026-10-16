import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/dashboard_stats_entity.dart';

class IncidentCriticalBanner extends StatelessWidget {
  final ActiveAlertEntity alert;
  final VoidCallback onAcknowledge;
  final VoidCallback onAiTriage;

  const IncidentCriticalBanner({
    super.key,
    required this.alert,
    required this.onAcknowledge,
    required this.onAiTriage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.statusOutageBg,
        borderRadius: AppSpacing.roundedXl,
        boxShadow: AppSpacing.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: AppSpacing.roundedXl,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left crimson alert strip
              Container(
                width: 6,
                color: AppColors.statusOutage,
              ),

              // Banner Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.spaceMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                size: 16,
                                color: AppColors.statusOutage,
                              ),
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.statusOutage.withValues(alpha: 0.15),
                                  borderRadius: AppSpacing.roundedSm,
                                ),
                                child: Text(
                                  alert.severity,
                                  style: AppTypography.labelXs.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            alert.timeAgo,
                            style: AppTypography.codeSm.copyWith(
                              color: AppColors.textCaption,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Title & Description
                      Text(
                        alert.title,
                        style: AppTypography.titleSm.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        alert.description,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Actions Row
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: alert.isAcknowledged ? null : onAcknowledge,
                              style: OutlinedButton.styleFrom(
                                backgroundColor: alert.isAcknowledged
                                    ? AppColors.statusOperationalBg
                                    : AppColors.canvasBg,
                                side: BorderSide(
                                  color: alert.isAcknowledged
                                      ? AppColors.statusOperational
                                      : AppColors.surfaceBorder,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppSpacing.roundedMd,
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: Text(
                                alert.isAcknowledged ? 'Acknowledged' : 'Acknowledge',
                                style: AppTypography.codeSm.copyWith(
                                  color: alert.isAcknowledged
                                      ? AppColors.statusOperational
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onAiTriage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.onPrimary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppSpacing.roundedMd,
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'AI Triage',
                                    style: AppTypography.codeSm.copyWith(
                                      color: AppColors.onPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14,
                                    color: AppColors.onPrimary,
                                  ),
                                ],
                              ),
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
}
