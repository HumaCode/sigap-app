import '../../domain/entities/incident_entity.dart';

Map<String, dynamic> _toMap(dynamic val) {
  if (val is Map) {
    return Map<String, dynamic>.from(val);
  }
  return <String, dynamic>{};
}

typedef InsidentModel = InsidenModel;

class InsidenModel {
  final bool success;
  final String message;
  final Data data;

  InsidenModel({
    required this.success,
    required this.message,
    required this.data,
  });

  InsidenModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      InsidenModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory InsidenModel.fromJson(Map<String, dynamic> json) => InsidenModel(
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
  final WarRoom warRoom;
  final Counts counts;
  final List<Item> items;
  final Meta meta;

  Data({
    required this.warRoom,
    required this.counts,
    required this.items,
    required this.meta,
  });

  Data copyWith({
    WarRoom? warRoom,
    Counts? counts,
    List<Item>? items,
    Meta? meta,
  }) =>
      Data(
        warRoom: warRoom ?? this.warRoom,
        counts: counts ?? this.counts,
        items: items ?? this.items,
        meta: meta ?? this.meta,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        warRoom: WarRoom.fromJson(_toMap(json['war_room'] ?? json['warRoom'])),
        counts: Counts.fromJson(_toMap(json['counts'])),
        items: (json['items'] as List<dynamic>?)
                ?.map((x) => Item.fromJson(_toMap(x)))
                .toList() ??
            [],
        meta: Meta.fromJson(_toMap(json['meta'])),
      );

  Map<String, dynamic> toJson() => {
        'war_room': warRoom.toJson(),
        'counts': counts.toJson(),
        'items': items.map((x) => x.toJson()).toList(),
        'meta': meta.toJson(),
      };
}

class Counts {
  final int all;
  final int critical;
  final int high;
  final int investigating;
  final int resolved;

  Counts({
    required this.all,
    required this.critical,
    required this.high,
    required this.investigating,
    required this.resolved,
  });

  Counts copyWith({
    int? all,
    int? critical,
    int? high,
    int? investigating,
    int? resolved,
  }) =>
      Counts(
        all: all ?? this.all,
        critical: critical ?? this.critical,
        high: high ?? this.high,
        investigating: investigating ?? this.investigating,
        resolved: resolved ?? this.resolved,
      );

  factory Counts.fromJson(Map<String, dynamic> json) => Counts(
        all: json['all'] as int? ?? 0,
        critical: json['critical'] as int? ?? 0,
        high: json['high'] as int? ?? 0,
        investigating: json['investigating'] as int? ?? 0,
        resolved: json['resolved'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'all': all,
        'critical': critical,
        'high': high,
        'investigating': investigating,
        'resolved': resolved,
      };
}

class Item {
  final String id;
  final String incidentCode;
  final String title;
  final String endpoint;
  final String siteId;
  final String siteName;
  final String siteUrl;
  final String type;
  final String severity;
  final String severityBadge;
  final String status;
  final String statusLabel;
  final Metrics metrics;
  final AiDiagnostic aiDiagnostic;
  final DateTime detectedAt;
  final String detectedAgo;
  final dynamic resolvedAt;

  Item({
    required this.id,
    required this.incidentCode,
    required this.title,
    required this.endpoint,
    required this.siteId,
    required this.siteName,
    required this.siteUrl,
    required this.type,
    required this.severity,
    required this.severityBadge,
    required this.status,
    required this.statusLabel,
    required this.metrics,
    required this.aiDiagnostic,
    required this.detectedAt,
    required this.detectedAgo,
    required this.resolvedAt,
  });

  Item copyWith({
    String? id,
    String? incidentCode,
    String? title,
    String? endpoint,
    String? siteId,
    String? siteName,
    String? siteUrl,
    String? type,
    String? severity,
    String? severityBadge,
    String? status,
    String? statusLabel,
    Metrics? metrics,
    AiDiagnostic? aiDiagnostic,
    DateTime? detectedAt,
    String? detectedAgo,
    dynamic resolvedAt,
  }) =>
      Item(
        id: id ?? this.id,
        incidentCode: incidentCode ?? this.incidentCode,
        title: title ?? this.title,
        endpoint: endpoint ?? this.endpoint,
        siteId: siteId ?? this.siteId,
        siteName: siteName ?? this.siteName,
        siteUrl: siteUrl ?? this.siteUrl,
        type: type ?? this.type,
        severity: severity ?? this.severity,
        severityBadge: severityBadge ?? this.severityBadge,
        status: status ?? this.status,
        statusLabel: statusLabel ?? this.statusLabel,
        metrics: metrics ?? this.metrics,
        aiDiagnostic: aiDiagnostic ?? this.aiDiagnostic,
        detectedAt: detectedAt ?? this.detectedAt,
        detectedAgo: detectedAgo ?? this.detectedAgo,
        resolvedAt: resolvedAt ?? this.resolvedAt,
      );

  factory Item.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    final rawDate = json['detected_at'] ?? json['detectedAt'];
    if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return Item(
      id: json['id']?.toString() ?? '',
      incidentCode: json['incident_code'] as String? ?? (json['incidentCode'] as String? ?? ''),
      title: json['title'] as String? ?? '',
      endpoint: json['endpoint'] as String? ?? '',
      siteId: json['site_id']?.toString() ?? (json['siteId']?.toString() ?? ''),
      siteName: json['site_name'] as String? ?? (json['siteName'] as String? ?? ''),
      siteUrl: json['site_url'] as String? ?? (json['siteUrl'] as String? ?? ''),
      type: json['type'] as String? ?? '',
      severity: json['severity'] as String? ?? '',
      severityBadge: json['severity_badge'] as String? ?? (json['severityBadge'] as String? ?? ''),
      status: json['status'] as String? ?? '',
      statusLabel: json['status_label'] as String? ?? (json['statusLabel'] as String? ?? ''),
      metrics: Metrics.fromJson(_toMap(json['metrics'])),
      aiDiagnostic: AiDiagnostic.fromJson(_toMap(json['ai_diagnostic'] ?? json['aiDiagnostic'])),
      detectedAt: parsedDate,
      detectedAgo: json['detected_ago'] as String? ?? (json['detectedAgo'] as String? ?? ''),
      resolvedAt: json['resolved_at'] ?? json['resolvedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'incident_code': incidentCode,
        'title': title,
        'endpoint': endpoint,
        'site_id': siteId,
        'site_name': siteName,
        'site_url': siteUrl,
        'type': type,
        'severity': severity,
        'severity_badge': severityBadge,
        'status': status,
        'status_label': statusLabel,
        'metrics': metrics.toJson(),
        'ai_diagnostic': aiDiagnostic.toJson(),
        'detected_at': detectedAt.toIso8601String(),
        'detected_ago': detectedAgo,
        'resolved_at': resolvedAt,
      };

  IncidentEntity toEntity() {
    final parsedErrorRate = double.tryParse(metrics.errorRate.replaceAll('%', '').trim()) ?? 0.0;
    final parsedAffected = int.tryParse(metrics.affectedUsers.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final parsedConfidence = int.tryParse(aiDiagnostic.confidence.replaceAll('%', '').trim()) ?? 90;

    return IncidentEntity(
      id: int.tryParse(id) ?? 0,
      incidentCode: incidentCode.isNotEmpty ? incidentCode : 'INC-$id',
      title: title,
      endpoint: endpoint.isNotEmpty ? endpoint : (siteName.isNotEmpty ? '$siteName ($siteUrl)' : siteUrl),
      severity: severityBadge.isNotEmpty ? severityBadge : severity,
      status: statusLabel.isNotEmpty ? statusLabel : status,
      timeAgo: detectedAgo.isNotEmpty ? detectedAgo : 'Just now',
      errorRate: parsedErrorRate,
      affectedUsers: parsedAffected,
      blastRadius: metrics.blastRadius.isNotEmpty ? metrics.blastRadius : 'Cluster Local',
      aiRootCause: aiDiagnostic.rootCause.isNotEmpty ? aiDiagnostic.rootCause : 'Automated anomaly detected',
      aiConfidence: parsedConfidence,
      aiMitigations: aiDiagnostic.recommendedSteps,
      technicianNotes: '',
    );
  }
}

class AiDiagnostic {
  final String provider;
  final String model;
  final String confidence;
  final String rootCause;
  final List<String> recommendedSteps;

  AiDiagnostic({
    required this.provider,
    required this.model,
    required this.confidence,
    required this.rootCause,
    required this.recommendedSteps,
  });

  AiDiagnostic copyWith({
    String? provider,
    String? model,
    String? confidence,
    String? rootCause,
    List<String>? recommendedSteps,
  }) =>
      AiDiagnostic(
        provider: provider ?? this.provider,
        model: model ?? this.model,
        confidence: confidence ?? this.confidence,
        rootCause: rootCause ?? this.rootCause,
        recommendedSteps: recommendedSteps ?? this.recommendedSteps,
      );

  factory AiDiagnostic.fromJson(Map<String, dynamic> json) => AiDiagnostic(
        provider: json['provider'] as String? ?? '',
        model: json['model'] as String? ?? '',
        confidence: json['confidence']?.toString() ?? '',
        rootCause: json['root_cause'] as String? ?? (json['rootCause'] as String? ?? ''),
        recommendedSteps: (json['recommended_steps'] as List? ?? json['recommendedSteps'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'provider': provider,
        'model': model,
        'confidence': confidence,
        'root_cause': rootCause,
        'recommended_steps': recommendedSteps,
      };
}

class Metrics {
  final String errorRate;
  final String affectedUsers;
  final String blastRadius;
  final String subtext;
  final String peakRps;

  Metrics({
    required this.errorRate,
    required this.affectedUsers,
    required this.blastRadius,
    required this.subtext,
    required this.peakRps,
  });

  Metrics copyWith({
    String? errorRate,
    String? affectedUsers,
    String? blastRadius,
    String? subtext,
    String? peakRps,
  }) =>
      Metrics(
        errorRate: errorRate ?? this.errorRate,
        affectedUsers: affectedUsers ?? this.affectedUsers,
        blastRadius: blastRadius ?? this.blastRadius,
        subtext: subtext ?? this.subtext,
        peakRps: peakRps ?? this.peakRps,
      );

  factory Metrics.fromJson(Map<String, dynamic> json) => Metrics(
        errorRate: json['error_rate']?.toString() ?? (json['errorRate']?.toString() ?? '0%'),
        affectedUsers: json['affected_users']?.toString() ?? (json['affectedUsers']?.toString() ?? '0'),
        blastRadius: json['blast_radius'] as String? ?? (json['blastRadius'] as String? ?? ''),
        subtext: json['subtext'] as String? ?? '',
        peakRps: json['peak_rps']?.toString() ?? (json['peakRps']?.toString() ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'error_rate': errorRate,
        'affected_users': affectedUsers,
        'blast_radius': blastRadius,
        'subtext': subtext,
        'peak_rps': peakRps,
      };
}

class Meta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final bool hasMore;

  Meta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.hasMore,
  });

  Meta copyWith({
    int? currentPage,
    int? lastPage,
    int? perPage,
    int? total,
    bool? hasMore,
  }) =>
      Meta(
        currentPage: currentPage ?? this.currentPage,
        lastPage: lastPage ?? this.lastPage,
        perPage: perPage ?? this.perPage,
        total: total ?? this.total,
        hasMore: hasMore ?? this.hasMore,
      );

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json['current_page'] as int? ?? (json['currentPage'] as int? ?? 1),
        lastPage: json['last_page'] as int? ?? (json['lastPage'] as int? ?? 1),
        perPage: json['per_page'] as int? ?? (json['perPage'] as int? ?? 15),
        total: json['total'] as int? ?? 0,
        hasMore: json['has_more'] as bool? ?? (json['hasMore'] as bool? ?? false),
      );

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'last_page': lastPage,
        'per_page': perPage,
        'total': total,
        'has_more': hasMore,
      };
}

class WarRoom {
  final int activeP1;
  final String activeP1Label;
  final int resolvedToday;
  final String resolvedTodayLabel;
  final int mttrMinutes;
  final String mttrLabel;

  WarRoom({
    required this.activeP1,
    required this.activeP1Label,
    required this.resolvedToday,
    required this.resolvedTodayLabel,
    required this.mttrMinutes,
    required this.mttrLabel,
  });

  WarRoom copyWith({
    int? activeP1,
    String? activeP1Label,
    int? resolvedToday,
    String? resolvedTodayLabel,
    int? mttrMinutes,
    String? mttrLabel,
  }) =>
      WarRoom(
        activeP1: activeP1 ?? this.activeP1,
        activeP1Label: activeP1Label ?? this.activeP1Label,
        resolvedToday: resolvedToday ?? this.resolvedToday,
        resolvedTodayLabel: resolvedTodayLabel ?? this.resolvedTodayLabel,
        mttrMinutes: mttrMinutes ?? this.mttrMinutes,
        mttrLabel: mttrLabel ?? this.mttrLabel,
      );

  factory WarRoom.fromJson(Map<String, dynamic> json) => WarRoom(
        activeP1: json['active_p1'] as int? ?? (json['activeP1'] as int? ?? 0),
        activeP1Label: json['active_p1_label'] as String? ?? (json['activeP1Label'] as String? ?? ''),
        resolvedToday: json['resolved_today'] as int? ?? (json['resolvedToday'] as int? ?? 0),
        resolvedTodayLabel: json['resolved_today_label'] as String? ?? (json['resolvedTodayLabel'] as String? ?? ''),
        mttrMinutes: json['mttr_minutes'] as int? ?? (json['mttrMinutes'] as int? ?? 0),
        mttrLabel: json['mttr_label'] as String? ?? (json['mttrLabel'] as String? ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'active_p1': activeP1,
        'active_p1_label': activeP1Label,
        'resolved_today': resolvedToday,
        'resolved_today_label': resolvedTodayLabel,
        'mttr_minutes': mttrMinutes,
        'mttr_label': mttrLabel,
      };
}
