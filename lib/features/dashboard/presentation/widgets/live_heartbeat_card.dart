import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/dashboard_stats_entity.dart';

class LiveHeartbeatCard extends StatelessWidget {
  final List<EdgeHeartbeatEntity> heartbeats;
  final ValueChanged<EdgeHeartbeatEntity>? onEndpointTap;

  const LiveHeartbeatCard({
    super.key,
    required this.heartbeats,
    this.onEndpointTap,
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
                    Icons.sensors_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Live Edge Heartbeats',
                    style: AppTypography.titleSm.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: AppSpacing.roundedSm,
                ),
                child: Text(
                  'Polling 5s',
                  style: AppTypography.codeSm.copyWith(
                    color: AppColors.textCaption,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Heartbeat rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: heartbeats.length,
            separatorBuilder: (_, _) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              final item = heartbeats[index];
              return _buildHeartbeatRow(item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeartbeatRow(EdgeHeartbeatEntity item) {
    final isOutage = item.isDown;

    return InkWell(
      onTap: () => onEndpointTap?.call(item),
      borderRadius: AppSpacing.roundedMd,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isOutage
              ? AppColors.statusOutageBg.withValues(alpha: 0.7)
              : AppColors.surfaceSubtle,
          borderRadius: AppSpacing.roundedMd,
          border: Border.all(
            color: isOutage
                ? AppColors.statusOutage.withValues(alpha: 0.25)
                : AppColors.surfaceBorder.withValues(alpha: 0.6),
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left info
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isOutage ? AppColors.statusOutage : AppColors.statusOperational,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.serviceName,
                          style: AppTypography.codeSm.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceBorder.withValues(alpha: 0.6),
                            borderRadius: AppSpacing.roundedSm,
                          ),
                          child: Text(
                            item.region,
                            style: AppTypography.labelXs.copyWith(
                              fontSize: 9,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.description,
                      style: AppTypography.codeSm.copyWith(
                        color: isOutage ? AppColors.secondary : AppColors.textCaption,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Right status & latency
            Row(
              children: [
                Text(
                  item.latencyMs > 0 ? '${item.latencyMs} ms' : '-- ms',
                  style: AppTypography.codeSm.copyWith(
                    color: isOutage ? AppColors.secondary : AppColors.textSecondary,
                    fontWeight: isOutage ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isOutage ? AppColors.secondary : AppColors.statusOperationalBg,
                    borderRadius: AppSpacing.roundedSm,
                  ),
                  child: Text(
                    item.statusText,
                    style: AppTypography.codeSm.copyWith(
                      color: isOutage ? AppColors.onSecondary : AppColors.statusOperational,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
