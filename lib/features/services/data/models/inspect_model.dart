import '../../domain/entities/service_site_entity.dart';

Map<String, dynamic> _toMap(dynamic val) {
  if (val is Map) {
    return Map<String, dynamic>.from(val);
  }
  return <String, dynamic>{};
}

class InspectModel {
  final bool success;
  final String message;
  final Data data;

  InspectModel({
    required this.success,
    required this.message,
    required this.data,
  });

  InspectModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      InspectModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory InspectModel.fromJson(Map<String, dynamic> json) => InspectModel(
        success: json['success'] as bool? ?? true,
        message: json['message'] as String? ?? '',
        data: Data.fromJson(_toMap(json['data'])),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.toJson(),
      };
}

class Data {
  final Service service;
  final Heatmap heatmap;
  final LatencyBreakdown latencyBreakdown;
  final List<AvailableService> availableServices;

  Data({
    required this.service,
    required this.heatmap,
    required this.latencyBreakdown,
    required this.availableServices,
  });

  Data copyWith({
    Service? service,
    Heatmap? heatmap,
    LatencyBreakdown? latencyBreakdown,
    List<AvailableService>? availableServices,
  }) =>
      Data(
        service: service ?? this.service,
        heatmap: heatmap ?? this.heatmap,
        latencyBreakdown: latencyBreakdown ?? this.latencyBreakdown,
        availableServices: availableServices ?? this.availableServices,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        service: Service.fromJson(_toMap(json['service'])),
        heatmap: Heatmap.fromJson(_toMap(json['heatmap'])),
        latencyBreakdown: LatencyBreakdown.fromJson(
          _toMap(json['latency_breakdown'] ?? json['latencyBreakdown']),
        ),
        availableServices: (json['available_services'] as List? ??
                json['availableServices'] as List?)
            ?.map((e) => AvailableService.fromJson(_toMap(e)))
            .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'service': service.toJson(),
        'heatmap': heatmap.toJson(),
        'latency_breakdown': latencyBreakdown.toJson(),
        'available_services':
            availableServices.map((e) => e.toJson()).toList(),
      };

  ServiceSiteEntity toEntity() {
    final heatmapValues = heatmap.cells.map((c) => c.uptimePercentage).toList();
    final stages = latencyBreakdown.stages;
    int dns = 0, tls = 0, ttfb = 0, transfer = 0;
    for (final s in stages) {
      final name = s.name.toLowerCase();
      if (name.contains('dns')) dns = s.latencyMs;
      if (name.contains('tls') || name.contains('ssl')) tls = s.latencyMs;
      if (name.contains('ttfb') || name.contains('first byte')) ttfb = s.latencyMs;
      if (name.contains('transfer') || name.contains('download')) transfer = s.latencyMs;
    }

    return ServiceSiteEntity(
      id: int.tryParse(service.id) ?? 0,
      name: service.name,
      domain: service.url,
      category: service.subtitle,
      status: service.status,
      statusCode: service.statusCode,
      statusText: service.statusLabel.isNotEmpty
          ? service.statusLabel
          : '${service.statusCode}',
      latencyMs: service.metrics.avgLatencyMs,
      sslDaysLeft: 90,
      regionStatus: service.alert.isAlert ? service.alert.message : 'Cluster Healthy',
      uptime30d: service.metrics.uptime30D,
      lastAuditDate: service.metrics.pollCycle,
      hasDefacement: false,
      heatmapDailyUptime: heatmapValues.isNotEmpty
          ? heatmapValues
          : List.generate(30, (_) => service.metrics.uptime30D),
      latencyBreakdown: LatencyBreakdownEntity(
        dnsMs: dns > 0 ? dns : (service.metrics.avgLatencyMs * 0.15).round(),
        tlsMs: tls > 0 ? tls : (service.metrics.avgLatencyMs * 0.25).round(),
        ttfbMs: ttfb > 0 ? ttfb : (service.metrics.avgLatencyMs * 0.40).round(),
        transferMs: transfer > 0 ? transfer : (service.metrics.avgLatencyMs * 0.20).round(),
      ),
    );
  }
}

class AvailableService {
  final String id;
  final String name;
  final String url;
  final String status;
  final String category;

  AvailableService({
    required this.id,
    required this.name,
    required this.url,
    required this.status,
    required this.category,
  });

  AvailableService copyWith({
    String? id,
    String? name,
    String? url,
    String? status,
    String? category,
  }) =>
      AvailableService(
        id: id ?? this.id,
        name: name ?? this.name,
        url: url ?? this.url,
        status: status ?? this.status,
        category: category ?? this.category,
      );

  factory AvailableService.fromJson(Map<String, dynamic> json) =>
      AvailableService(
        id: json['id']?.toString() ?? '',
        name: json['name'] as String? ?? '',
        url: json['url'] as String? ?? '',
        status: json['status'] as String? ?? 'operational',
        category: json['category'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
        'status': status,
        'category': category,
      };
}

class Heatmap {
  final String title;
  final String rangeLabel;
  final Summary summary;
  final List<Cell> cells;

  Heatmap({
    required this.title,
    required this.rangeLabel,
    required this.summary,
    required this.cells,
  });

  Heatmap copyWith({
    String? title,
    String? rangeLabel,
    Summary? summary,
    List<Cell>? cells,
  }) =>
      Heatmap(
        title: title ?? this.title,
        rangeLabel: rangeLabel ?? this.rangeLabel,
        summary: summary ?? this.summary,
        cells: cells ?? this.cells,
      );

  factory Heatmap.fromJson(Map<String, dynamic> json) => Heatmap(
        title: json['title'] as String? ?? '30-Day Uptime Heatmap',
        rangeLabel: json['range_label'] as String? ??
            (json['rangeLabel'] as String? ?? 'Last 30 Days'),
        summary: Summary.fromJson(_toMap(json['summary'])),
        cells: (json['cells'] as List?)
                ?.map((e) => Cell.fromJson(_toMap(e)))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'range_label': rangeLabel,
        'summary': summary.toJson(),
        'cells': cells.map((e) => e.toJson()).toList(),
      };
}

class Cell {
  final int day;
  final DateTime date;
  final String label;
  final double uptimePercentage;
  final String status;
  final bool isToday;

  Cell({
    required this.day,
    required this.date,
    required this.label,
    required this.uptimePercentage,
    required this.status,
    required this.isToday,
  });

  Cell copyWith({
    int? day,
    DateTime? date,
    String? label,
    double? uptimePercentage,
    String? status,
    bool? isToday,
  }) =>
      Cell(
        day: day ?? this.day,
        date: date ?? this.date,
        label: label ?? this.label,
        uptimePercentage: uptimePercentage ?? this.uptimePercentage,
        status: status ?? this.status,
        isToday: isToday ?? this.isToday,
      );

  factory Cell.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    final rawDate = json['date'];
    if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return Cell(
      day: json['day'] as int? ?? 0,
      date: parsedDate,
      label: json['label'] as String? ?? '',
      uptimePercentage: (json['uptime_percentage'] as num?)?.toDouble() ??
          ((json['uptimePercentage'] as num?)?.toDouble() ?? 100.0),
      status: json['status'] as String? ?? 'operational',
      isToday: json['is_today'] as bool? ?? (json['isToday'] as bool? ?? false),
    );
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'date': date.toIso8601String(),
        'label': label,
        'uptime_percentage': uptimePercentage,
        'status': status,
        'is_today': isToday,
      };
}

class Summary {
  final int operational;
  final int degraded;
  final int downtime;

  Summary({
    required this.operational,
    required this.degraded,
    required this.downtime,
  });

  Summary copyWith({
    int? operational,
    int? degraded,
    int? downtime,
  }) =>
      Summary(
        operational: operational ?? this.operational,
        degraded: degraded ?? this.degraded,
        downtime: downtime ?? this.downtime,
      );

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        operational: json['operational'] as int? ?? 0,
        degraded: json['degraded'] as int? ?? 0,
        downtime: json['downtime'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'operational': operational,
        'degraded': degraded,
        'downtime': downtime,
      };
}

class LatencyBreakdown {
  final int totalLatencyMs;
  final String totalLatencyFormatted;
  final bool isFailed;
  final List<Stage> stages;

  LatencyBreakdown({
    required this.totalLatencyMs,
    required this.totalLatencyFormatted,
    required this.isFailed,
    required this.stages,
  });

  LatencyBreakdown copyWith({
    int? totalLatencyMs,
    String? totalLatencyFormatted,
    bool? isFailed,
    List<Stage>? stages,
  }) =>
      LatencyBreakdown(
        totalLatencyMs: totalLatencyMs ?? this.totalLatencyMs,
        totalLatencyFormatted:
            totalLatencyFormatted ?? this.totalLatencyFormatted,
        isFailed: isFailed ?? this.isFailed,
        stages: stages ?? this.stages,
      );

  factory LatencyBreakdown.fromJson(Map<String, dynamic> json) =>
      LatencyBreakdown(
        totalLatencyMs: json['total_latency_ms'] as int? ??
            (json['totalLatencyMs'] as int? ?? 0),
        totalLatencyFormatted: json['total_latency_formatted'] as String? ??
            (json['totalLatencyFormatted'] as String? ?? '0ms'),
        isFailed: json['is_failed'] as bool? ??
            (json['isFailed'] as bool? ?? false),
        stages: (json['stages'] as List?)
                ?.map((e) => Stage.fromJson(_toMap(e)))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'total_latency_ms': totalLatencyMs,
        'total_latency_formatted': totalLatencyFormatted,
        'is_failed': isFailed,
        'stages': stages.map((e) => e.toJson()).toList(),
      };
}

class Stage {
  final String name;
  final int latencyMs;
  final int percentage;
  final String status;

  Stage({
    required this.name,
    required this.latencyMs,
    required this.percentage,
    required this.status,
  });

  Stage copyWith({
    String? name,
    int? latencyMs,
    int? percentage,
    String? status,
  }) =>
      Stage(
        name: name ?? this.name,
        latencyMs: latencyMs ?? this.latencyMs,
        percentage: percentage ?? this.percentage,
        status: status ?? this.status,
      );

  factory Stage.fromJson(Map<String, dynamic> json) => Stage(
        name: json['name'] as String? ?? '',
        latencyMs: json['latency_ms'] as int? ??
            (json['latencyMs'] as int? ?? 0),
        percentage: json['percentage'] as int? ?? 0,
        status: json['status'] as String? ?? 'healthy',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'latency_ms': latencyMs,
        'percentage': percentage,
        'status': status,
      };
}

class Service {
  final String id;
  final String shortId;
  final String name;
  final String url;
  final String subtitle;
  final String status;
  final int statusCode;
  final String statusLabel;
  final Metrics metrics;
  final Alert alert;

  Service({
    required this.id,
    required this.shortId,
    required this.name,
    required this.url,
    required this.subtitle,
    required this.status,
    required this.statusCode,
    required this.statusLabel,
    required this.metrics,
    required this.alert,
  });

  Service copyWith({
    String? id,
    String? shortId,
    String? name,
    String? url,
    String? subtitle,
    String? status,
    int? statusCode,
    String? statusLabel,
    Metrics? metrics,
    Alert? alert,
  }) =>
      Service(
        id: id ?? this.id,
        shortId: shortId ?? this.shortId,
        name: name ?? this.name,
        url: url ?? this.url,
        subtitle: subtitle ?? this.subtitle,
        status: status ?? this.status,
        statusCode: statusCode ?? this.statusCode,
        statusLabel: statusLabel ?? this.statusLabel,
        metrics: metrics ?? this.metrics,
        alert: alert ?? this.alert,
      );

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json['id']?.toString() ?? '',
        shortId: json['short_id'] as String? ??
            (json['shortId'] as String? ?? ''),
        name: json['name'] as String? ?? '',
        url: json['url'] as String? ?? '',
        subtitle: json['subtitle'] as String? ?? '',
        status: json['status'] as String? ?? 'operational',
        statusCode: json['status_code'] as int? ??
            (json['statusCode'] as int? ?? 200),
        statusLabel: json['status_label'] as String? ??
            (json['statusLabel'] as String? ?? ''),
        metrics: Metrics.fromJson(_toMap(json['metrics'])),
        alert: Alert.fromJson(_toMap(json['alert'])),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'short_id': shortId,
        'name': name,
        'url': url,
        'subtitle': subtitle,
        'status': status,
        'status_code': statusCode,
        'status_label': statusLabel,
        'metrics': metrics.toJson(),
        'alert': alert.toJson(),
      };
}

class Alert {
  final bool isAlert;
  final String message;

  Alert({
    required this.isAlert,
    required this.message,
  });

  Alert copyWith({
    bool? isAlert,
    String? message,
  }) =>
      Alert(
        isAlert: isAlert ?? this.isAlert,
        message: message ?? this.message,
      );

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
        isAlert: json['is_alert'] as bool? ??
            (json['isAlert'] as bool? ?? false),
        message: json['message'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'is_alert': isAlert,
        'message': message,
      };
}

class Metrics {
  final double uptime30D;
  final String uptime30DFormatted;
  final int avgLatencyMs;
  final String avgLatencyFormatted;
  final String pollCycle;

  Metrics({
    required this.uptime30D,
    required this.uptime30DFormatted,
    required this.avgLatencyMs,
    required this.avgLatencyFormatted,
    required this.pollCycle,
  });

  Metrics copyWith({
    double? uptime30D,
    String? uptime30DFormatted,
    int? avgLatencyMs,
    String? avgLatencyFormatted,
    String? pollCycle,
  }) =>
      Metrics(
        uptime30D: uptime30D ?? this.uptime30D,
        uptime30DFormatted: uptime30DFormatted ?? this.uptime30DFormatted,
        avgLatencyMs: avgLatencyMs ?? this.avgLatencyMs,
        avgLatencyFormatted: avgLatencyFormatted ?? this.avgLatencyFormatted,
        pollCycle: pollCycle ?? this.pollCycle,
      );

  factory Metrics.fromJson(Map<String, dynamic> json) => Metrics(
        uptime30D: (json['uptime_30d'] as num?)?.toDouble() ??
            ((json['uptime30D'] as num?)?.toDouble() ?? 100.0),
        uptime30DFormatted: json['uptime_30d_formatted'] as String? ??
            (json['uptime30DFormatted'] as String? ?? '100%'),
        avgLatencyMs: json['avg_latency_ms'] as int? ??
            (json['avgLatencyMs'] as int? ?? 0),
        avgLatencyFormatted: json['avg_latency_formatted'] as String? ??
            (json['avgLatencyFormatted'] as String? ?? '0ms'),
        pollCycle: json['poll_cycle'] as String? ??
            (json['pollCycle'] as String? ?? '30s'),
      );

  Map<String, dynamic> toJson() => {
        'uptime_30d': uptime30D,
        'uptime_30d_formatted': uptime30DFormatted,
        'avg_latency_ms': avgLatencyMs,
        'avg_latency_formatted': avgLatencyFormatted,
        'poll_cycle': pollCycle,
      };
}
