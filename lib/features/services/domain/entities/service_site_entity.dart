import 'package:equatable/equatable.dart';

class ServiceSiteEntity extends Equatable {
  final int id;
  final String name;
  final String domain;
  final String category;
  final String status; // 'operational', 'outage', 'degraded'
  final int statusCode;
  final String statusText;
  final int latencyMs;
  final int sslDaysLeft;
  final String regionStatus;
  final double uptime30d;
  final String lastAuditDate;
  final bool hasDefacement;
  final List<double> heatmapDailyUptime; // 30 items
  final LatencyBreakdownEntity latencyBreakdown;

  const ServiceSiteEntity({
    required this.id,
    required this.name,
    required this.domain,
    required this.category,
    required this.status,
    required this.statusCode,
    required this.statusText,
    required this.latencyMs,
    required this.sslDaysLeft,
    required this.regionStatus,
    required this.uptime30d,
    required this.lastAuditDate,
    this.hasDefacement = false,
    required this.heatmapDailyUptime,
    required this.latencyBreakdown,
  });

  bool get isOutage => status == 'outage' || statusCode >= 500;
  bool get isSslWarning => sslDaysLeft <= 14;

  @override
  List<Object?> get props => [
        id,
        name,
        domain,
        category,
        status,
        statusCode,
        statusText,
        latencyMs,
        sslDaysLeft,
        regionStatus,
        uptime30d,
        lastAuditDate,
        hasDefacement,
        heatmapDailyUptime,
        latencyBreakdown,
      ];
}

class LatencyBreakdownEntity extends Equatable {
  final int dnsMs;
  final int tlsMs;
  final int ttfbMs;
  final int transferMs;

  const LatencyBreakdownEntity({
    required this.dnsMs,
    required this.tlsMs,
    required this.ttfbMs,
    required this.transferMs,
  });

  int get totalMs => dnsMs + tlsMs + ttfbMs + transferMs;

  @override
  List<Object?> get props => [dnsMs, tlsMs, ttfbMs, transferMs];
}
