import '../../domain/entities/service_site_entity.dart';

class ServiceSiteModel extends ServiceSiteEntity {
  const ServiceSiteModel({
    required super.id,
    required super.name,
    required super.domain,
    required super.category,
    required super.status,
    required super.statusCode,
    required super.statusText,
    required super.latencyMs,
    required super.sslDaysLeft,
    required super.regionStatus,
    required super.uptime30d,
    required super.lastAuditDate,
    super.hasDefacement,
    required super.heatmapDailyUptime,
    required super.latencyBreakdown,
  });

  factory ServiceSiteModel.fromJson(Map<String, dynamic> json) {
    final heatmap = (json['heatmap_30d'] as List?)
            ?.map((e) => (e as num).toDouble())
            .toList() ??
        List.generate(30, (i) => i == 27 ? 0.0 : (i == 7 || i == 20 ? 98.4 : 100.0));

    final breakdownJson = json['latency_breakdown'] as Map<String, dynamic>? ?? {};
    final breakdown = LatencyBreakdownEntity(
      dnsMs: breakdownJson['dns'] ?? 4,
      tlsMs: breakdownJson['tls'] ?? 11,
      ttfbMs: breakdownJson['ttfb'] ?? 19,
      transferMs: breakdownJson['transfer'] ?? 7,
    );

    return ServiceSiteModel(
      id: json['id'] as int? ?? 1,
      name: json['name'] as String? ?? 'api.payments.io',
      domain: json['domain'] as String? ?? 'https://api.payments.io',
      category: json['category'] as String? ?? 'REST API · Global Gateway',
      status: json['status'] as String? ?? 'outage',
      statusCode: json['status_code'] as int? ?? 502,
      statusText: json['status_text'] as String? ?? '502 Bad Gateway',
      latencyMs: json['latency_ms'] as int? ?? 0,
      sslDaysLeft: json['ssl_days_left'] as int? ?? 148,
      regionStatus: json['region_status'] as String? ?? '3/5 Regions Down: US-East, EU-Central',
      uptime30d: (json['uptime_30d'] as num?)?.toDouble() ?? 99.88,
      lastAuditDate: json['last_audit_date'] as String? ?? 'Just now',
      hasDefacement: json['has_defacement'] as bool? ?? false,
      heatmapDailyUptime: heatmap,
      latencyBreakdown: breakdown,
    );
  }

  static List<ServiceSiteModel> get sampleServices => [
        const ServiceSiteModel(
          id: 1,
          name: 'api.payments.io',
          domain: 'https://api.payments.io',
          category: 'REST API · Global Gateway',
          status: 'outage',
          statusCode: 502,
          statusText: '502 Bad Gateway',
          latencyMs: 0,
          sslDaysLeft: 148,
          regionStatus: '3/5 Regions Down: US-East, EU-Central',
          uptime30d: 99.88,
          lastAuditDate: '10s ago',
          heatmapDailyUptime: [
            100, 100, 100, 100, 100, 100, 100, 98.4, 100, 100, 100, 100,
            100, 100, 100, 100, 100, 100, 100, 100, 99.1, 100, 100, 100,
            100, 100, 100, 0, 100, 100
          ],
          latencyBreakdown: LatencyBreakdownEntity(dnsMs: 4, tlsMs: 11, ttfbMs: 19, transferMs: 7),
        ),
        const ServiceSiteModel(
          id: 2,
          name: 'auth.cloudapp.net',
          domain: 'https://auth.cloudapp.net',
          category: 'OAuth2 / Auth0 Provider',
          status: 'operational',
          statusCode: 200,
          statusText: '200 OK',
          latencyMs: 28,
          sslDaysLeft: 12,
          regionStatus: 'Global Edge Ingress Active',
          uptime30d: 99.98,
          lastAuditDate: '30s ago',
          heatmapDailyUptime: [
            100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
            100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
            100, 100, 100, 100, 100, 100
          ],
          latencyBreakdown: LatencyBreakdownEntity(dnsMs: 3, tlsMs: 9, ttfbMs: 12, transferMs: 4),
        ),
        const ServiceSiteModel(
          id: 3,
          name: 'telemetry-collector.io',
          domain: 'https://telemetry-collector.io',
          category: 'gRPC · Event Streaming',
          status: 'operational',
          statusCode: 200,
          statusText: '200 OK',
          latencyMs: 36,
          sslDaysLeft: 84,
          regionStatus: 'Healthy · Anycast Cluster',
          uptime30d: 99.95,
          lastAuditDate: '1m ago',
          heatmapDailyUptime: [
            100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
            100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
            100, 100, 100, 100, 100, 100
          ],
          latencyBreakdown: LatencyBreakdownEntity(dnsMs: 5, tlsMs: 12, ttfbMs: 14, transferMs: 5),
        ),
        const ServiceSiteModel(
          id: 4,
          name: 'cdn-static.assets.sre',
          domain: 'https://cdn-static.assets.sre',
          category: 'Anycast Static Assets Cache',
          status: 'operational',
          statusCode: 200,
          statusText: '200 OK',
          latencyMs: 19,
          sslDaysLeft: 6,
          regionStatus: '98% Cache Hit Rate',
          uptime30d: 99.99,
          lastAuditDate: '45s ago',
          heatmapDailyUptime: [
            100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
            100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
            100, 100, 100, 100, 100, 100
          ],
          latencyBreakdown: LatencyBreakdownEntity(dnsMs: 2, tlsMs: 6, ttfbMs: 8, transferMs: 3),
        ),
      ];
}
