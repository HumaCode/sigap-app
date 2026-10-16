import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/incidents_cubit.dart';
import '../cubit/incidents_state.dart';
import '../widgets/incident_pulse_ribbon.dart';
import '../widgets/incident_detail_card.dart';
import '../widgets/ai_diagnostic_card.dart';

class IncidentsScreen extends StatelessWidget {
  const IncidentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocBuilder<IncidentsCubit, IncidentsState>(
        builder: (context, state) {
          if (state is IncidentsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is IncidentsLoaded) {
            final activeP1 = state.allIncidents.where((i) => i.isCritical && !i.isResolved).length;
            final resolvedToday = state.allIncidents.where((i) => i.isResolved).length;
            final incidents = state.filteredIncidents;

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => context.read<IncidentsCubit>().loadIncidents(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. War Room Pulse Ribbon & Overview
                    IncidentPulseRibbon(
                      activeP1Count: activeP1,
                      resolvedTodayCount: resolvedToday,
                      mttr: '11m',
                      activeFilter: state.activeSeverityFilter,
                      onFilterChanged: (filter) {
                        context.read<IncidentsCubit>().filterBySeverity(filter);
                      },
                    ),
                    const SizedBox(height: 16),

                    // 2. Incident Stream
                    if (incidents.isEmpty) ...[
                      const SizedBox(height: 40),
                      const Center(
                        child: Text(
                          'Semua insiden dalam kategori ini telah terselesaikan.',
                          style: TextStyle(color: AppColors.textCaption),
                        ),
                      ),
                    ] else ...[
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: incidents.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final incident = incidents[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              IncidentDetailCard(incident: incident),
                              const SizedBox(height: 12),
                              AiDiagnosticCard(
                                incident: incident,
                                onStatusChange: (newStatus) {
                                  context.read<IncidentsCubit>().updateIncidentStatus(
                                        incident.id,
                                        newStatus,
                                      );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 24),
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
