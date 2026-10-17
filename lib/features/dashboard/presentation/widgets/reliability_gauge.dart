import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class ReliabilityGaugeCard extends StatelessWidget {
  final double uptimePercentage;
  final String totalHeartbeats;
  final String mttr;
  final int totalServices;
  final int operationalCount;
  final int outageCount;

  const ReliabilityGaugeCard({
    super.key,
    required this.uptimePercentage,
    required this.totalHeartbeats,
    required this.mttr,
    this.totalServices = 0,
    this.operationalCount = 0,
    this.outageCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final hasData = totalServices > 0;
    final effectiveUptime = hasData ? uptimePercentage : 0.0;
    final isHealthy = hasData ? (outageCount == 0) : true;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: !hasData
                              ? const Color(0xFF94A3B8)
                              : isHealthy
                                  ? AppColors.statusOperational
                                  : AppColors.statusOutage,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'STABILITAS ARMADA SRE',
                        style: AppTypography.labelXs.copyWith(
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Fleet Reliability SLA',
                    style: AppTypography.titleSm.copyWith(
                      color: const Color(0xFF0F172A),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: !hasData
                      ? const Color(0xFFF1F5F9)
                      : AppColors.mintBadgeTint.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: !hasData
                        ? const Color(0xFFE2E8F0)
                        : AppColors.accentTeal.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      !hasData ? Icons.hourglass_empty_rounded : Icons.verified_outlined,
                      size: 13,
                      color: !hasData ? const Color(0xFF64748B) : AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      !hasData ? 'Standby' : 'Target: 99.90%',
                      style: AppTypography.codeSm.copyWith(
                        color: !hasData ? const Color(0xFF64748B) : AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Custom High-Tech Radial Arc Gauge
          SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glowing background aura (only when data exists and percentage > 0)
                if (hasData && effectiveUptime > 0)
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isHealthy ? AppColors.accentTeal : AppColors.statusOutage)
                              .withValues(alpha: 0.12),
                          blurRadius: 36,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                  ),

                // Radial Painter
                CustomPaint(
                  size: const Size(170, 170),
                  painter: _ModernRadialGaugePainter(
                    percentage: effectiveUptime,
                    isHealthy: isHealthy,
                    hasData: hasData,
                  ),
                ),

                // Metric Content in Center
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: hasData ? effectiveUptime.toStringAsFixed(1) : '0',
                            style: AppTypography.headlineXl.copyWith(
                              fontSize: 32,
                              color: hasData
                                  ? const Color(0xFF0F172A)
                                  : const Color(0xFF94A3B8),
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1.0,
                            ),
                          ),
                          TextSpan(
                            text: '%',
                            style: AppTypography.titleSm.copyWith(
                              color: !hasData
                                  ? const Color(0xFF94A3B8)
                                  : isHealthy
                                      ? AppColors.primary
                                      : AppColors.statusOutage,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: !hasData
                            ? const Color(0xFFF1F5F9)
                            : isHealthy
                                ? AppColors.statusOperationalBg
                                : AppColors.statusOutageBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: !hasData
                                  ? const Color(0xFF94A3B8)
                                  : isHealthy
                                      ? AppColors.statusOperational
                                      : AppColors.statusOutage,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            !hasData
                                ? 'Belum Ada Situs'
                                : isHealthy
                                    ? 'SLA Terpenuhi'
                                    : 'Gangguan Terdeteksi',
                            style: AppTypography.codeSm.copyWith(
                              color: !hasData
                                  ? const Color(0xFF64748B)
                                  : isHealthy
                                      ? const Color(0xFF065F46)
                                      : AppColors.statusOutage,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      !hasData
                          ? 'Input situs untuk hitung uptime'
                          : isHealthy
                              ? '0m downtime terdeteksi'
                              : '$outageCount insiden aktif berjalan',
                      style: AppTypography.labelXs.copyWith(
                        color: AppColors.textCaption,
                        fontSize: 9.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Footer Metrics Pills
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'TOTAL MONITORING',
                        style: AppTypography.labelXs.copyWith(
                          color: AppColors.textCaption,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$totalServices Situs',
                        style: AppTypography.codeLg.copyWith(
                          color: const Color(0xFF0F172A),
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            hasData ? Icons.hub_outlined : Icons.info_outline,
                            size: 11,
                            color: hasData ? AppColors.primary : const Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            hasData ? '24/7 Checked' : 'Data Kosong',
                            style: AppTypography.codeSm.copyWith(
                              color: hasData ? AppColors.primary : const Color(0xFF94A3B8),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(height: 32, width: 1, color: const Color(0xFFE2E8F0)),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'KONDISI NORMAL',
                        style: AppTypography.labelXs.copyWith(
                          color: AppColors.textCaption,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hasData ? '$operationalCount/$totalServices Up' : '0 Up',
                        style: AppTypography.codeLg.copyWith(
                          color: hasData
                              ? AppColors.statusOperational
                              : const Color(0xFF94A3B8),
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            hasData
                                ? Icons.check_circle_outline
                                : Icons.radio_button_unchecked,
                            size: 11,
                            color: hasData
                                ? AppColors.statusOperational
                                : const Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            hasData ? 'Siaga Optimal' : 'Belum Ada Site',
                            style: AppTypography.codeSm.copyWith(
                              color: hasData
                                  ? AppColors.statusOperational
                                  : const Color(0xFF94A3B8),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(height: 32, width: 1, color: const Color(0xFFE2E8F0)),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'GANGGUAN',
                        style: AppTypography.labelXs.copyWith(
                          color: AppColors.textCaption,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$outageCount Insiden',
                        style: AppTypography.codeLg.copyWith(
                          color: outageCount > 0
                              ? AppColors.statusOutage
                              : const Color(0xFF0F172A),
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            outageCount > 0 ? Icons.error_outline : Icons.shield_outlined,
                            size: 11,
                            color: outageCount > 0
                                ? AppColors.statusOutage
                                : AppColors.statusOperational,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            outageCount > 0 ? 'P1 Action' : 'Zero Down',
                            style: AppTypography.codeSm.copyWith(
                              color: outageCount > 0
                                  ? AppColors.statusOutage
                                  : AppColors.statusOperational,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
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

class _ModernRadialGaugePainter extends CustomPainter {
  final double percentage;
  final bool isHealthy;
  final bool hasData;

  _ModernRadialGaugePainter({
    required this.percentage,
    required this.isHealthy,
    required this.hasData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 20) / 2;
    const strokeWidth = 12.0;

    // Track Paint
    final trackPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    if (!hasData || percentage <= 0) return;

    // Progress Arc Paint with Gradient Shader
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = isHealthy
        ? const SweepGradient(
            startAngle: -math.pi / 2,
            endAngle: 3 * math.pi / 2,
            colors: [
              Color(0xFF0D9488),
              Color(0xFF10B981),
              Color(0xFF00685F),
            ],
          )
        : const SweepGradient(
            startAngle: -math.pi / 2,
            endAngle: 3 * math.pi / 2,
            colors: [
              Color(0xFFF59E0B),
              Color(0xFFEF4444),
            ],
          );

    final progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * (percentage.clamp(0.0, 100.0) / 100);

    canvas.drawArc(
      rect,
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ModernRadialGaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.isHealthy != isHealthy ||
        oldDelegate.hasData != hasData;
  }
}
