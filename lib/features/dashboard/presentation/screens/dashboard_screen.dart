import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../../core/widgets/modern_loader.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/incident_critical_banner.dart';
import '../widgets/reliability_gauge.dart';
import '../widgets/fleet_status_overview.dart';
import '../widgets/latency_chart_card.dart';
import '../widgets/live_heartbeat_card.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback? onNavigateToIncidents;
  final ValueChanged<String>? onNavigateToServices;

  const DashboardScreen({
    super.key,
    this.onNavigateToIncidents,
    this.onNavigateToServices,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Ambient Background Glow Blob
          Positioned(
            top: -size.width * 0.25,
            right: -size.width * 0.2,
            child: Container(
              width: size.width * 0.85,
              height: size.width * 0.85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.mintBadgeTint.withValues(alpha: 0.6),
                    AppColors.accentTeal.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main Scrollable Content
          BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: ModernLoader(
                      message: 'Mengambil Metrik Dashboard...',
                      subMessage: 'Menghitung skor reliabilitas & latensi',
                    ),
                  ),
                );
              }

              if (state is DashboardLoaded) {
                final stats = state.stats;

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => context.read<DashboardCubit>().refresh(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        ConnectionStatusBanner(
                          isOffline: stats.isFromCache,
                          cachedAt: stats.cachedAt,
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Live Telemetry Banner
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: stats.isFromCache
                                        ? AppColors.statusDegradedBg
                                        : AppColors.statusOperationalBg,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: stats.isFromCache
                                          ? AppColors.statusDegraded
                                              .withValues(alpha: 0.3)
                                          : AppColors.statusOperational
                                              .withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: stats.isFromCache
                                              ? AppColors.statusDegraded
                                              : AppColors.statusOperational,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        stats.isFromCache
                                            ? 'SRE TELEMETRY STREAM OFFLINE · DATA CACHE'
                                            : 'SRE TELEMETRY STREAM ONLINE · 24/7 ACTIVE',
                                        style: AppTypography.labelXs.copyWith(
                                          color: stats.isFromCache
                                              ? AppColors.tertiary
                                              : const Color(0xFF065F46),
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // 1. Critical Incident Banner OR Clean Fleet Status
                              if (stats.criticalAlert != null) ...[
                                IncidentCriticalBanner(
                                  alert: stats.criticalAlert!,
                                  onAcknowledge: () {
                                    context
                                        .read<DashboardCubit>()
                                        .acknowledgeIncident(
                                          stats.criticalAlert!.id,
                                        );
                                  },
                                  onAiTriage: () {
                                    onNavigateToIncidents?.call();
                                  },
                                ),
                                const SizedBox(height: 16),
                              ] else if (stats.totalServices == 0) ...[
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: const Color(0xFFE2E8F0),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: const Color(0xFFCBD5E1),
                                            width: 1,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.info_outline_rounded,
                                          color: Color(0xFF64748B),
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'BELUM ADA SITUS TERDAFTAR',
                                              style: AppTypography.labelXs
                                                  .copyWith(
                                                color: const Color(0xFF475569),
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Tambahkan situs atau endpoint pertama Anda di menu Sites untuk memulai pemantauan uptime.',
                                              style:
                                                  AppTypography.bodySm.copyWith(
                                                color: const Color(0xFF64748B),
                                                fontSize: 11.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ] else ...[
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0FDF4),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: const Color(0xFFBBF7D0),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: AppColors.statusOperational
                                                .withValues(alpha: 0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.shield_outlined,
                                          color: AppColors.statusOperational,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'STATUS ARMADA AMAN (ZERO DOWN)',
                                              style: AppTypography.labelXs
                                                  .copyWith(
                                                color: const Color(0xFF065F46),
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Semua endpoint dan layanan digital terpantau berjalan normal tanpa gangguan.',
                                              style:
                                                  AppTypography.bodySm.copyWith(
                                                color: const Color(0xFF166534),
                                                fontSize: 11.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],

                              // 2. Reliability & Fleet Health Radial Hero
                              ReliabilityGaugeCard(
                                uptimePercentage: stats.uptimePercentage,
                                totalHeartbeats: stats.totalHeartbeats,
                                mttr: stats.mttr,
                                totalServices: stats.totalServices,
                                operationalCount: stats.operationalCount,
                                outageCount: stats.outageCount,
                              ),
                              const SizedBox(height: 16),

                              // 3. Fleet Status Summary Row
                              FleetStatusOverview(
                                operationalCount: stats.operationalCount,
                                outageCount: stats.outageCount,
                                degradedCount: stats.degradedCount,
                                onFilterSelect: (filter) {
                                  onNavigateToServices?.call(filter);
                                },
                              ),
                              const SizedBox(height: 16),

                              // 4. Latency Performance Chart Card
                              LatencyChartCard(
                                currentLatencyMs: stats.avgLatencyMs,
                                latencyPoints: stats.latencyHistory,
                                activeRange: state.activeRange,
                                onRangeChanged: (range) {
                                  context
                                      .read<DashboardCubit>()
                                      .setLatencyRange(range);
                                },
                              ),
                              const SizedBox(height: 16),

                              // 5. Live Edge Telemetry Heartbeat Feed or Explorer CTA
                              if (stats.recentHeartbeats.isNotEmpty) ...[
                                LiveHeartbeatCard(
                                  heartbeats: stats.recentHeartbeats,
                                  onEndpointTap: (item) {
                                    onNavigateToServices?.call('all');
                                  },
                                ),
                              ] else ...[
                                InkWell(
                                  onTap: () =>
                                      onNavigateToServices?.call('all'),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF00685F),
                                          Color(0xFF008378),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.25),
                                          blurRadius: 14,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white
                                                .withValues(alpha: 0.15),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Icon(
                                            Icons.language_rounded,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Eksplorasi Layanan Digital',
                                                style: AppTypography.titleSm
                                                    .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                'Buka daftar situs & trigger manual health check',
                                                style: AppTypography.bodySm
                                                    .copyWith(
                                                  color: Colors.white70,
                                                  fontSize: 11.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
