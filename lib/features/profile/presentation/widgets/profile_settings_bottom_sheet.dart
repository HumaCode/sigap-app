import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/dynamic_island_toast.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../screens/profile_detail_screen.dart';

/// Interactive Profile, Settings, & Biometric Fingerprint Configuration Bottom Sheet
class ProfileSettingsBottomSheet extends StatefulWidget {
  final UserEntity user;

  const ProfileSettingsBottomSheet({super.key, required this.user});

  static Future<void> show(BuildContext context, UserEntity user) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ProfileSettingsBottomSheet(user: user),
    );
  }

  @override
  State<ProfileSettingsBottomSheet> createState() => _ProfileSettingsBottomSheetState();
}

class _ProfileSettingsBottomSheetState extends State<ProfileSettingsBottomSheet> {
  final SecureStorageService _secureStorage = SecureStorageService();
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _isBiometricEnabled = false;
  bool _canCheckBiometrics = false;
  bool _isCheckingHardware = true;
  int _refreshIntervalSeconds = 10;
  bool _hapticEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadInitialSettings();
  }

  Future<void> _loadInitialSettings() async {
    try {
      final isEnabled = await _secureStorage.isBiometricEnabled();
      final canCheck = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (mounted) {
        setState(() {
          _isBiometricEnabled = isEnabled;
          _canCheckBiometrics = canCheck || isDeviceSupported;
          _isCheckingHardware = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isCheckingHardware = false;
        });
      }
    }
  }

  Future<void> _handleToggleBiometric(bool enable) async {
    HapticFeedback.mediumImpact();

    if (enable) {
      // Require fingerprint scan verification before enabling
      try {
        final didAuth = await _localAuth.authenticate(
          localizedReason: 'Pindai sidik jari Anda untuk mengaktifkan login biometrik SIGAP',
          biometricOnly: true,
          persistAcrossBackgrounding: true,
        );

        if (didAuth) {
          await _secureStorage.setBiometricEnabled(true);
          await _secureStorage.saveUsername(widget.user.username.isNotEmpty ? widget.user.username : widget.user.email);
          if (mounted) {
            setState(() => _isBiometricEnabled = true);
            DynamicIslandToast.success(
              context,
              'Login sidik jari berhasil diaktifkan. Anda dapat login instan tanpa mengetik password.',
              title: 'BIOMETRIK DIAKTIFKAN',
            );
          }
        } else {
          if (mounted) {
            DynamicIslandToast.warning(
              context,
              'Verifikasi sidik jari dibatalkan.',
              title: 'BIOMETRIK DIBATALKAN',
            );
          }
        }
      } catch (e) {
        if (mounted) {
          DynamicIslandToast.danger(
            context,
            'Sensor biometrik tidak dapat diakses: ${e.toString().replaceAll("Exception: ", "")}',
            title: 'GAGAL DIAKTIFKAN',
          );
        }
      }
    } else {
      // Disable biometric
      await _secureStorage.setBiometricEnabled(false);
      if (mounted) {
        setState(() => _isBiometricEnabled = false);
        DynamicIslandToast.info(
          context,
          'Login biometrik dinonaktifkan.',
          title: 'BIOMETRIK NONAKTIF',
        );
      }
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 22),
            ),
            const SizedBox(width: 12),
            const Text(
              'Konfirmasi Logout',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari sesi SRE ini? Anda harus melakukan autentikasi ulang untuk masuk kembali.',
          style: TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Close bottom sheet
              context.read<AuthCubit>().logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text('Ya, Logout', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top drag indicator pill
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // User Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFF8FAFC),
                      AppColors.mintBadgeTint.withValues(alpha: 0.25),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    // Avatar with status
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00685F), Color(0xFF14B8A6)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              widget.user.name.isNotEmpty ? widget.user.name[0].toUpperCase() : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppColors.statusOperational,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // User Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  widget.user.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.titleSm.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.mintBadgeTint,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  widget.user.primaryRole.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F766E),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.user.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySm.copyWith(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // View Detail Button
                    IconButton.filledTonal(
                      onPressed: () {
                        Navigator.pop(context); // Close bottom sheet
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileDetailScreen(user: widget.user),
                          ),
                        );
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      tooltip: 'Lihat Detail Profil',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section: Keamanan & Biometrik
              const Text(
                'KEAMANAN & AUTENTIKASI',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 10),

              // Biometric Fingerprint Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isBiometricEnabled
                        ? AppColors.primary.withValues(alpha: 0.4)
                        : const Color(0xFFE2E8F0),
                    width: _isBiometricEnabled ? 1.4 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isBiometricEnabled
                          ? AppColors.primary.withValues(alpha: 0.06)
                          : const Color(0xFF0F172A).withValues(alpha: 0.02),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: _isBiometricEnabled
                                ? AppColors.mintBadgeTint
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _isBiometricEnabled
                                  ? const Color(0xFF99F6E4)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Icon(
                            Icons.fingerprint_rounded,
                            size: 24,
                            color: _isBiometricEnabled
                                ? AppColors.primary
                                : const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Login Sidik Jari (Biometrik)',
                                style: AppTypography.titleSm.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _isBiometricEnabled
                                    ? 'Aktif · Akses cepat tanpa ketik password'
                                    : 'Nonaktif · Sentuh untuk menyalakan',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: _isBiometricEnabled
                                      ? const Color(0xFF0D9488)
                                      : const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch.adaptive(
                          value: _isBiometricEnabled,
                          activeTrackColor: AppColors.primary,
                          onChanged: _isCheckingHardware ? null : _handleToggleBiometric,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _canCheckBiometrics
                                ? Icons.verified_user_outlined
                                : Icons.info_outline_rounded,
                            size: 15,
                            color: _canCheckBiometrics
                                ? const Color(0xFF10B981)
                                : const Color(0xFFF59E0B),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _canCheckBiometrics
                                  ? 'Sensor biometrik perangkat terdeteksi & siap digunakan.'
                                  : 'Perangkat sedang mendeteksi hardware sensor sidik jari.',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section: Pengaturan Telemetri & Sistem
              const Text(
                'PENGATURAN MONITORING & APLIKASI',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 10),

              // Settings Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    // Auto-refresh interval
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.sync_rounded, size: 18, color: Color(0xFF475569)),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Interval Auto-Refresh',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                                ),
                                Text(
                                  'Frekuensi polling data telemetri',
                                  style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                                ),
                              ],
                            ),
                          ),
                          DropdownButton<int>(
                            value: _refreshIntervalSeconds,
                            underline: const SizedBox.shrink(),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                            items: const [
                              DropdownMenuItem(value: 5, child: Text('5s', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                              DropdownMenuItem(value: 10, child: Text('10s', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                              DropdownMenuItem(value: 30, child: Text('30s', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _refreshIntervalSeconds = val);
                                DynamicIslandToast.info(context, 'Interval polling diubah ke ${val}s');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),

                    // Haptic vibration feedback
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.vibration_rounded, size: 18, color: Color(0xFF475569)),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Getaran Haptic SRE',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                                ),
                                Text(
                                  'Feedback sentuhan saat insiden & quick ping',
                                  style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                                ),
                              ],
                            ),
                          ),
                          Switch.adaptive(
                            value: _hapticEnabled,
                            activeTrackColor: AppColors.primary,
                            onChanged: (val) {
                              HapticFeedback.lightImpact();
                              setState(() => _hapticEnabled = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Logout Action Button
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _confirmLogout,
                    borderRadius: BorderRadius.circular(16),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 19),
                          SizedBox(width: 8),
                          Text(
                            'Logout dari Akun SRE',
                            style: TextStyle(
                              color: Color(0xFFDC2626),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
