import '../../domain/entities/dashboard_stats_entity.dart';

class DashboardStatsModel extends DashboardStatsEntity {
  const DashboardStatsModel({
    required super.uptimePercentage,
    required super.totalServices,
    required super.operationalCount,
    required super.outageCount,
    required super.degradedCount,
    required super.avgLatencyMs,
    required super.mttr,
    required super.totalHeartbeats,
    required super.latencyHistory,
    required super.recentHeartbeats,
    super.criticalAlert,
    super.isFromCache,
    super.cachedAt,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json, {bool isFromCache = false, DateTime? cachedAt}) {
    final heartbeatsRaw = json['recent_heartbeats'] as List? ?? [];
    final heartbeats = heartbeatsRaw.map((e) {
      final item = e as Map<String, dynamic>;
      return EdgeHeartbeatEntity(
        serviceName: item['service_name'] ?? 'api.service.io',
        region: item['region'] ?? 'IAD',
        description: item['description'] ?? 'Edge endpoint',
        statusCode: item['status_code'] ?? 200,
        statusText: item['status_text'] ?? 'OK',
        latencyMs: item['latency_ms'] ?? 0,
        isDown: (item['status_code'] ?? 200) >= 400,
      );
    }).toList();

    ActiveAlertEntity? alert;
    if (json['critical_alert'] != null) {
      final a = json['critical_alert'] as Map<String, dynamic>;
      alert = ActiveAlertEntity(
        id: a['id'] ?? 4082,
        title: a['title'] ?? 'Payment Gateway API Down (HTTP 502)',
        description: a['description'] ?? 'Elevated 5xx rates across IAD-01 edge proxy.',
        severity: a['severity'] ?? 'P1 Critical',
        timeAgo: a['time_ago'] ?? '14m ago',
        isAcknowledged: a['is_acknowledged'] ?? false,
      );
    }

    final latRaw = json['latency_history'] as List? ?? [48, 45, 52, 40, 38, 42, 35, 42];
    final latHistory = latRaw.map((e) => (e as num).toDouble()).toList();

    return DashboardStatsModel(
      uptimePercentage: (json['uptime_percentage'] as num?)?.toDouble() ?? 99.85,
      totalServices: json['total_services'] as int? ?? 27,
      operationalCount: json['operational_count'] as int? ?? 24,
      outageCount: json['outage_count'] as int? ?? 1,
      degradedCount: json['degraded_count'] as int? ?? 2,
      avgLatencyMs: json['avg_latency_ms'] as int? ?? 42,
      mttr: json['mttr'] as String? ?? '11.4 mins',
      totalHeartbeats: json['total_heartbeats'] as String? ?? '1.48M',
      latencyHistory: latHistory,
      recentHeartbeats: heartbeats.isNotEmpty ? heartbeats : _defaultHeartbeats,
      criticalAlert: alert ?? _defaultCriticalAlert,
      isFromCache: isFromCache,
      cachedAt: cachedAt,
    );
  }

  static const List<EdgeHeartbeatEntity> _defaultHeartbeats = [
    EdgeHeartbeatEntity(
      serviceName: 'api.payments.io',
      region: 'IAD',
      description: 'TIMEOUT · upstream error',
      statusCode: 502,
      statusText: '502 BAD',
      latencyMs: 0,
      isDown: true,
    ),
    EdgeHeartbeatEntity(
      serviceName: 'auth.cloudapp.net',
      region: 'FRA',
      description: 'OAuth2 /token · TLS 1.3',
      statusCode: 200,
      statusText: '200 OK',
      latencyMs: 28,
      isDown: false,
    ),
    EdgeHeartbeatEntity(
      serviceName: 'telemetry-collector.io',
      region: 'NRT',
      description: 'gRPC streams · ack 100%',
      statusCode: 200,
      statusText: '200 OK',
      latencyMs: 36,
      isDown: false,
    ),
    EdgeHeartbeatEntity(
      serviceName: 'cdn-static.assets.sre',
      region: 'SIN',
      description: 'Anycast edge · HIT 98%',
      statusCode: 200,
      statusText: '200 OK',
      latencyMs: 19,
      isDown: false,
    ),
  ];

  static const ActiveAlertEntity _defaultCriticalAlert = ActiveAlertEntity(
    id: 4082,
    title: 'Payment Gateway API Down (HTTP 502)',
    description: 'Elevated 5xx rates across IAD-01 edge proxy. Payment settlement processing degraded.',
    severity: 'P1 Critical',
    timeAgo: '14m ago',
    isAcknowledged: false,
  );
}
