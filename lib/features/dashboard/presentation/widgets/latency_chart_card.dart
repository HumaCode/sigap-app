import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

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
                        'EDGE RESPONSE',
                        style: AppTypography.labelXs.copyWith(
                          color: AppColors.textCaption,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.mintBadgeTint,
                          borderRadius: AppSpacing.roundedSm,
                        ),
                        child: Text(
                          'p90',
                          style: AppTypography.labelXs.copyWith(
                            color: AppColors.accentTealDark,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$currentLatencyMs ',
                              style: AppTypography.headlineLg.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: 'ms',
                              style: AppTypography.codeSm.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.statusOperationalBg,
                          borderRadius: AppSpacing.roundedSm,
                        ),
                        child: Text(
                          '-8ms (-16%)',
                          style: AppTypography.codeSm.copyWith(
                            color: AppColors.statusOperational,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Time interval toggles
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: AppSpacing.roundedMd,
                  border: Border.all(color: AppColors.surfaceBorder, width: 0.8),
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
          const SizedBox(height: 16),

          // Area Line Chart
          SizedBox(
            height: 110,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.surfaceBorder,
                    strokeWidth: 0.8,
                    dashArray: [3, 3],
                  ),
                ),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (latencyPoints.length - 1).toDouble(),
                minY: 10,
                maxY: 80,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      latencyPoints.length,
                      (i) => FlSpot(i.toDouble(), latencyPoints[i]),
                    ),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppColors.primary,
                    barWidth: 2.2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, barData) => spot.x == barData.spots.last.x,
                      getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.primary,
                        strokeWidth: 2,
                        strokeColor: AppColors.canvasBg,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.25),
                          AppColors.primary.withValues(alpha: 0.0),
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
          const SizedBox(height: 12),

          // Detailed Percentiles Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle.withValues(alpha: 0.7),
              borderRadius: AppSpacing.roundedMd,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPercentileItem('MIN', '28ms', AppColors.textPrimary),
                _buildPercentileItem('AVG', '${currentLatencyMs}ms', AppColors.textPrimary),
                _buildPercentileItem('P95', '64ms', AppColors.statusDegraded),
                _buildPercentileItem('P99', '89ms', AppColors.secondary),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: AppSpacing.roundedSm,
        ),
        child: Text(
          label,
          style: AppTypography.codeSm.copyWith(
            color: isSelected ? AppColors.onPrimary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 10,
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
            fontSize: 9,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.codeSm.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
