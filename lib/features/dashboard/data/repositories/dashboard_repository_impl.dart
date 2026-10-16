import '../../../../core/storage/cache_service.dart';
import '../../domain/entities/dashboard_stats_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../models/dashboard_stats_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  static const String _cacheKey = 'dashboard_stats_cache';

  @override
  Future<DashboardStatsEntity> getDashboardStats() async {
    try {
      final stats = await remoteDataSource.getStats();
      // Cache for offline resilience
      await CacheService.put(_cacheKey, {
        'uptime_percentage': stats.uptimePercentage,
        'total_services': stats.totalServices,
        'operational_count': stats.operationalCount,
        'outage_count': stats.outageCount,
        'degraded_count': stats.degradedCount,
        'avg_latency_ms': stats.avgLatencyMs,
        'mttr': stats.mttr,
        'total_heartbeats': stats.totalHeartbeats,
      });
      return stats;
    } catch (_) {
      // Offline fallback from Hive cache
      final cached = CacheService.get(_cacheKey);
      final cachedAt = CacheService.getCachedAt(_cacheKey);
      if (cached != null && cached is Map) {
        return DashboardStatsModel.fromJson(
          Map<String, dynamic>.from(cached),
          isFromCache: true,
          cachedAt: cachedAt,
        );
      }
      return DashboardStatsModel.fromJson({}, isFromCache: true, cachedAt: DateTime.now());
    }
  }

  @override
  Future<void> acknowledgeAlert(int alertId) async {
    await remoteDataSource.acknowledgeAlert(alertId);
  }
}
