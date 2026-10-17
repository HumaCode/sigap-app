import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/dynamic_island_toast.dart';
import '../../../../core/widgets/modern_empty_state.dart';
import '../cubit/services_cubit.dart';
import '../cubit/services_state.dart';
import '../widgets/service_search_bar.dart';
import '../widgets/service_filter_chips.dart';
import '../widgets/service_card_item.dart';
import 'service_detail_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocBuilder<ServicesCubit, ServicesState>(
        builder: (context, state) {
          if (state is ServicesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is ServicesLoaded) {
            final services = state.filteredServices;

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => context.read<ServicesCubit>().loadServices(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Search Ribbon
                    ServiceSearchBar(
                      hintText: state.allServices.isEmpty
                          ? 'Cari situs atau endpoint...'
                          : 'Cari ${state.allServices.length} situs atau endpoint...',
                      onChanged: (query) {
                        context.read<ServicesCubit>().search(query);
                      },
                    ),
                    const SizedBox(height: 12),

                    // Filter Chips Carousel
                    ServiceFilterChips(
                      activeFilter: state.activeFilter,
                      allCount: state.allServices.length,
                      operationalCount: state.allServices.where((s) => !s.isOutage).length,
                      outageCount: state.allServices.where((s) => s.isOutage).length,
                      sslCount: state.allServices.where((s) => s.isSslWarning).length,
                      onFilterChanged: (filter) {
                        context.read<ServicesCubit>().filterBy(filter);
                      },
                    ),
                    const SizedBox(height: 10),

                    // Sync Indicator Ribbon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.statusOperational,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Auto-refresh (10s interval)',
                              style: AppTypography.codeSm.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Last synced 4s ago',
                          style: AppTypography.codeSm.copyWith(
                            color: AppColors.textCaption,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Service Cards Stack
                    if (services.isEmpty) ...[
                      ModernEmptyState(
                        icon: state.searchQuery.isNotEmpty
                            ? Icons.search_off_rounded
                            : Icons.dns_outlined,
                        title: state.searchQuery.isNotEmpty
                            ? 'Layanan Tidak Ditemukan'
                            : (state.allServices.isEmpty
                                ? 'Belum Ada Situs Terdaftar'
                                : 'Tidak Ada Layanan (${state.activeFilter.toUpperCase()})'),
                        description: state.searchQuery.isNotEmpty
                            ? 'Tidak ada endpoint yang cocok dengan kata kunci "${state.searchQuery}". Silakan coba kata kunci lain.'
                            : (state.allServices.isEmpty
                                ? 'Belum ada situs yang dipantau pada sistem. Tambahkan situs atau endpoint pertama Anda di database Laravel untuk memulai monitoring uptime.'
                                : 'Tidak ada situs pada filter ini. Beralih kembali ke filter "All" untuk menampilkan seluruh layanan.'),
                        buttonText: state.searchQuery.isNotEmpty || state.activeFilter != 'all'
                            ? 'Reset Filter'
                            : 'Muat Ulang',
                        onButtonPressed: () {
                          context.read<ServicesCubit>().loadServices();
                        },
                      ),
                    ] else ...[
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: services.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final service = services[index];
                          return ServiceCardItem(
                            service: service,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ServiceDetailScreen(service: service),
                                ),
                              );
                            },
                            onQuickPing: () {
                              context.read<ServicesCubit>().quickPing(service.id);
                              DynamicIslandToast.info(
                                context,
                                'Ping sinyal telemetri dikirim ke ${service.name}',
                                title: 'QUICK PING DISPATCHED',
                              );
                            },
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
