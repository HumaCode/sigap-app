import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

class IncidentPulseRibbon extends StatelessWidget {
  final int activeP1Count;
  final int resolvedTodayCount;
  final String mttr;
  final String activeFilter;
  final ValueChanged<String> onFilterChanged;

  const IncidentPulseRibbon({
    super.key,
    required this.activeP1Count,
    required this.resolvedTodayCount,
    required this.mttr,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // SRE Operational Pulse Ribbon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'WAR ROOM LIVE',
                  style: AppTypography.codeSm.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            Text(
              'Auto-syncing every 5s',
              style: AppTypography.codeSm.copyWith(
                color: AppColors.textCaption,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Incident Overview Metrics Bar
        Container(
          padding: const EdgeInsets.all(AppSpacing.spaceMd),
          decoration: BoxDecoration(
            color: AppColors.canvasBg,
            borderRadius: AppSpacing.roundedXl,
            border: Border.all(color: AppColors.surfaceBorder),
            boxShadow: AppSpacing.cardShadow,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: AppSpacing.roundedMd,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.crisis_alert_rounded, size: 14, color: AppColors.secondary),
                        const SizedBox(width: 4),
                        Text(
                          '$activeP1Count Active P1',
                          style: AppTypography.codeSm.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const Text('·', style: TextStyle(color: AppColors.textCaption)),
                    Row(
                      children: [
                        const Icon(Icons.check_circle_outline, size: 14, color: AppColors.statusOperational),
                        const SizedBox(width: 4),
                        Text(
                          '$resolvedTodayCount Resolved Today',
                          style: AppTypography.codeSm.copyWith(
                            color: AppColors.statusOperational,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const Text('·', style: TextStyle(color: AppColors.textCaption)),
                    Text(
                      'MTTR: $mttr',
                      style: AppTypography.codeSm.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Filter Segment Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterPill('All Incidents', 'all'),
                    const SizedBox(width: 6),
                    _buildFilterPill('Critical ($activeP1Count)', 'critical', isCritical: true),
                    const SizedBox(width: 6),
                    _buildFilterPill('High (0)', 'high'),
                    const SizedBox(width: 6),
                    _buildFilterPill('Resolved ($resolvedTodayCount)', 'resolved'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterPill(String label, String key, {bool isCritical = false}) {
    final isSelected = activeFilter == key;

    Color bg;
    Color textColor;

    if (isSelected) {
      bg = isCritical ? AppColors.secondary : AppColors.primary;
      textColor = AppColors.onPrimary;
    } else if (isCritical && activeP1Count > 0) {
      bg = AppColors.statusOutageBg;
      textColor = AppColors.secondary;
    } else {
      bg = AppColors.surfaceSubtle;
      textColor = AppColors.textSecondary;
    }

    return InkWell(
      onTap: () => onFilterChanged(key),
      borderRadius: AppSpacing.roundedFull,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppSpacing.roundedFull,
        ),
        child: Text(
          label,
          style: AppTypography.codeSm.copyWith(
            color: textColor,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
