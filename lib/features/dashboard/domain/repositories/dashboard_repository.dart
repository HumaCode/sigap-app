import '../entities/dashboard_stats_entity.dart';

abstract class DashboardRepository {
  Future<DashboardStatsEntity> getDashboardStats();
  Future<void> acknowledgeAlert(int alertId);
}
