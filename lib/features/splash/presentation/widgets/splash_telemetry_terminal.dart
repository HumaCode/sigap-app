import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Telemetry boot logs card displayed during splash initialization
class SplashTelemetryTerminal extends StatelessWidget {
  final double progress; // 0.0 to 1.0 over 5 seconds

  const SplashTelemetryTerminal({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final stages = [
      _StageItem('Inisialisasi Telemetry & Hive Cache', 0.15),
      _StageItem('Koneksi Laravel Octane Dev Server', 0.40),
      _StageItem('Sinkronisasi Incident SRE Engine', 0.65),
      _StageItem('Sistem SIGAP Siaga 100% Siap', 0.85),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Bar
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.statusOperational,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'SRE BOOT SEQUENCE',
                style: AppTypography.labelXs.copyWith(
                  color: const Color(0xFF0F172A),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.mintBadgeTint.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: AppTypography.codeSm.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 12),

          // Stage List
          ...stages.map((stage) {
            final isDone = progress >= stage.threshold;
            final isCurrent = !isDone && progress >= (stage.threshold - 0.25);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone
                          ? AppColors.statusOperational
                          : isCurrent
                              ? AppColors.mintBadgeTint
                              : const Color(0xFFF1F5F9),
                      border: Border.all(
                        color: isDone
                            ? AppColors.statusOperational
                            : isCurrent
                                ? AppColors.primary
                                : const Color(0xFFCBD5E1),
                        width: 1.2,
                      ),
                    ),
                    child: Center(
                      child: isDone
                          ? const Icon(
                              Icons.check,
                              size: 11,
                              color: Colors.white,
                            )
                          : isCurrent
                              ? const SizedBox(
                                  width: 8,
                                  height: 8,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    color: AppColors.primary,
                                  ),
                                )
                              : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      stage.title,
                      style: AppTypography.codeSm.copyWith(
                        fontSize: 11.5,
                        color: isDone
                            ? const Color(0xFF0F172A)
                            : isCurrent
                                ? AppColors.primary
                                : const Color(0xFF94A3B8),
                        fontWeight: isDone || isCurrent
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StageItem {
  final String title;
  final double threshold;

  _StageItem(this.title, this.threshold);
}
