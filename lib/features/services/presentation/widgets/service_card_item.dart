import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/service_site_entity.dart';

class ServiceCardItem extends StatelessWidget {
  final ServiceSiteEntity service;
  final VoidCallback onTap;
  final VoidCallback onQuickPing;

  const ServiceCardItem({
    super.key,
    required this.service,
    required this.onTap,
    required this.onQuickPing,
  });

  @override
  Widget build(BuildContext context) {
    final isOutage = service.isOutage;
    final isSslWarning = service.isSslWarning;

    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.roundedXl,
      child: Container(
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
                // Left status strip
                Container(
                  width: 4.5,
                  color: isOutage ? AppColors.secondary : AppColors.statusOperational,
                ),

                // Main Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.spaceLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Row: Title, Category & Status Badge
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          service.name,
                                          style: AppTypography.titleSm.copyWith(
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.open_in_new,
                                        size: 13,
                                        color: AppColors.textCaption,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    service.category,
                                    style: AppTypography.codeSm.copyWith(
                                      color: AppColors.textCaption,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Status badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isOutage
                                    ? AppColors.statusOutageBg
                                    : AppColors.statusOperationalBg,
                                borderRadius: AppSpacing.roundedFull,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: isOutage ? AppColors.secondary : AppColors.statusOperational,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    service.statusText,
                                    style: AppTypography.codeSm.copyWith(
                                      color: isOutage ? AppColors.secondary : AppColors.statusOperational,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Key Metrics Row
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSubtle,
                            borderRadius: AppSpacing.roundedLg,
                          ),
                          child: Row(
                            children: [
                              // Response Latency
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'RESPONSE LATENCY',
                                      style: AppTypography.labelXs.copyWith(
                                        color: AppColors.textCaption,
                                        fontSize: 9,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isOutage ? 'TIMEOUT / Fail' : '${service.latencyMs} ms',
                                      style: AppTypography.codeMd.copyWith(
                                        color: isOutage ? AppColors.secondary : AppColors.accentTealDark,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // TLS/SSL Cert
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'TLS / SSL CERT',
                                      style: AppTypography.labelXs.copyWith(
                                        color: AppColors.textCaption,
                                        fontSize: 9,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isSslWarning ? '${service.sslDaysLeft}d left ⚠️' : '${service.sslDaysLeft}d valid',
                                      style: AppTypography.codeMd.copyWith(
                                        color: isSslWarning ? AppColors.statusDegraded : AppColors.textSecondary,
                                        fontWeight: isSslWarning ? FontWeight.w700 : FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Bottom Row: Region Status & Quick Ping
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    isOutage ? Icons.report_problem_outlined : Icons.check_circle_outline,
                                    size: 14,
                                    color: isOutage ? AppColors.secondary : AppColors.statusOperational,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      service.regionStatus,
                                      style: AppTypography.codeSm.copyWith(
                                        color: isOutage ? AppColors.secondary : AppColors.textSecondary,
                                        fontWeight: isOutage ? FontWeight.w700 : FontWeight.w500,
                                        fontSize: 10,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Quick Ping button
                            ElevatedButton.icon(
                              onPressed: onQuickPing,
                              icon: const Icon(Icons.bolt, size: 14),
                              label: Text(
                                'Quick Ping',
                                style: AppTypography.codeSm.copyWith(
                                  color: AppColors.onPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isOutage ? AppColors.secondary : AppColors.primary,
                                foregroundColor: AppColors.onPrimary,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppSpacing.roundedMd,
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
      ),
    );
  }
}
