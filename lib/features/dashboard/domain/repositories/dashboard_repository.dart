import '../entities/dashboard_stats_entity.dart';

abstract class DashboardRepository {
  Future<DashboardStatsEntity> getDashboardStats();
  DashboardStatsEntity? getCachedStats();
  Future<void> acknowledgeAlert(int alertId);
}
