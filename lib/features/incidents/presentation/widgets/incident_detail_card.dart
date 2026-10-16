import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/incident_entity.dart';

class IncidentDetailCard extends StatelessWidget {
  final IncidentEntity incident;

  const IncidentDetailCard({
    super.key,
    required this.incident,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.canvasBg,
        borderRadius: AppSpacing.roundedXl,
        border: Border.all(color: AppColors.surfaceBorder),
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
                color: incident.isCritical ? AppColors.secondary : AppColors.statusDegraded,
              ),

              // Card Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.spaceLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Code Badge & Timestamp
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.statusOutageBg,
                              borderRadius: AppSpacing.roundedFull,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.bolt, size: 14, color: AppColors.secondary),
                                const SizedBox(width: 4),
                                Text(
                                  '${incident.severity.toUpperCase()} · ${incident.incidentCode}',
                                  style: AppTypography.codeSm.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.schedule, size: 13, color: AppColors.textCaption),
                              const SizedBox(width: 4),
                              Text(
                                incident.timeAgo,
                                style: AppTypography.codeSm.copyWith(
                                  color: AppColors.textCaption,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Title & Endpoint
                      Text(
                        incident.title,
                        style: AppTypography.headlineLg.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSubtle,
                          borderRadius: AppSpacing.roundedSm,
                        ),
                        child: Text(
                          incident.endpoint,
                          style: AppTypography.codeSm.copyWith(
                            color: AppColors.accentTealDark,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Live Telemetry Mini Grid
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.statusOutageBg.withValues(alpha: 0.5),
                          borderRadius: AppSpacing.roundedLg,
                        ),
                        child: Row(
                          children: [
                            // Error Rate
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ERROR RATE',
                                    style: AppTypography.labelXs.copyWith(
                                      color: AppColors.textCaption,
                                      fontSize: 9,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Text(
                                        '${incident.errorRate}%',
                                        style: AppTypography.headlineMd.copyWith(
                                          color: AppColors.secondary,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      const Icon(Icons.arrow_upward, size: 14, color: AppColors.secondary),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Affected Users
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'AFFECTED USERS',
                                    style: AppTypography.labelXs.copyWith(
                                      color: AppColors.textCaption,
                                      fontSize: 9,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '~${incident.affectedUsers}',
                                    style: AppTypography.headlineMd.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Blast Radius
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'BLAST RADIUS',
                                    style: AppTypography.labelXs.copyWith(
                                      color: AppColors.textCaption,
                                      fontSize: 9,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    incident.blastRadius,
                                    style: AppTypography.codeSm.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Ingestion Spikes Sparkline Indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSubtle,
                          borderRadius: AppSpacing.roundedMd,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.show_chart_rounded, size: 16, color: AppColors.secondary),
                                const SizedBox(width: 6),
                                Text(
                                  '5xx Ingestion Spikes (15m)',
                                  style: AppTypography.codeSm.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'PEAK 1,240 req/s',
                              style: AppTypography.codeSm.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w700,
                                fontSize: 9,
                              ),
                            ),
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
}
