import '../../domain/entities/dashboard_stats_entity.dart';

class StatsModel {
  final bool success;
  final String message;
  final Data data;

  StatsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  StatsModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      StatsModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      data: Data.fromJson(
        (json['data'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.toJson(),
      };

  DashboardStatsEntity toEntity({bool isFromCache = false, DateTime? cachedAt}) {
    return data.toEntity(isFromCache: isFromCache, cachedAt: cachedAt);
  }
}

class Data {
  final Summary summary;
  final CriticalBanner criticalBanner;
  final LatencySparkline latencySparkline;
  final List<dynamic> recentIncidents;

  Data({
    required this.summary,
    required this.criticalBanner,
    required this.latencySparkline,
    required this.recentIncidents,
  });

  Data copyWith({
    Summary? summary,
    CriticalBanner? criticalBanner,
    LatencySparkline? latencySparkline,
    List<dynamic>? recentIncidents,
  }) =>
      Data(
        summary: summary ?? this.summary,
        criticalBanner: criticalBanner ?? this.criticalBanner,
        latencySparkline: latencySparkline ?? this.latencySparkline,
        recentIncidents: recentIncidents ?? this.recentIncidents,
      );

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      summary: Summary.fromJson(
        (json['summary'] as Map<String, dynamic>?) ?? {},
      ),
      criticalBanner: CriticalBanner.fromJson(
        (json['critical_banner'] as Map<String, dynamic>?) ?? {},
      ),
      latencySparkline: LatencySparkline.fromJson(
        (json['latency_sparkline'] as Map<String, dynamic>?) ?? {},
      ),
      recentIncidents: json['recent_incidents'] as List? ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'summary': summary.toJson(),
        'critical_banner': criticalBanner.toJson(),
        'latency_sparkline': latencySparkline.toJson(),
        'recent_incidents': recentIncidents,
      };

  DashboardStatsEntity toEntity({bool isFromCache = false, DateTime? cachedAt}) {
    ActiveAlertEntity? alert;
    if (criticalBanner.isVisible && criticalBanner.incident != null) {
      final inc = criticalBanner.incident;
      if (inc is Map<String, dynamic>) {
        alert = ActiveAlertEntity(
          id: inc['id'] is int ? inc['id'] : 1,
          title: inc['title'] ?? 'Insiden Kritis Terdeteksi',
          description: inc['description'] ?? inc['message'] ?? 'Perlu penanganan segera.',
          severity: inc['severity'] ?? 'Critical',
          timeAgo: inc['time_ago'] ?? inc['created_at'] ?? 'Baru saja',
          isAcknowledged: inc['is_acknowledged'] ?? false,
        );
      }
    }

    final latHistory = latencySparkline.values.isNotEmpty
        ? latencySparkline.values.map((e) => e.toDouble()).toList()
        : <double>[42, 45, 38, 50, 48, 42];

    return DashboardStatsEntity(
      uptimePercentage: summary.uptimePercentage.toDouble(),
      totalServices: summary.totalSites,
      operationalCount: summary.normalSites,
      outageCount: summary.disruptedSites,
      degradedCount: summary.warningSites,
      avgLatencyMs: latencySparkline.currentAvgLatencyMs,
      mttr: '0m',
      totalHeartbeats: '${summary.totalSites * 24} cek',
      latencyHistory: latHistory,
      recentHeartbeats: const [],
      criticalAlert: alert,
      isFromCache: isFromCache,
      cachedAt: cachedAt,
    );
  }
}

class CriticalBanner {
  final bool isVisible;
  final dynamic incident;

  CriticalBanner({
    required this.isVisible,
    required this.incident,
  });

  CriticalBanner copyWith({
    bool? isVisible,
    dynamic incident,
  }) =>
      CriticalBanner(
        isVisible: isVisible ?? this.isVisible,
        incident: incident ?? this.incident,
      );

  factory CriticalBanner.fromJson(Map<String, dynamic> json) {
    return CriticalBanner(
      isVisible: json['is_visible'] as bool? ?? false,
      incident: json['incident'],
    );
  }

  Map<String, dynamic> toJson() => {
        'is_visible': isVisible,
        'incident': incident,
      };
}

class LatencySparkline {
  final int currentAvgLatencyMs;
  final String currentAvgLatencyFormatted;
  final List<String> labels;
  final List<int> values;
  final List<Point> points;

  LatencySparkline({
    required this.currentAvgLatencyMs,
    required this.currentAvgLatencyFormatted,
    required this.labels,
    required this.values,
    required this.points,
  });

  LatencySparkline copyWith({
    int? currentAvgLatencyMs,
    String? currentAvgLatencyFormatted,
    List<String>? labels,
    List<int>? values,
    List<Point>? points,
  }) =>
      LatencySparkline(
        currentAvgLatencyMs: currentAvgLatencyMs ?? this.currentAvgLatencyMs,
        currentAvgLatencyFormatted:
            currentAvgLatencyFormatted ?? this.currentAvgLatencyFormatted,
        labels: labels ?? this.labels,
        values: values ?? this.values,
        points: points ?? this.points,
      );

  factory LatencySparkline.fromJson(Map<String, dynamic> json) {
    final rawLabels = json['labels'] as List? ?? [];
    final rawValues = json['values'] as List? ?? [];
    final rawPoints = json['points'] as List? ?? [];

    return LatencySparkline(
      currentAvgLatencyMs: (json['current_avg_latency_ms'] as num?)?.toInt() ?? 0,
      currentAvgLatencyFormatted:
          json['current_avg_latency_formatted']?.toString() ?? '0 ms',
      labels: rawLabels.map((e) => e.toString()).toList(),
      values: rawValues.map((e) => (e as num).toInt()).toList(),
      points: rawPoints
          .map((e) => Point.fromJson((e as Map<String, dynamic>?) ?? {}))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'current_avg_latency_ms': currentAvgLatencyMs,
        'current_avg_latency_formatted': currentAvgLatencyFormatted,
        'labels': labels,
        'values': values,
        'points': points.map((e) => e.toJson()).toList(),
      };
}

class Point {
  final String hour;
  final int latencyMs;

  Point({
    required this.hour,
    required this.latencyMs,
  });

  Point copyWith({
    String? hour,
    int? latencyMs,
  }) =>
      Point(
        hour: hour ?? this.hour,
        latencyMs: latencyMs ?? this.latencyMs,
      );

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      hour: json['hour']?.toString() ?? '',
      latencyMs: (json['latency_ms'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'hour': hour,
        'latency_ms': latencyMs,
      };
}

class Summary {
  final int uptimePercentage;
  final String uptimePercentageFormatted;
  final int totalSites;
  final int normalSites;
  final int warningSites;
  final int disruptedSites;
  final int pausedSites;
  final int openIncidents;
  final int criticalIncidents;

  Summary({
    required this.uptimePercentage,
    required this.uptimePercentageFormatted,
    required this.totalSites,
    required this.normalSites,
    required this.warningSites,
    required this.disruptedSites,
    required this.pausedSites,
    required this.openIncidents,
    required this.criticalIncidents,
  });

  Summary copyWith({
    int? uptimePercentage,
    String? uptimePercentageFormatted,
    int? totalSites,
    int? normalSites,
    int? warningSites,
    int? disruptedSites,
    int? pausedSites,
    int? openIncidents,
    int? criticalIncidents,
  }) =>
      Summary(
        uptimePercentage: uptimePercentage ?? this.uptimePercentage,
        uptimePercentageFormatted:
            uptimePercentageFormatted ?? this.uptimePercentageFormatted,
        totalSites: totalSites ?? this.totalSites,
        normalSites: normalSites ?? this.normalSites,
        warningSites: warningSites ?? this.warningSites,
        disruptedSites: disruptedSites ?? this.disruptedSites,
        pausedSites: pausedSites ?? this.pausedSites,
        openIncidents: openIncidents ?? this.openIncidents,
        criticalIncidents: criticalIncidents ?? this.criticalIncidents,
      );

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      uptimePercentage: (json['uptime_percentage'] as num?)?.toInt() ?? 0,
      uptimePercentageFormatted:
          json['uptime_percentage_formatted']?.toString() ?? '0%',
      totalSites: (json['total_sites'] as num?)?.toInt() ?? 0,
      normalSites: (json['normal_sites'] as num?)?.toInt() ?? 0,
      warningSites: (json['warning_sites'] as num?)?.toInt() ?? 0,
      disruptedSites: (json['disrupted_sites'] as num?)?.toInt() ?? 0,
      pausedSites: (json['paused_sites'] as num?)?.toInt() ?? 0,
      openIncidents: (json['open_incidents'] as num?)?.toInt() ?? 0,
      criticalIncidents: (json['critical_incidents'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'uptime_percentage': uptimePercentage,
        'uptime_percentage_formatted': uptimePercentageFormatted,
        'total_sites': totalSites,
        'normal_sites': normalSites,
        'warning_sites': warningSites,
        'disrupted_sites': disruptedSites,
        'paused_sites': pausedSites,
        'open_incidents': openIncidents,
        'critical_incidents': criticalIncidents,
      };
}
