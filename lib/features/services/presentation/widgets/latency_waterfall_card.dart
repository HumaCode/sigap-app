import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/service_site_entity.dart';

class LatencyWaterfallCard extends StatelessWidget {
  final LatencyBreakdownEntity breakdown;

  const LatencyWaterfallCard({
    super.key,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    final total = breakdown.totalMs > 0 ? breakdown.totalMs : 1;

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
                    Icons.waterfall_chart_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Latency Breakdown (Edge to Core)',
                    style: AppTypography.titleSm.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                'Total ${breakdown.totalMs} ms',
                style: AppTypography.codeSm.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Waterfall Steps
          _buildStep('DNS Resolution (Cloudflare Anycast)', breakdown.dnsMs, breakdown.dnsMs / total),
          const SizedBox(height: 10),
          _buildStep('TLS Handshake (TLS 1.3)', breakdown.tlsMs, breakdown.tlsMs / total),
          const SizedBox(height: 10),
          _buildStep('Server Processing (TTFB)', breakdown.ttfbMs, breakdown.ttfbMs / total),
          const SizedBox(height: 10),
          _buildStep('Content Transfer', breakdown.transferMs, breakdown.transferMs / total),
        ],
      ),
    );
  }

  Widget _buildStep(String title, int ms, double fraction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '$ms ms',
              style: AppTypography.codeSm.copyWith(
                color: AppColors.accentTealDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: AppSpacing.roundedFull,
          child: Container(
            height: 6,
            color: AppColors.surfaceContainer,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fraction.clamp(0.05, 1.0),
              child: Container(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
