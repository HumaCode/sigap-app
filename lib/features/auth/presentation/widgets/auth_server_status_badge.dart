import 'package:flutter/material.dart';
import '../../../../core/constants/api_key.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Telemetry status pill at the bottom of the screen
class AuthServerStatusBadge extends StatelessWidget {
  const AuthServerStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.statusOperational,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'LARAVEL OCTANE DEV ENGINE',
                style: AppTypography.labelXs.copyWith(
                  color: const Color(0xFF475569),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.link_rounded,
                size: 13,
                color: AppColors.textCaption,
              ),
              const SizedBox(width: 4),
              Text(
                ApiKey.baseUrl,
                style: AppTypography.codeSm.copyWith(
                  fontSize: 10.5,
                  color: AppColors.textCaption,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
