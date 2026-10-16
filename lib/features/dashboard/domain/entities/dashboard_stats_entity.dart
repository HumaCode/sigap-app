import 'package:equatable/equatable.dart';

class DashboardStatsEntity extends Equatable {
  final double uptimePercentage;
  final int totalServices;
  final int operationalCount;
  final int outageCount;
  final int degradedCount;
  final int avgLatencyMs;
  final String mttr;
  final String totalHeartbeats;
  final List<double> latencyHistory;
  final List<EdgeHeartbeatEntity> recentHeartbeats;
  final ActiveAlertEntity? criticalAlert;
  final bool isFromCache;
  final DateTime? cachedAt;

  const DashboardStatsEntity({
    required this.uptimePercentage,
    required this.totalServices,
    required this.operationalCount,
    required this.outageCount,
    required this.degradedCount,
    required this.avgLatencyMs,
    required this.mttr,
    required this.totalHeartbeats,
    required this.latencyHistory,
    required this.recentHeartbeats,
    this.criticalAlert,
    this.isFromCache = false,
    this.cachedAt,
  });

  DashboardStatsEntity copyWith({
    double? uptimePercentage,
    int? totalServices,
    int? operationalCount,
    int? outageCount,
    int? degradedCount,
    int? avgLatencyMs,
    String? mttr,
    String? totalHeartbeats,
    List<double>? latencyHistory,
    List<EdgeHeartbeatEntity>? recentHeartbeats,
    ActiveAlertEntity? criticalAlert,
    bool? isFromCache,
    DateTime? cachedAt,
  }) {
    return DashboardStatsEntity(
      uptimePercentage: uptimePercentage ?? this.uptimePercentage,
      totalServices: totalServices ?? this.totalServices,
      operationalCount: operationalCount ?? this.operationalCount,
      outageCount: outageCount ?? this.outageCount,
      degradedCount: degradedCount ?? this.degradedCount,
      avgLatencyMs: avgLatencyMs ?? this.avgLatencyMs,
      mttr: mttr ?? this.mttr,
      totalHeartbeats: totalHeartbeats ?? this.totalHeartbeats,
      latencyHistory: latencyHistory ?? this.latencyHistory,
      recentHeartbeats: recentHeartbeats ?? this.recentHeartbeats,
      criticalAlert: criticalAlert ?? this.criticalAlert,
      isFromCache: isFromCache ?? this.isFromCache,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  List<Object?> get props => [
        uptimePercentage,
        totalServices,
        operationalCount,
        outageCount,
        degradedCount,
        avgLatencyMs,
        mttr,
        totalHeartbeats,
        latencyHistory,
        recentHeartbeats,
        criticalAlert,
        isFromCache,
        cachedAt,
      ];
}

class EdgeHeartbeatEntity extends Equatable {
  final String serviceName;
  final String region;
  final String description;
  final int statusCode;
  final String statusText;
  final int latencyMs;
  final bool isDown;

  const EdgeHeartbeatEntity({
    required this.serviceName,
    required this.region,
    required this.description,
    required this.statusCode,
    required this.statusText,
    required this.latencyMs,
    required this.isDown,
  });

  @override
  List<Object?> get props => [
        serviceName,
        region,
        description,
        statusCode,
        statusText,
        latencyMs,
        isDown,
      ];
}

class ActiveAlertEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String severity;
  final String timeAgo;
  final bool isAcknowledged;

  const ActiveAlertEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.timeAgo,
    this.isAcknowledged = false,
  });

  ActiveAlertEntity copyWith({bool? isAcknowledged}) {
    return ActiveAlertEntity(
      id: id,
      title: title,
      description: description,
      severity: severity,
      timeAgo: timeAgo,
      isAcknowledged: isAcknowledged ?? this.isAcknowledged,
    );
  }

  @override
  List<Object?> get props => [id, title, description, severity, timeAgo, isAcknowledged];
}
