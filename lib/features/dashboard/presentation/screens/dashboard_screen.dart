import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/offline_banner.dart';
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
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
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
                    if (stats.isFromCache) OfflineBanner(cachedAt: stats.cachedAt),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.marginMobile),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Urgent Critical Incident Banner
                          if (stats.criticalAlert != null) ...[
                            IncidentCriticalBanner(
                              alert: stats.criticalAlert!,
                              onAcknowledge: () {
                                context.read<DashboardCubit>().acknowledgeIncident(
                                      stats.criticalAlert!.id,
                                    );
                              },
                              onAiTriage: () {
                                onNavigateToIncidents?.call();
                              },
                            ),
                            const SizedBox(height: 16),
                          ],

                          // 2. Reliability & Fleet Health Radial Hero
                          ReliabilityGaugeCard(
                            uptimePercentage: stats.uptimePercentage,
                            totalHeartbeats: stats.totalHeartbeats,
                            mttr: stats.mttr,
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
                              context.read<DashboardCubit>().setLatencyRange(range);
                            },
                          ),
                          const SizedBox(height: 16),

                          // 5. Live Edge Telemetry Heartbeat Feed
                          LiveHeartbeatCard(
                            heartbeats: stats.recentHeartbeats,
                            onEndpointTap: (item) {
                              onNavigateToServices?.call('all');
                            },
                          ),
                          const SizedBox(height: 24),
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
    );
  }
}
