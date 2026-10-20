import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Banner status koneksi yang dinamis:
/// - Menampilkan mode Online jika terhubung ke server SRE
/// - Menampilkan mode Offline dengan informasi waktu cache jika koneksi terputus
class ConnectionStatusBanner extends StatelessWidget {
  final bool isOffline;
  final DateTime? cachedAt;

  const ConnectionStatusBanner({
    super.key,
    required this.isOffline,
    this.cachedAt,
  });

  @override
  Widget build(BuildContext context) {
    if (isOffline) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: const BoxDecoration(
          color: AppColors.statusDegradedBg,
          border: Border(
            bottom: BorderSide(color: AppColors.statusDegraded, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 14,
              color: AppColors.tertiary,
            ),
            const SizedBox(width: 8),
            Text(
              cachedAt != null
                  ? 'Mode Offline — Menampilkan cache: ${cachedAt!.hour.toString().padLeft(2, '0')}:${cachedAt!.minute.toString().padLeft(2, '0')}'
                  : 'Mode Offline — Menampilkan data terakhir',
              style: AppTypography.codeSm.copyWith(
                color: AppColors.tertiary,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    }

    // Mode Online / Terhubung
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        border: Border(
          bottom: BorderSide(
            color: AppColors.statusOperational.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.statusOperational,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.cloud_done_rounded,
            size: 14,
            color: Color(0xFF065F46),
          ),
          const SizedBox(width: 6),
          Text(
            'Mode Online — Terhubung ke Server SRE',
            style: AppTypography.codeSm.copyWith(
              color: const Color(0xFF065F46),
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// Backward-compatibility alias
class OfflineBanner extends StatelessWidget {
  final DateTime? cachedAt;

  const OfflineBanner({super.key, this.cachedAt});

  @override
  Widget build(BuildContext context) {
    return ConnectionStatusBanner(
      isOffline: true,
      cachedAt: cachedAt,
    );
  }
}
