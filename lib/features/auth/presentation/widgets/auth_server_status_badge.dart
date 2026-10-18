import 'package:flutter/material.dart';
import '../../../../core/constants/api_key.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/dynamic_island_toast.dart';

/// Telemetry status pill at the bottom of the screen with interactive host switcher
class AuthServerStatusBadge extends StatelessWidget {
  final VoidCallback? onEndpointChanged;

  const AuthServerStatusBadge({super.key, this.onEndpointChanged});

  void _showEndpointSelector(BuildContext context) {
    final options = [
      _EndpointOption(
        title: 'Server Produksi (Live Cloud) · Aktif',
        subtitle: 'https://sigap.humacode.my.id/api/v1/',
        url: ApiKey.productionBaseUrl,
        icon: Icons.cloud_done_rounded,
      ),
      _EndpointOption(
        title: 'Android Emulator (10.0.2.2)',
        subtitle: 'Koneksi default emulator Android ke server PC',
        url: ApiKey.emulatorBaseUrl,
        icon: Icons.phone_android_rounded,
      ),
      _EndpointOption(
        title: 'Localhost (ADB Reverse / Web)',
        subtitle: 'Gunakan jika menggunakan adb reverse port 8000',
        url: ApiKey.localhostBaseUrl,
        icon: Icons.computer_rounded,
      ),
      _EndpointOption(
        title: 'IP Jaringan LAN PC (192.168.1.4)',
        subtitle: 'Bisa diakses dari HP fisik di jaringan Wi-Fi yang sama',
        url: ApiKey.lanBaseUrl,
        icon: Icons.wifi_rounded,
      ),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Pilih Host / Endpoint API',
                style: AppTypography.titleSm.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sesuaikan host API dengan perangkat pengujian Anda.',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              ...options.map((opt) {
                final isSelected = ApiKey.baseUrl == opt.url;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () {
                      ApiKey.baseUrl = opt.url;
                      Navigator.pop(ctx);
                      onEndpointChanged?.call();
                      DynamicIslandToast.info(
                        context,
                        'Endpoint diubah ke: ${opt.url}',
                        title: 'HOST API AKTIF',
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.mintBadgeTint.withValues(alpha: 0.5)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFFE2E8F0),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            opt.icon,
                            color: isSelected
                                ? AppColors.primary
                                : const Color(0xFF64748B),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  opt.title,
                                  style: AppTypography.titleSm.copyWith(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  opt.url,
                                  style: AppTypography.codeSm.copyWith(
                                    fontSize: 10.5,
                                    color: AppColors.textCaption,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primary,
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showEndpointSelector(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
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
                    'LARAVEL DEV ENGINE · TAP TO CHANGE HOST',
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
                    Icons.tune_rounded,
                    size: 12,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    ApiKey.baseUrl,
                    style: AppTypography.codeSm.copyWith(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EndpointOption {
  final String title;
  final String subtitle;
  final String url;
  final IconData icon;

  _EndpointOption({
    required this.title,
    required this.subtitle,
    required this.url,
    required this.icon,
  });
}
