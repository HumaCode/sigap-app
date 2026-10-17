import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/dynamic_island_toast.dart';
import '../../../../core/widgets/modern_empty_state.dart';
import '../../../../core/widgets/modern_loader.dart';
import '../../data/models/inspect_model.dart';
import '../cubit/services_cubit.dart';
import '../widgets/uptime_heatmap_grid.dart';
import '../widgets/latency_waterfall_card.dart';

class InspectScreen extends StatefulWidget {
  final VoidCallback? onNavigateToServices;

  const InspectScreen({super.key, this.onNavigateToServices});

  @override
  State<InspectScreen> createState() => _InspectScreenState();
}

class _InspectScreenState extends State<InspectScreen> {
  bool _isLoading = true;
  bool _isChecking = false;
  InspectModel? _inspectModel;
  String? _selectedServiceId;

  @override
  void initState() {
    super.initState();
    _loadInspectData();
  }

  Future<void> _loadInspectData({String? serviceId}) async {
    setState(() => _isLoading = true);
    try {
      final repository = context.read<ServicesCubit>().repository;
      final result = await repository.getInspectData(id: serviceId ?? _selectedServiceId);
      if (mounted) {
        setState(() {
          _inspectModel = result;
          if (result != null && result.data.service.id.isNotEmpty) {
            _selectedServiceId = result.data.service.id;
          }
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _inspectModel = null;
          _isLoading = false;
        });
      }
    }
  }

  void _onTriggerManualCheck() async {
    if (_inspectModel == null) return;
    setState(() => _isChecking = true);
    try {
      final repository = context.read<ServicesCubit>().repository;
      final serviceId = int.tryParse(_inspectModel!.data.service.id) ?? 0;
      if (serviceId > 0) {
        await repository.triggerManualCheck(serviceId);
      }
      await Future.delayed(const Duration(milliseconds: 900));
      if (mounted) {
        setState(() => _isChecking = false);
        DynamicIslandToast.success(
          context,
          'Health Check selesai dieksekusi. Data metrik diperbarui.',
          title: 'HEALTH CHECK OK',
        );
        _loadInspectData(serviceId: _selectedServiceId);
      }
    } catch (_) {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.surface,
        body: Center(
          child: ModernLoader(
            message: 'Memuat Data Telemetri...',
            subMessage: 'Menganalisis performa server & latensi',
          ),
        ),
      );
    }

    final hasData = _inspectModel != null &&
        _inspectModel!.data.service.name.isNotEmpty &&
        _inspectModel!.data.service.id.isNotEmpty;

    if (!hasData) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          title: Text('Service Telemetry Inspect', style: AppTypography.titleSm),
          elevation: 0,
        ),
        body: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => _loadInspectData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: Column(
              children: [
                const SizedBox(height: 60),
                ModernEmptyState(
                  icon: Icons.analytics_outlined,
                  title: 'BELUM ADA DATA INSPEKSI',
                  description:
                      'Data telemetri mendalam belum tersedia karena belum ada situs atau layanan yang didaftarkan pada sistem.\n\nSilakan tambahkan situs pertama Anda di menu Services untuk melihat 30-Day Reliability Heatmap dan rincian latensi telemetri.',
                  buttonText: 'Buka Menu Services',
                  onButtonPressed: widget.onNavigateToServices,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      );
    }

    final data = _inspectModel!.data;
    final svc = data.service;
    final isOutage = svc.status.toLowerCase() == 'outage' || svc.statusCode >= 500;
    final entity = data.toEntity();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(svc.name, style: AppTypography.titleSm),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: AppSpacing.roundedFull,
            ),
            child: Text(
              svc.shortId.isNotEmpty ? svc.shortId : 'ID: ${svc.id}',
              style: AppTypography.codeSm.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => _loadInspectData(serviceId: _selectedServiceId),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Available Services Dropdown Selector (if multiple available)
              if (data.availableServices.length > 1) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedServiceId,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      items: data.availableServices.map((s) {
                        return DropdownMenuItem<String>(
                          value: s.id,
                          child: Text(
                            '${s.name} (${s.category.isNotEmpty ? s.category : s.url})',
                            style: AppTypography.bodySm.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          _loadInspectData(serviceId: val);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

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
                            svc.name,
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
                            svc.statusLabel.isNotEmpty ? svc.statusLabel : '${svc.statusCode} OK',
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
                      svc.subtitle.isNotEmpty ? svc.subtitle : svc.url,
                      style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 14),

                    // Snapshot Pills
                    Row(
                      children: [
                        _buildSnapshotPill('30d Uptime', svc.metrics.uptime30DFormatted),
                        const SizedBox(width: 8),
                        _buildSnapshotPill('Avg Latency', svc.metrics.avgLatencyFormatted),
                        const SizedBox(width: 8),
                        _buildSnapshotPill('Poll Cycle', svc.metrics.pollCycle, accent: true),
                      ],
                    ),

                    if (svc.alert.isAlert && svc.alert.message.isNotEmpty) ...[
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
                                svc.alert.message,
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
              UptimeHeatmapGrid(dailyUptime: entity.heatmapDailyUptime),
              const SizedBox(height: 16),

              // 3. Latency Waterfall Breakdown
              LatencyWaterfallCard(breakdown: entity.latencyBreakdown),
              const SizedBox(height: 24),

              // 4. Trigger Manual Health Check CTA
              ElevatedButton.icon(
                onPressed: _isChecking ? null : _onTriggerManualCheck,
                icon: _isChecking
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.sync_rounded),
                label: Text(
                  _isChecking ? 'Menjalankan Pemeriksaan...' : 'Trigger Manual Health Check',
                  style: AppTypography.titleSm.copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 13.5,
                  ),
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
}
