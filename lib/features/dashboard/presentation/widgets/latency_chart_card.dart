import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class LatencyChartCard extends StatelessWidget {
  final int currentLatencyMs;
  final List<double> latencyPoints;
  final String activeRange;
  final ValueChanged<String> onRangeChanged;

  const LatencyChartCard({
    super.key,
    required this.currentLatencyMs,
    required this.latencyPoints,
    required this.activeRange,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final points = latencyPoints.isNotEmpty
        ? latencyPoints
        : const <double>[0, 0, 0, 0, 0, 0, 0, 0];

    final maxVal = points.reduce(math.max);
    final minVal = points.reduce(math.min);
    final chartMaxY = maxVal > 0 ? (maxVal * 1.35).clamp(40.0, 500.0) : 50.0;

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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      Text(
                        'EDGE RESPONSE LATENCY',
                        style: AppTypography.labelXs.copyWith(
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.mintBadgeTint.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'P90',
                          style: AppTypography.labelXs.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 9.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$currentLatencyMs ',
                              style: AppTypography.headlineLg.copyWith(
                                color: const Color(0xFF0F172A),
                                fontWeight: FontWeight.w900,
                                fontSize: 26,
                              ),
                            ),
                            TextSpan(
                              text: 'ms',
                              style: AppTypography.codeSm.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.statusOperationalBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.statusOperational.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.bolt_rounded,
                              size: 13,
                              color: AppColors.statusOperational,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              currentLatencyMs < 100 ? 'Respons Cepat' : 'Degraded',
                              style: AppTypography.codeSm.copyWith(
                                color: const Color(0xFF065F46),
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Time interval selector pills
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildRangeButton('24H', '24h'),
                    _buildRangeButton('7D', '7d'),
                    _buildRangeButton('30D', '30d'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Area Spline Line Chart
          SizedBox(
            height: 125,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: chartMaxY / 3,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: const Color(0xFFE2E8F0),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: math.max((points.length - 1).toDouble(), 1.0),
                minY: 0,
                maxY: chartMaxY,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toInt()} ms',
                          AppTypography.codeSm.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      points.length,
                      (i) => FlSpot(i.toDouble(), points[i]),
                    ),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppColors.primary,
                    barWidth: 2.6,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, barData) =>
                          spot.x == barData.spots.last.x,
                      getDotPainter: (spot, percent, bar, index) =>
                          FlDotCirclePainter(
                        radius: 5,
                        color: AppColors.primary,
                        strokeWidth: 2.5,
                        strokeColor: Colors.white,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accentTeal.withValues(alpha: 0.28),
                          AppColors.accentTeal.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Dynamic Percentiles Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPercentileItem('MINIMUM', '${minVal.toInt()}ms', const Color(0xFF0F172A)),
                Container(height: 20, width: 1, color: const Color(0xFFCBD5E1)),
                _buildPercentileItem('RATA-RATA', '${currentLatencyMs}ms', AppColors.primary),
                Container(height: 20, width: 1, color: const Color(0xFFCBD5E1)),
                _buildPercentileItem(
                  'MAKSIMUM',
                  '${maxVal.toInt()}ms',
                  maxVal > 150 ? AppColors.statusOutage : const Color(0xFF0F172A),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeButton(String label, String value) {
    final isSelected = activeRange == value;
    return GestureDetector(
      onTap: () => onRangeChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.codeSm.copyWith(
            color: isSelected ? AppColors.primary : const Color(0xFF64748B),
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 10.5,
          ),
        ),
      ),
    );
  }

  Widget _buildPercentileItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.labelXs.copyWith(
            color: AppColors.textCaption,
            fontWeight: FontWeight.w700,
            fontSize: 9,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.codeSm.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
