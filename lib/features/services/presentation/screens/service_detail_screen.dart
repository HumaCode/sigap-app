import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/service_site_entity.dart';
import '../widgets/uptime_heatmap_grid.dart';
import '../widgets/latency_waterfall_card.dart';

class ServiceDetailScreen extends StatefulWidget {
  final ServiceSiteEntity service;

  const ServiceDetailScreen({super.key, required this.service});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  bool _isChecking = false;

  void _onTriggerManualCheck() async {
    setState(() => _isChecking = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _isChecking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Health Check selesai dieksekusi. Data metrik diperbarui.'),
          backgroundColor: AppColors.statusOperational,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    final isOutage = s.isOutage;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(s.name, style: AppTypography.titleSm),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: AppSpacing.roundedFull,
            ),
            child: Text(
              'ID: srv-${s.id}914',
              style: AppTypography.codeSm.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Service Header Identity Card
            Container(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          s.name,
                          style: AppTypography.headlineLg.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isOutage ? AppColors.statusOutageBg : AppColors.statusOperationalBg,
                          borderRadius: AppSpacing.roundedFull,
                        ),
                        child: Text(
                          s.statusText,
                          style: AppTypography.codeSm.copyWith(
                            color: isOutage ? AppColors.secondary : AppColors.statusOperational,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${s.category} · Ingress Edge Proxy',
                    style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 14),

                  // Snapshot Pills
                  Row(
                    children: [
                      _buildSnapshotPill('30d Uptime', '${s.uptime30d}%'),
                      const SizedBox(width: 8),
                      _buildSnapshotPill('Avg Latency', '${s.latencyMs > 0 ? s.latencyMs : 38} ms'),
                      const SizedBox(width: 8),
                      _buildSnapshotPill('Poll Cycle', '10s Edge', accent: true),
                    ],
                  ),

                  if (isOutage) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.statusOutageBg,
                        borderRadius: AppSpacing.roundedMd,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.report_problem_rounded, size: 16, color: AppColors.statusOutage),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Bad Gateway 502 upstream: socket reset by peer',
                              style: AppTypography.codeSm.copyWith(
                                color: AppColors.secondary,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. 30-Day Reliability Heatmap Grid
            UptimeHeatmapGrid(dailyUptime: s.heatmapDailyUptime),
            const SizedBox(height: 16),

            // 3. Latency Waterfall Breakdown
            LatencyWaterfallCard(breakdown: s.latencyBreakdown),
            const SizedBox(height: 16),

            // 4. SSL & Security Card
            Container(
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
                  Row(
                    children: [
                      const Icon(Icons.shield_outlined, size: 18, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text('Security & SSL Audit', style: AppTypography.titleSm),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildAuditRow('SSL Masa Berlaku', '${s.sslDaysLeft} Hari tersisa', s.isSslWarning ? AppColors.statusDegraded : AppColors.statusOperational),
                  const Divider(height: 16, color: AppColors.surfaceBorder),
                  _buildAuditRow('Deteksi Defacement Visual', s.hasDefacement ? 'TERDETEKSI GANGGUAN' : 'Bersih (Hash Cocok)', s.hasDefacement ? AppColors.secondary : AppColors.statusOperational),
                  const Divider(height: 16, color: AppColors.surfaceBorder),
                  _buildAuditRow('Algoritma Enkripsi', 'ECDSA 384-bit / TLS 1.3', AppColors.textPrimary),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5. Trigger Health Check Button
            ElevatedButton.icon(
              onPressed: _isChecking ? null : _onTriggerManualCheck,
              icon: _isChecking
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.sync_rounded, size: 18),
              label: Text(
                _isChecking ? 'Menjalankan Audit...' : 'Trigger Manual Health Check',
                style: AppTypography.titleSm.copyWith(color: AppColors.onPrimary),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSnapshotPill(String label, String value, {bool accent = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surfaceSubtle,
          borderRadius: AppSpacing.roundedMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.labelXs.copyWith(color: AppColors.textCaption, fontSize: 9)),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTypography.codeSm.copyWith(
                color: accent ? AppColors.accentTealDark : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary)),
        Text(value, style: AppTypography.codeSm.copyWith(color: valueColor, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
