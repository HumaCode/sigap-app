import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/dashboard_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository repository;

  DashboardCubit({required this.repository}) : super(DashboardInitial());

  Future<void> loadDashboard() async {
    // 1. Tampilkan data cache seketika (0 delay) jika tersedia agar tidak menunggu lama
    final cached = repository.getCachedStats();
    if (cached != null) {
      emit(DashboardLoaded(stats: cached));
    } else {
      emit(DashboardLoading());
    }

    // 2. Fetch data terbaru dari server di background
    try {
      final stats = await repository.getDashboardStats();
      emit(DashboardLoaded(stats: stats));
    } catch (e) {
      if (state is! DashboardLoaded) {
        emit(DashboardError(e.toString()));
      }
    }
  }

  Future<void> refresh() async {
    try {
      final stats = await repository.getDashboardStats();
      if (state is DashboardLoaded) {
        emit((state as DashboardLoaded).copyWith(stats: stats));
      } else {
        emit(DashboardLoaded(stats: stats));
      }
    } catch (_) {}
  }

  void setLatencyRange(String range) {
    if (state is DashboardLoaded) {
      final current = state as DashboardLoaded;
      emit(current.copyWith(activeRange: range));
    }
  }

  Future<void> acknowledgeIncident(int alertId) async {
    if (state is DashboardLoaded) {
      final current = state as DashboardLoaded;
      final currentAlert = current.stats.criticalAlert;
      if (currentAlert != null && currentAlert.id == alertId) {
        final updatedAlert = currentAlert.copyWith(isAcknowledged: true);
        emit(current.copyWith(
          stats: current.stats.copyWith(criticalAlert: updatedAlert),
        ));
      }
      await repository.acknowledgeAlert(alertId);
      // Reload stats
      refresh();
    }
  }
}
