import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

class ReliabilityGaugeCard extends StatelessWidget {
  final double uptimePercentage;
  final String totalHeartbeats;
  final String mttr;

  const ReliabilityGaugeCard({
    super.key,
    required this.uptimePercentage,
    required this.totalHeartbeats,
    required this.mttr,
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
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FLEET STABILITY',
                    style: AppTypography.labelXs.copyWith(
                      color: AppColors.textCaption,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '30-Day Fleet Reliability',
                    style: AppTypography.titleSm.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: AppSpacing.roundedFull,
                  border: Border.all(color: AppColors.surfaceBorder, width: 0.8),
                ),
                child: Text(
                  'Target: 99.90%',
                  style: AppTypography.codeSm.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Custom Radial Progress Gauge
          SizedBox(
            width: 170,
            height: 170,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(160, 160),
                  painter: _RadialGaugePainter(
                    percentage: uptimePercentage,
                    progressColor: AppColors.primary,
                    trackColor: AppColors.surfaceSubtle,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: uptimePercentage.toStringAsFixed(2),
                            style: AppTypography.headlineXl.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextSpan(
                            text: '%',
                            style: AppTypography.titleSm.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.statusOperational,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Within SLA Buffer',
                          style: AppTypography.codeSm.copyWith(
                            color: AppColors.statusOperational,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '14m downtime logged',
                      style: AppTypography.labelXs.copyWith(
                        color: AppColors.textCaption,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Footer Metrics
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle.withValues(alpha: 0.8),
              borderRadius: AppSpacing.roundedLg,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'TOTAL HEARTBEATS',
                        style: AppTypography.labelXs.copyWith(
                          color: AppColors.textCaption,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        totalHeartbeats,
                        style: AppTypography.codeLg.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.arrow_upward, size: 11, color: AppColors.statusOperational),
                          Text(
                            '99.99% valid',
                            style: AppTypography.codeSm.copyWith(
                              color: AppColors.statusOperational,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 36,
                  width: 1,
                  color: AppColors.surfaceBorder,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'MTTR (24H)',
                        style: AppTypography.labelXs.copyWith(
                          color: AppColors.textCaption,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        mttr,
                        style: AppTypography.codeLg.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check, size: 11, color: AppColors.statusOperational),
                          Text(
                            '-2.1m target',
                            style: AppTypography.codeSm.copyWith(
                              color: AppColors.statusOperational,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RadialGaugePainter extends CustomPainter {
  final double percentage;
  final Color progressColor;
  final Color trackColor;

  _RadialGaugePainter({
    required this.percentage,
    required this.progressColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16) / 2;
    const strokeWidth = 11.0;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress Arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RadialGaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}
